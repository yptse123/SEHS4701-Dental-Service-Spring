package com.example.webapp.controller.patient;

import com.example.webapp.model.*;
import com.example.webapp.service.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

@Controller
@RequestMapping("/patient")
public class PatientAppointmentController {

    private final PatientService patientService;
    private final AppointmentService appointmentService;
    private final DentistService dentistService;
    private final ClinicService clinicService;
    private final UserService userService;

    public PatientAppointmentController(PatientService patientService,
            AppointmentService appointmentService,
            DentistService dentistService,
            ClinicService clinicService,
            UserService userService) {
        this.patientService = patientService;
        this.appointmentService = appointmentService;
        this.dentistService = dentistService;
        this.clinicService = clinicService;
        this.userService = userService;
    }

    @ExceptionHandler(RuntimeException.class)
    public String handleRuntimeException(RuntimeException ex, RedirectAttributes redirectAttributes) {
        redirectAttributes.addFlashAttribute("errorMessage", ex.getMessage());
        return "redirect:/patient/appointments";
    }

    // Get current authenticated patient
    private Patient getCurrentPatient() {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        User user = userService.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        return patientService.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Patient profile not found"));
    }

    // List all appointments for the patient
    @GetMapping("/appointments")
    public String listAppointments(Model model) {
        Patient patient = getCurrentPatient();

        // Get upcoming appointments (status = SCHEDULED and date >= today)
        LocalDate today = LocalDate.now();
        List<Appointment> upcomingAppointments = appointmentService.findUpcomingByPatient(patient, today, 100);
        model.addAttribute("upcomingAppointments", upcomingAppointments);

        // Get past appointments (completed or cancelled or date < today)
        List<Appointment> pastAppointments = appointmentService.findPastByPatient(patient, today, 100);
        model.addAttribute("pastAppointments", pastAppointments);

        return "patient/appointments";
    }

