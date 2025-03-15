package com.example.webapp.controller;

import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.service.ClinicService;
import com.example.webapp.service.DentistService;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.Optional;

@Controller
@RequestMapping("/admin/clinics")
public class AdminClinicController {

    private final ClinicService clinicService;
    private final DentistService dentistService;

    public AdminClinicController(ClinicService clinicService, DentistService dentistService) {
        this.clinicService = clinicService;
        this.dentistService = dentistService;
    }

    @GetMapping
    public String listClinics(Model model, 
                            @RequestParam(defaultValue = "0") int page,
                            @RequestParam(defaultValue = "10") int size,
                            @RequestParam(defaultValue = "name") String sort,
                            @RequestParam(defaultValue = "asc") String direction,
                            @RequestParam(required = false) String keyword) {
        
        Sort.Direction sortDirection = Sort.Direction.ASC;
        if (direction.equalsIgnoreCase("desc")) {
            sortDirection = Sort.Direction.DESC;
        }
        
        Pageable pageable = PageRequest.of(page, size, sortDirection, sort);
        Page<Clinic> clinicPage;
        
        if (keyword != null && !keyword.isEmpty()) {
            clinicPage = clinicService.search(keyword, pageable);
            model.addAttribute("keyword", keyword);
        } else {
            clinicPage = clinicService.findAll(pageable);
        }
        
        model.addAttribute("clinics", clinicPage);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", clinicPage.getTotalPages());
        model.addAttribute("totalItems", clinicPage.getTotalElements());
        model.addAttribute("sortField", sort);
        model.addAttribute("sortDirection", direction);
        model.addAttribute("reverseSortDirection", direction.equals("asc") ? "desc" : "asc");
        
        return "admin/clinics";
    }
    
    @GetMapping("/new")
    public String showCreateForm(Model model) {
        model.addAttribute("clinic", new Clinic());
        return "admin/clinic-form";
    }
    
    @PostMapping
    public String createClinic(@Valid @ModelAttribute("clinic") Clinic clinic, 
                               BindingResult result, 
                               RedirectAttributes redirectAttributes) {
        
        if (clinic.getId() == null && clinicService.existsByName(clinic.getName())) {
            result.rejectValue("name", "error.clinic", "A clinic with this name already exists");
        }
        
        if (result.hasErrors()) {
            return "admin/clinic-form";
        }
        
        clinicService.save(clinic);
        redirectAttributes.addFlashAttribute("successMessage", 
                                           clinic.getId() == null ? 
                                           "Clinic created successfully" : "Clinic updated successfully");
        
        return "redirect:/admin/clinics";
    }
    
    @GetMapping("/{id}/edit")
    public String showEditForm(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Clinic> clinicOpt = clinicService.findById(id);
        
        if (clinicOpt.isPresent()) {
            model.addAttribute("clinic", clinicOpt.get());
            return "admin/clinic-form";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Clinic not found");
            return "redirect:/admin/clinics";
        }
    }
    
    @GetMapping("/{id}")
    public String viewClinicDetails(@PathVariable Long id, Model model, RedirectAttributes redirectAttributes) {
        Optional<Clinic> clinicOpt = clinicService.findById(id);
        
        if (clinicOpt.isPresent()) {
            Clinic clinic = clinicOpt.get();
            model.addAttribute("clinic", clinic);
            model.addAttribute("dentists", dentistService.findByClinic(clinic));
            model.addAttribute("allDentists", dentistService.findAll());
            return "admin/clinic-details";
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Clinic not found");
            return "redirect:/admin/clinics";
        }
    }
    
    @PostMapping("/{id}/toggle-status")
    public String toggleClinicStatus(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        Optional<Clinic> clinicOpt = clinicService.findById(id);
        
        if (clinicOpt.isPresent()) {
            Clinic clinic = clinicOpt.get();
            clinic.setActive(!clinic.isActive());
            clinicService.save(clinic);
            
            redirectAttributes.addFlashAttribute("successMessage", 
                clinic.isActive() ? "Clinic activated successfully" : "Clinic deactivated successfully");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Clinic not found");
        }
        
        return "redirect:/admin/clinics";
    }
    
    @PostMapping("/{clinicId}/assign-dentist")
    public String assignDentist(@PathVariable Long clinicId,
                              @RequestParam Long dentistId,
                              @RequestParam(defaultValue = "false") boolean isPrimary,
                              RedirectAttributes redirectAttributes) {
        
        Optional<Clinic> clinicOpt = clinicService.findById(clinicId);
        Optional<Dentist> dentistOpt = dentistService.findById(dentistId);
        
        if (clinicOpt.isPresent() && dentistOpt.isPresent()) {
            clinicService.assignDentistToClinic(dentistOpt.get(), clinicOpt.get(), isPrimary);
            redirectAttributes.addFlashAttribute("successMessage", "Dentist assigned to clinic successfully");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Clinic or dentist not found");
        }
        
        return "redirect:/admin/clinics/" + clinicId;
    }
    
    @PostMapping("/{clinicId}/remove-dentist")
    public String removeDentist(@PathVariable Long clinicId,
                              @RequestParam Long dentistId,
                              RedirectAttributes redirectAttributes) {
        
        Optional<Clinic> clinicOpt = clinicService.findById(clinicId);
        Optional<Dentist> dentistOpt = dentistService.findById(dentistId);
        
        if (clinicOpt.isPresent() && dentistOpt.isPresent()) {
            clinicService.removeDentistFromClinic(dentistOpt.get(), clinicOpt.get());
            redirectAttributes.addFlashAttribute("successMessage", "Dentist removed from clinic successfully");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "Clinic or dentist not found");
        }
        
        return "redirect:/admin/clinics/" + clinicId;
    }
}