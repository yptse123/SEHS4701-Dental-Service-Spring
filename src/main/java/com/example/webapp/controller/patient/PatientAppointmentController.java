package com.example.webapp.controller.patient;

import com.example.webapp.model.*;
import com.example.webapp.service.*;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/patient")
public class PatientAppointmentController {
    
    private static final Logger logger = LoggerFactory.getLogger(PatientAppointmentController.class);
    
    private final PatientService patientService;
    private final AppointmentService appointmentService;
    private final DentistService dentistService;
    private final ClinicService clinicService;
    private final UserService userService;
    private final EmailService emailService;

    public PatientAppointmentController(PatientService patientService,
            AppointmentService appointmentService,
            DentistService dentistService,
            ClinicService clinicService,
            UserService userService,
            EmailService emailService) {
        this.patientService = patientService;
        this.appointmentService = appointmentService;
        this.dentistService = dentistService;
        this.clinicService = clinicService;
        this.userService = userService;
        this.emailService = emailService;
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
    public String confirmBooking(
            @RequestParam("clinicId") Long clinicId, // Add explicit clinicId parameter
            @RequestParam("appointmentDate") @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate appointmentDate, // Add
                                                                                                                       // explicit
                                                                                                                       // date
                                                                                                                       // parameter
            @RequestParam("startTime") String startTime,
            @RequestParam("endTime") String endTime,
            @RequestParam("dentistId") Long dentistId,
            @RequestParam(value = "notes", required = false) String notes,
            RedirectAttributes redirectAttributes,
            Model model) {

        try {
            // Create a new appointment object instead of using ModelAttribute
            Appointment appointment = new Appointment();

            // Set clinic
            Clinic clinic = clinicService.findById(clinicId)
                    .orElseThrow(() -> new RuntimeException("Clinic not found with ID: " + clinicId));
            appointment.setClinic(clinic);

            // Set appointment date and times
            appointment.setAppointmentDate(appointmentDate);
            appointment.setStartTime(LocalTime.parse(startTime));
            appointment.setEndTime(LocalTime.parse(endTime));

            // Set notes if provided
            if (notes != null && !notes.trim().isEmpty()) {
                appointment.setNotes(notes);
            }

            // Set patient (current user)
            Patient patient = getCurrentPatient();
            appointment.setPatient(patient);

            // Set dentist
            Dentist dentist = dentistService.findById(dentistId)
                    .orElseThrow(() -> new RuntimeException("Dentist not found with ID: " + dentistId));
            appointment.setDentist(dentist);

            // Set status
            appointment.setStatus(Appointment.Status.SCHEDULED);

            // Check for conflicts before saving
            boolean hasConflict = appointmentService.checkForConflicts(
                    dentist,
                    appointmentDate,
                    appointment.getStartTime(),
                    appointment.getEndTime());

            if (hasConflict) {
                model.addAttribute("errorMessage",
                        "Sorry, this time slot is no longer available. Please select another time.");

                // Create appointment for form binding and set the clinic and date
                Appointment formAppointment = new Appointment();
                formAppointment.setClinic(clinic);
                formAppointment.setAppointmentDate(appointmentDate);
                model.addAttribute("appointment", formAppointment);

                // Load available time slots and dentists
                List<Object[]> availableSlots = appointmentService.findAvailableTimeSlots(clinic, appointmentDate);
                List<Dentist> availableDentists = dentistService.findByClinic(clinic);

                model.addAttribute("clinicIdValue", clinicId); // Explicitly add clinicId for the form
                model.addAttribute("availableSlots", availableSlots);
                model.addAttribute("dentists", availableDentists);

                return "patient/book-appointment-time";
            }

            // Add creation timestamps
            appointment.setCreatedAt(LocalDateTime.now());
            appointment.setUpdatedAt(LocalDateTime.now());

            // Save the appointment
            appointment = appointmentService.save(appointment);

            // Send confirmation email
            try {
                emailService.sendAppointmentConfirmation(appointment);
                logger.info("Appointment confirmation email sent for appointment ID: {}", appointment.getId());
            } catch (Exception emailEx) {
                logger.error("Failed to send confirmation email: {}", emailEx.getMessage());
                // Don't stop the process if email fails - just log the error
            }
            
            // Set success message
            redirectAttributes.addFlashAttribute("successMessage", 
                "Your appointment has been booked successfully! A confirmation email has been sent to your email address.");
            
            return "redirect:/patient/appointments";
        } catch (Exception e) {
            // Log the exception for debugging
            e.printStackTrace();

            // Handle errors
            model.addAttribute("errorMessage", "Failed to book appointment: " + e.getMessage());

            try {
                // Recreate form state for redisplay
                Clinic clinic = clinicService.findById(clinicId)
                        .orElseThrow(() -> new RuntimeException("Clinic not found"));

                // Create appointment for form binding
                Appointment formAppointment = new Appointment();
                formAppointment.setClinic(clinic);
                formAppointment.setAppointmentDate(appointmentDate);
                model.addAttribute("appointment", formAppointment);

                // Reload necessary data
                List<Object[]> availableSlots = appointmentService.findAvailableTimeSlots(clinic, appointmentDate);
                List<Dentist> availableDentists = dentistService.findByClinic(clinic);

                model.addAttribute("clinicIdValue", clinicId); // Explicitly add clinicId for the form
                model.addAttribute("availableSlots", availableSlots);
                model.addAttribute("dentists", availableDentists);
            } catch (Exception ex) {
                // If we can't recover the state, redirect to start booking process again
                redirectAttributes.addFlashAttribute("errorMessage",
                        "Something went wrong. Please try booking your appointment again.");
                return "redirect:/patient/book";
            }

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

        // Send cancellation email
        try {
            emailService.sendAppointmentCancellation(appointment);
            logger.info("Appointment cancellation email sent for appointment ID: {}", appointment.getId());
        } catch (Exception emailEx) {
            logger.error("Failed to send cancellation email: {}", emailEx.getMessage());
            // Don't stop the process if email fails - just log the error
        }

        // Set success message
        redirectAttributes.addFlashAttribute("successMessage", "Your appointment has been cancelled successfully.");

        return "redirect:/patient/appointments";
    }
}