    // View appointment details
    @GetMapping("/appointments/{id}")
    public String viewAppointment(@PathVariable("id") Long id, Model model) {
        Patient patient = getCurrentPatient();

        // Get the appointment
        Appointment appointment = appointmentService.findById(id)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        // Check if the appointment belongs to the authenticated patient
        if (!appointment.getPatient().getId().equals(patient.getId())) {
            throw new RuntimeException("You don't have permission to view this appointment");
        }

        model.addAttribute("appointment", appointment);

        // Format dates for the view
        LocalDate appointmentDate = appointment.getAppointmentDate();
        model.addAttribute("formattedDate",
                appointmentDate != null
                        ? appointmentDate.format(java.time.format.DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy"))
                        : "");

        LocalTime startTime = appointment.getStartTime();
        LocalTime endTime = appointment.getEndTime();
        model.addAttribute("formattedTime",
                (startTime != null && endTime != null)
                        ? startTime.format(java.time.format.DateTimeFormatter.ofPattern("h:mm a")) + " - " +
                                endTime.format(java.time.format.DateTimeFormatter.ofPattern("h:mm a"))
                        : "");

        // For status updates
        if (appointment.getCreatedAt() != null) {
            model.addAttribute("createdAtFormatted",
                    appointment.getCreatedAt()
                            .format(java.time.format.DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a")));
        }

        if (appointment.getUpdatedAt() != null) {
            model.addAttribute("updatedAtFormatted",
                    appointment.getUpdatedAt()
                            .format(java.time.format.DateTimeFormatter.ofPattern("MMM d, yyyy h:mm a")));
        }

        // Get patient's recent appointments
        List<Appointment> recentAppointments = appointmentService.findByPatient(patient, 5);
        model.addAttribute("recentAppointments", recentAppointments);

        return "patient/appointment-details";
    }

    // Show appointment booking form
    @GetMapping("/book")
    public String showBookingForm(Model model) {
        // For initial appointment form
        model.addAttribute("appointment", new Appointment());

        // Get all active clinics for selection
        List<Clinic> clinics = clinicService.findAllActive();
        model.addAttribute("clinics", clinics);

        return "patient/book-appointment";
    }

    // Handle clinic selection and date for booking
    @PostMapping("/book/select-date")
    public String selectDateAndClinic(@ModelAttribute("appointment") Appointment appointment,
            @RequestParam("clinicId") Long clinicId,
            @RequestParam("appointmentDate") @DateTimeFormat(pattern = "yyyy-MM-dd") LocalDate appointmentDate,
            Model model) {
        // Set selected clinic and date
        Clinic clinic = clinicService.findById(clinicId)
                .orElseThrow(() -> new RuntimeException("Clinic not found"));
        appointment.setClinic(clinic);
        appointment.setAppointmentDate(appointmentDate);

        // Get available time slots for the selected date and clinic
        List<Object[]> availableSlots = appointmentService.findAvailableTimeSlots(clinic, appointmentDate);
        model.addAttribute("availableSlots", availableSlots);

        // Get available dentists for the clinic
        List<Dentist> availableDentists = dentistService.findByClinic(clinic);
        model.addAttribute("dentists", availableDentists);

        // Keep clinics list for changing selection
        List<Clinic> clinics = clinicService.findAllActive();
        model.addAttribute("clinics", clinics);

        return "patient/book-appointment-time";
    }

    // Process the appointment booking
    @PostMapping("/book/confirm")
    public String confirmBooking(@ModelAttribute("appointment") @Valid Appointment appointment,
            BindingResult bindingResult,
            @RequestParam("startTime") String startTime,
            @RequestParam("endTime") String endTime,
            @RequestParam("dentistId") Long dentistId,
            RedirectAttributes redirectAttributes,
            Model model) {

        if (bindingResult.hasErrors()) {
            model.addAttribute("errorMessage", "Please check the appointment details and try again.");
            return "patient/book-appointment-time";
        }

        try {
            // Set appointment details
            Patient patient = getCurrentPatient();
            Dentist dentist = dentistService.findById(dentistId)
                    .orElseThrow(() -> new RuntimeException("Dentist not found"));

            appointment.setPatient(patient);
            appointment.setDentist(dentist);
            appointment.setStartTime(LocalTime.parse(startTime));
            appointment.setEndTime(LocalTime.parse(endTime));
            appointment.setStatus(Appointment.Status.SCHEDULED);

            // Check for conflicts before saving
            boolean hasConflict = appointmentService.checkForConflicts(
                    dentist,
                    appointment.getAppointmentDate(),
                    appointment.getStartTime(),
                    appointment.getEndTime());

            if (hasConflict) {
                model.addAttribute("errorMessage",
                        "Sorry, this time slot is no longer available. Please select another time.");

                // Reload necessary data
                Clinic clinic = appointment.getClinic();
                List<Object[]> availableSlots = appointmentService.findAvailableTimeSlots(clinic,
                        appointment.getAppointmentDate());
                model.addAttribute("availableSlots", availableSlots);

                List<Dentist> availableDentists = dentistService.findByClinic(clinic);
                model.addAttribute("dentists", availableDentists);

                return "patient/book-appointment-time";
            }

            // Save the appointment
            appointmentService.save(appointment);

            // Set success message
            redirectAttributes.addFlashAttribute("successMessage", "Your appointment has been booked successfully!");
            return "redirect:/patient/appointments";
        } catch (Exception e) {
            // Handle errors
            model.addAttribute("errorMessage", "Failed to book appointment: " + e.getMessage());

            // Reload necessary data
            List<Clinic> clinics = clinicService.findAllActive();
            model.addAttribute("clinics", clinics);

            return "patient/book-appointment-time";
        }
    }

    // Show appointment cancellation confirmation
    @GetMapping("/appointments/{id}/cancel")
    public String showCancelConfirmation(@PathVariable("id") Long id, Model model) {
        Patient patient = getCurrentPatient();

        // Get the appointment
        Appointment appointment = appointmentService.findById(id)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        // Check if the appointment belongs to the authenticated patient
        if (!appointment.getPatient().getId().equals(patient.getId())) {
            throw new RuntimeException("You don't have permission to cancel this appointment");
        }

        // Check if the appointment is in a cancellable state
        if (appointment.getStatus() != Appointment.Status.SCHEDULED) {
            throw new RuntimeException("This appointment cannot be cancelled");
        }

        model.addAttribute("appointment", appointment);

        return "patient/cancel-confirmation";
    }

    // Process appointment cancellation
    @PostMapping("/appointments/{id}/cancel")
    public String processCancellation(@PathVariable("id") Long id,
            @RequestParam(value = "cancellationReason", required = false) String cancellationReason,
            RedirectAttributes redirectAttributes) {
        Patient patient = getCurrentPatient();

        // Get the appointment
        Appointment appointment = appointmentService.findById(id)
                .orElseThrow(() -> new RuntimeException("Appointment not found"));

        // Check if the appointment belongs to the authenticated patient
        if (!appointment.getPatient().getId().equals(patient.getId())) {
            throw new RuntimeException("You don't have permission to cancel this appointment");
        }

        // Check if the appointment is in a cancellable state
        if (appointment.getStatus() != Appointment.Status.SCHEDULED) {
            throw new RuntimeException("This appointment cannot be cancelled");
        }

        // Update the appointment status
        appointment.setStatus(Appointment.Status.CANCELLED);

        // Add cancellation reason if provided
        if (cancellationReason != null && !cancellationReason.trim().isEmpty()) {
            String notes = "Cancellation reason: " + cancellationReason;
            if (appointment.getNotes() != null && !appointment.getNotes().trim().isEmpty()) {
                notes = appointment.getNotes() + "\n\n" + notes;
            }
            appointment.setNotes(notes);
        }

        // Save the appointment
        appointmentService.save(appointment);

        // Set success message
        redirectAttributes.addFlashAttribute("successMessage", "Your appointment has been cancelled successfully.");

        return "redirect:/patient/appointments";
    }
}