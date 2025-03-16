package com.example.webapp.controller;

import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.User;
import com.example.webapp.service.DentistService;
import com.example.webapp.service.UserService;
import com.example.webapp.service.ClinicService;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.persistence.EntityNotFoundException;
import jakarta.validation.Valid;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/admin/dentists")
public class AdminDentistController {

    private final DentistService dentistService;
    private final UserService userService;
    private final ClinicService clinicService;

    public AdminDentistController(DentistService dentistService, UserService userService, ClinicService clinicService) {
        this.dentistService = dentistService;
        this.userService = userService;
        this.clinicService = clinicService;
    }

    @GetMapping
    public String listDentists(Model model,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "lastName") String sort,
            @RequestParam(defaultValue = "asc") String direction,
            @RequestParam(required = false) String keyword) {

        // Add current user to model
        addUserToModel(model);

        Sort.Direction sortDirection = Sort.Direction.ASC;
        if (direction.equalsIgnoreCase("desc")) {
            sortDirection = Sort.Direction.DESC;
        }

        Pageable pageable = PageRequest.of(page, size, sortDirection, sort);
        Page<Dentist> dentistPage;

        if (keyword != null && !keyword.isEmpty()) {
            dentistPage = dentistService.search(keyword, pageable);
            model.addAttribute("keyword", keyword);
        } else {
            dentistPage = dentistService.findAll(pageable);
        }

        model.addAttribute("dentists", dentistPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", dentistPage.getTotalPages());
        model.addAttribute("totalItems", dentistPage.getTotalElements());
        model.addAttribute("sortField", sort);
        model.addAttribute("sortDirection", direction);
        model.addAttribute("reverseSortDirection", direction.equals("asc") ? "desc" : "asc");

        return "admin/dentists";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        // Add current user to model
        addUserToModel(model);

        // Create a new dentist and user for the form
        model.addAttribute("dentist", new Dentist());
        model.addAttribute("user", new User());
        model.addAttribute("clinics", clinicService.findAllActive());

        return "admin/dentist-form";
    }

    @PostMapping
    public String saveDentist(
            @Valid @ModelAttribute("dentist") Dentist dentist,
            BindingResult dentistResult,
            // REMOVE THIS PARAMETER - it's causing the ID conflict:
            // @Valid @ModelAttribute("user") User user,
            // BindingResult userResult,
            @RequestParam(required = false) Long primaryClinicId,
            @RequestParam(required = false) List<Long> secondaryClinicIds,
            Model model,
            RedirectAttributes redirectAttributes) {

        try {
            // Instead of just setting user to null, use a more direct approach for existing
            // dentists
            if (dentist.getId() != null) {
                // Load existing dentist with its proper user relationship
                Dentist existingDentist = dentistService.findById(dentist.getId())
                        .orElseThrow(() -> new EntityNotFoundException("Dentist not found"));

                // Set key fields from the form to the existing record
                existingDentist.setFirstName(dentist.getFirstName());
                existingDentist.setLastName(dentist.getLastName());
                existingDentist.setSpecialization(dentist.getSpecialization());
                existingDentist.setBio(dentist.getBio());
                existingDentist.setActive(dentist.isActive());

                // Use the existing dentist with its proper user reference
                dentist = existingDentist;
            }

            // Save the dentist
            dentist = dentistService.save(dentist);

            // Handle clinic assignments
            if (primaryClinicId != null) {
                dentistService.assignPrimaryClinic(dentist.getId(), primaryClinicId);
            }

            if (secondaryClinicIds != null && !secondaryClinicIds.isEmpty()) {
                dentistService.assignSecondaryClinics(dentist.getId(), secondaryClinicIds);
            }

            redirectAttributes.addFlashAttribute("successMessage", "Dentist updated successfully");
            return "redirect:/admin/dentists";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error: " + e.getMessage());
            return "redirect:/admin/dentists";
        }
    }

    @GetMapping("/{id}")
    public String viewDentistDetails(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        // Add current user to model
        addUserToModel(model);

        Optional<Dentist> dentistOpt = dentistService.findById(id);

        if (dentistOpt.isPresent()) {
            Dentist dentist = dentistOpt.get();
            model.addAttribute("dentist", dentist);
            model.addAttribute("clinics", clinicService.findAll());
            model.addAttribute("availableClinics", clinicService.findAllActive());

            return "admin/dentist-details";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Dentist not found");
            return "redirect:/admin/dentists";
        }
    }

    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        // Add current user to model - KEEP THIS
        addUserToModel(model);

        Optional<Dentist> dentistOpt = dentistService.findById(id);

        if (dentistOpt.isPresent()) {
            Dentist dentist = dentistOpt.get();
            model.addAttribute("dentist", dentist);

            // Change this line - use a different attribute name
            model.addAttribute("dentistUser", dentist.getUser());

            model.addAttribute("clinics", clinicService.findAllActive());

            // Determine primary clinic and secondary clinics
            Optional<Clinic> primaryClinic = dentistService.getPrimaryClinic(dentist.getId());
            if (primaryClinic.isPresent()) {
                model.addAttribute("primaryClinicId", primaryClinic.get().getId());
            }

            model.addAttribute("secondaryClinicIds", dentistService.getSecondaryClinicIds(dentist.getId()));

            return "admin/dentist-form";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Dentist not found");
            return "redirect:/admin/dentists";
        }
    }

    @PostMapping("/{id}/toggle-status")
    public String toggleDentistStatus(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            dentistService.toggleStatus(id);
            redirectAttributes.addFlashAttribute("successMessage", "Dentist status updated successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating dentist status: " + e.getMessage());
        }

        return "redirect:/admin/dentists";
    }

    // Helper method to add user to model
    private void addUserToModel(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated() && !auth.getName().equals("anonymousUser")) {
            Optional<User> userOptional = userService.findByUsername(auth.getName());
            userOptional.ifPresent(user -> model.addAttribute("user", user));
        }
    }
}