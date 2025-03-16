package com.example.webapp.controller;

import com.example.webapp.model.Appointment;
import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.Patient;
import com.example.webapp.service.AppointmentService;
import com.example.webapp.service.ClinicService;
import com.example.webapp.service.DentistService;
import com.example.webapp.service.PatientService;
import jakarta.persistence.EntityNotFoundException;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.Optional;

@Controller
@RequestMapping("/admin/appointments")
public class AdminAppointmentController {

    private final AppointmentService appointmentService;
    private final PatientService patientService;
    private final DentistService dentistService;
    private final ClinicService clinicService;

    public AdminAppointmentController(
            AppointmentService appointmentService,
            PatientService patientService,
            DentistService dentistService,
            ClinicService clinicService) {
        this.appointmentService = appointmentService;
        this.patientService = patientService;
        this.dentistService = dentistService;
        this.clinicService = clinicService;
    }

    @GetMapping
    public String listAppointments(
            Model model,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            @RequestParam(defaultValue = "appointmentDate") String sort,
            @RequestParam(defaultValue = "desc") String direction,
            @RequestParam(required = false) String keyword,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) Long patientId,
            @RequestParam(required = false) Long dentistId,
            @RequestParam(required = false) Long clinicId,
            @RequestParam(required = false) String status) {

        // Add current user to model
        addUserToModel(model);

        // Build sort
        Sort.Direction sortDirection = Sort.Direction.DESC;
        if (direction.equalsIgnoreCase("asc")) {
            sortDirection = Sort.Direction.ASC;
        }
        
        Pageable pageable = PageRequest.of(page, size, sortDirection, sort);

        // Get appointments with filters
        Page<Appointment> appointments = appointmentService.findAppointments(
                keyword, patientId, dentistId, clinicId, status, startDate, endDate, pageable);

        model.addAttribute("appointments", appointments);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", appointments.getTotalPages());
        model.addAttribute("totalItems", appointments.getTotalElements());
        model.addAttribute("sortField", sort);
        model.addAttribute("sortDirection", direction);
        model.addAttribute("reverseSortDirection", direction.equals("asc") ? "desc" : "asc");

        // Add filter options
        model.addAttribute("patients", patientService.findAllActive());
        model.addAttribute("dentists", dentistService.findAllActive());
        model.addAttribute("clinics", clinicService.findAllActive());
        model.addAttribute("statuses", Appointment.Status.values());
        
        // Add selected filters
        if (patientId != null) model.addAttribute("selectedPatient", patientService.findById(patientId).orElse(null));
        if (dentistId != null) model.addAttribute("selectedDentist", dentistService.findById(dentistId).orElse(null));
        if (clinicId != null) model.addAttribute("selectedClinic", clinicService.findById(clinicId).orElse(null));
        if (status != null) model.addAttribute("selectedStatus", status);
        if (keyword != null) model.addAttribute("keyword", keyword);
        if (startDate != null) model.addAttribute("startDate", startDate);
        if (endDate != null) model.addAttribute("endDate", endDate);

        return "admin/appointments";
    }

    @GetMapping("/new")
    public String showCreateForm(
            Model model, 
            @RequestParam(required = false) Long patientId,
            @RequestParam(required = false) Long dentistId,
            @RequestParam(required = false) Long clinicId,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date) {
        
        // Add current user to model
        addUserToModel(model);
        
        // Create new appointment
        Appointment appointment = new Appointment();
        
        // Set date if provided
        if (date != null) {
            appointment.setAppointmentDate(date);
        } else {
            // Default to tomorrow
            appointment.setAppointmentDate(LocalDate.now().plusDays(1));
        }
        
        // Set default times
        appointment.setStartTime(LocalTime.of(9, 0));
        appointment.setEndTime(LocalTime.of(10, 0));
        
        // Pre-select patient if provided
        if (patientId != null) {
            Optional<Patient> patientOpt = patientService.findById(patientId);
            patientOpt.ifPresent(appointment::setPatient);
        }
        
        // Pre-select dentist if provided
        if (dentistId != null) {
            Optional<Dentist> dentistOpt = dentistService.findById(dentistId);
            dentistOpt.ifPresent(appointment::setDentist);
        }
        
        // Pre-select clinic if provided
        if (clinicId != null) {
            Optional<Clinic> clinicOpt = clinicService.findById(clinicId);
            clinicOpt.ifPresent(appointment::setClinic);
        }
        
        model.addAttribute("appointment", appointment);
        model.addAttribute("patients", patientService.findAllActive());
        model.addAttribute("dentists", dentistService.findAllActive());
        model.addAttribute("clinics", clinicService.findAllActive());
        model.addAttribute("statuses", Appointment.Status.values());
        
        return "admin/appointment-form";
    }

    @GetMapping("/{id}")
    public String viewAppointmentDetails(
            @PathVariable Long id, 
            Model model, 
            RedirectAttributes redirectAttributes) {
        
        try {
            Appointment appointment = appointmentService.findById(id)
                    .orElseThrow(() -> new EntityNotFoundException("Appointment not found"));
            
            model.addAttribute("appointment", appointment);
            addUserToModel(model);
            
            return "admin/appointment-details";
        } catch (EntityNotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/appointments";
        }
    }

    @GetMapping("/{id}/edit")
    public String showEditForm(
            @PathVariable Long id, 
            Model model, 
            RedirectAttributes redirectAttributes) {
        
        try {
            Appointment appointment = appointmentService.findById(id)
                    .orElseThrow(() -> new EntityNotFoundException("Appointment not found"));
            
            // Only allow editing scheduled appointments
            if (appointment.getStatus() != Appointment.Status.SCHEDULED) {
                redirectAttributes.addFlashAttribute("errorMessage", 
                        "Only scheduled appointments can be edited.");
                return "redirect:/admin/appointments/" + id;
            }
            
            model.addAttribute("appointment", appointment);
            model.addAttribute("patients", patientService.findAllActive());
            model.addAttribute("dentists", dentistService.findAllActive());
            model.addAttribute("clinics", clinicService.findAllActive());
            model.addAttribute("statuses", Appointment.Status.values());
            
            addUserToModel(model);
            return "admin/appointment-form";
        } catch (EntityNotFoundException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/appointments";
        }
    }

    @PostMapping
    public String saveAppointment(
            @ModelAttribute Appointment appointment,
            BindingResult bindingResult,
            Model model,
            RedirectAttributes redirectAttributes) {
        
        if (bindingResult.hasErrors()) {
            model.addAttribute("patients", patientService.findAllActive());
            model.addAttribute("dentists", dentistService.findAllActive());
            model.addAttribute("clinics", clinicService.findAllActive());
            model.addAttribute("statuses", Appointment.Status.values());
            addUserToModel(model);
            return "admin/appointment-form";
        }
        
        try {
            // Set timestamps
            LocalDateTime now = LocalDateTime.now();
            if (appointment.getId() == null) {
                appointment.setCreatedAt(now);
            }
            appointment.setUpdatedAt(now);
            
            // Save appointment
            Appointment savedAppointment = appointmentService.save(appointment);
            
            String message = appointment.getId() == null ? 
                    "Appointment scheduled successfully" : 
                    "Appointment updated successfully";
            
            redirectAttributes.addFlashAttribute("successMessage", message);
            return "redirect:/admin/appointments/" + savedAppointment.getId();
        } catch (Exception e) {
            model.addAttribute("errorMessage", "Error saving appointment: " + e.getMessage());
            model.addAttribute("patients", patientService.findAllActive());
            model.addAttribute("dentists", dentistService.findAllActive());
            model.addAttribute("clinics", clinicService.findAllActive());
            model.addAttribute("statuses", Appointment.Status.values());
            addUserToModel(model);
            return "admin/appointment-form";
        }
    }

    @PostMapping("/{id}/cancel")
    public String cancelAppointment(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            appointmentService.cancel(id);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment cancelled successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error cancelling appointment: " + e.getMessage());
        }
        return "redirect:/admin/appointments/" + id;
    }

    @PostMapping("/{id}/complete")
    public String completeAppointment(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            appointmentService.complete(id);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment marked as completed");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating appointment: " + e.getMessage());
        }
        return "redirect:/admin/appointments/" + id;
    }

    @PostMapping("/{id}/no-show")
    public String markNoShow(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        try {
            appointmentService.markNoShow(id);
            redirectAttributes.addFlashAttribute("successMessage", "Appointment marked as no-show");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Error updating appointment: " + e.getMessage());
        }
        return "redirect:/admin/appointments/" + id;
    }

    // Helper method to add user to model
    private void addUserToModel(Model model) {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication != null && authentication.isAuthenticated()) {
            String username = authentication.getName();
            model.addAttribute("username", username);
        }
    }
}