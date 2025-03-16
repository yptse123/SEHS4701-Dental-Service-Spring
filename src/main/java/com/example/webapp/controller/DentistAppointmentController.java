package com.example.webapp.controller;

import com.example.webapp.model.Appointment;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.User;
import com.example.webapp.service.AppointmentService;
import com.example.webapp.service.DentistService;
import com.example.webapp.service.UserService;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Controller
@RequestMapping("/dentist/appointments")
public class DentistAppointmentController {

    private final UserService userService;
    private final DentistService dentistService;
    private final AppointmentService appointmentService;

    public DentistAppointmentController(
            UserService userService,
            DentistService dentistService,
            AppointmentService appointmentService) {
        this.userService = userService;
        this.dentistService = dentistService;
        this.appointmentService = appointmentService;
    }

    @GetMapping
    public String listAppointments(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @RequestParam(required = false) String patientName,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "10") int size,
            Model model) {
        
        // Get current authenticated dentist
        Dentist dentist = getCurrentDentist();
        
        // Default date range if not specified
        LocalDate effectiveStartDate = (startDate != null) ? startDate : LocalDate.now().minusDays(30);
        LocalDate effectiveEndDate = (endDate != null) ? endDate : LocalDate.now().plusDays(30);
        
        // Get appointments for this dentist with filters
        List<Appointment> appointments = appointmentService.findByDentistWithFilters(
                dentist, 
                status,
                effectiveStartDate, 
                effectiveEndDate,
                patientName,
                page,
                size);
        
        // Calculate total elements and pages for pagination
        long totalElements = appointmentService.countByDentistWithFilters(
                dentist, 
                status, 
                effectiveStartDate, 
                effectiveEndDate,
                patientName);
        
        int totalPages = (int) Math.ceil((double) totalElements / size);
        
        // Add to model
        model.addAttribute("appointments", appointments);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", size);
        
        // Add filter parameters
        model.addAttribute("status", status);
        model.addAttribute("startDate", effectiveStartDate);
        model.addAttribute("endDate", effectiveEndDate);
        model.addAttribute("patientName", patientName);
        
        // Add status options for filter
        model.addAttribute("statusOptions", Appointment.Status.values());
        
        return "dentist/appointments";
    }

    @GetMapping("/{id}")
    public String viewAppointment(@PathVariable("id") Long id, Model model) {
        // Get current authenticated dentist
        Dentist dentist = getCurrentDentist();
        
        // Get the appointment
        Appointment appointment = appointmentService.findById(id)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));
        
        // Check if the appointment belongs to the authenticated dentist
        if (!appointment.getDentist().getId().equals(dentist.getId())) {
            throw new RuntimeException("You don't have permission to view this appointment");
        }
        
        model.addAttribute("appointment", appointment);
        model.addAttribute("statusOptions", Appointment.Status.values());
        
        return "dentist/appointment-details";
    }
    
    @PostMapping("/{id}/update-status")
    public String updateAppointmentStatus(
            @PathVariable("id") Long id,
            @RequestParam Appointment.Status status,
            @RequestParam(required = false) String notes,
            RedirectAttributes redirectAttributes) {
        
        // Get current authenticated dentist
        Dentist dentist = getCurrentDentist();
        
        // Get the appointment
        Appointment appointment = appointmentService.findById(id)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));
        
        // Check if the appointment belongs to the authenticated dentist
        if (!appointment.getDentist().getId().equals(dentist.getId())) {
            throw new RuntimeException("You don't have permission to update this appointment");
        }
        
        // Update status and notes
        appointment.setStatus(status);
        if (notes != null && !notes.trim().isEmpty()) {
            String updatedNotes = (appointment.getNotes() != null ? appointment.getNotes() + "\n\n" : "")
                    + LocalDateTime.now().format(java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm"))
                    + " - Status updated to " + status + ": " + notes;
            appointment.setNotes(updatedNotes);
        }
        
        // Save appointment
        appointmentService.save(appointment);
        
        // Add success message
        redirectAttributes.addFlashAttribute("successMessage", "Appointment status updated successfully.");
        
        return "redirect:/dentist/appointments/" + id;
    }
    
    private Dentist getCurrentDentist() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        return dentistService.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Dentist profile not found"));
    }
}