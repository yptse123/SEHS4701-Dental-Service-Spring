package com.example.webapp.controller;

import com.example.webapp.model.Patient;
import com.example.webapp.model.User;
import com.example.webapp.service.PatientService;
import com.example.webapp.service.UserService;

import jakarta.persistence.EntityNotFoundException;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDateTime;
import java.util.Optional;
import org.springframework.security.crypto.password.PasswordEncoder;

@Controller
@RequestMapping("/admin/patients")
public class AdminPatientController {

    private final PatientService patientService;
    private final UserService userService;

    public AdminPatientController(PatientService patientService, UserService userService,
            PasswordEncoder passwordEncoder) {
        this.patientService = patientService;
        this.userService = userService;
    }

    @GetMapping
    public String listPatients(Model model,
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
        Page<Patient> patientPage;

        if (keyword != null && !keyword.isEmpty()) {
            patientPage = patientService.search(keyword, pageable);
            model.addAttribute("keyword", keyword);
        } else {
            patientPage = patientService.findAll(pageable);
        }

        model.addAttribute("patients", patientPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", patientPage.getTotalPages());
        model.addAttribute("totalItems", patientPage.getTotalElements());
        model.addAttribute("sortField", sort);
        model.addAttribute("sortDirection", direction);
        model.addAttribute("reverseSortDirection", direction.equals("asc") ? "desc" : "asc");

        return "admin/patients";
    }

    @GetMapping("/new")
    public String showCreateForm(Model model) {
        // Add current user to model
        addUserToModel(model);

        // Create a new patient and user for the form
        model.addAttribute("patient", new Patient());
        model.addAttribute("user", new User());

        return "admin/patient-form";
    }

    @PostMapping
    public String savePatient(@ModelAttribute Patient patient,
            @RequestParam(required = false) Long userId,
            @RequestParam(required = false) String username,
            @RequestParam(required = false) String email,
            RedirectAttributes redirectAttributes) {
        try {
            if (patient.getId() != null) { // FIXED: This was == null before
                // Existing patient - load from database
                Patient existingPatient = patientService.findById(patient.getId())
                        .orElseThrow(() -> new EntityNotFoundException("Patient not found"));

                // Update fields
                existingPatient.setFirstName(patient.getFirstName());
                existingPatient.setLastName(patient.getLastName());
                existingPatient.setPhoneNumber(patient.getPhoneNumber());
                existingPatient.setDateOfBirth(patient.getDateOfBirth());
                existingPatient.setAddress(patient.getAddress());

                // Explicitly set active status
                existingPatient.setActive(patient.isActive());

                // Debug
                System.out.println("Updating patient #" + patient.getId() + ", active status: " + patient.isActive());

                // Update timestamp
                existingPatient.setUpdatedAt(LocalDateTime.now());

                // Save the updated patient
                patientService.save(existingPatient);
                redirectAttributes.addFlashAttribute("successMessage", "Patient updated successfully");
            } else {
                // This is an existing patient, load current patient to preserve user
                // relationship
                Patient existingPatient = patientService.findById(patient.getId())
                        .orElseThrow(() -> new RuntimeException("Patient not found"));
                patient.setUser(existingPatient.getUser());

                patientService.save(patient);
                redirectAttributes.addFlashAttribute("successMessage", "Patient created successfully");
            }

            return "redirect:/admin/patients";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/patients";
        }
    }

    @GetMapping("/{id}")
    public String viewPatientDetails(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        // Add current user to model
        addUserToModel(model);

        Optional<Patient> patientOpt = patientService.findById(id);

        if (patientOpt.isPresent()) {
            Patient patient = patientOpt.get();
            model.addAttribute("patient", patient);

            return "admin/patient-details";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Patient not found");
            return "redirect:/admin/patients";
        }
    }

    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        // Add current user to model
        addUserToModel(model);

        Optional<Patient> patientOpt = patientService.findById(id);

        if (patientOpt.isPresent()) {
            Patient patient = patientOpt.get();
            model.addAttribute("patient", patient);

            // Change this line - use a different attribute name
            model.addAttribute("patientUser", patient.getUser());

            return "admin/patient-form";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Patient not found");
            return "redirect:/admin/patients";
        }
    }

    @PostMapping("/{id}/toggle-status")
    public String togglePatientStatus(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            Patient patient = patientService.findById(id)
                    .orElseThrow(() -> new EntityNotFoundException("Patient not found"));

            // Toggle the active status
            patient.setActive(!patient.isActive());

            // Update the timestamp
            patient.setUpdatedAt(LocalDateTime.now());

            // Save the patient
            patientService.save(patient);

            String statusMessage = patient.isActive() ? "activated" : "deactivated";
            redirectAttributes.addFlashAttribute("successMessage",
                    "Patient has been " + statusMessage + " successfully.");

            return "redirect:/admin/patients";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    "Failed to update patient status: " + e.getMessage());
            return "redirect:/admin/patients";
        }
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