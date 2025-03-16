package com.example.webapp.controller;

import java.time.LocalDate;
import java.time.temporal.TemporalAdjusters;
import java.util.List;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import com.example.webapp.model.Appointment;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.Patient;
import com.example.webapp.model.User;
import com.example.webapp.service.AppointmentService;
import com.example.webapp.service.ClinicService;
import com.example.webapp.service.DentistService;
import com.example.webapp.service.PatientService;
import com.example.webapp.service.UserService;

@Controller
public class DashboardController {

    private final UserService userService;
    private final PatientService patientService;
    private final DentistService dentistService;
    private final ClinicService clinicService;
    private final AppointmentService appointmentService;

    public DashboardController(UserService userService,
            PatientService patientService,
            DentistService dentistService,
            ClinicService clinicService,
            AppointmentService appointmentService) {
        this.userService = userService;
        this.patientService = patientService;
        this.dentistService = dentistService;
        this.clinicService = clinicService;
        this.appointmentService = appointmentService;
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, Authentication authentication) {
        // Get user details
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String username = userDetails.getUsername();

        // Get complete user object from database
        User user = userService.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        model.addAttribute("user", user); // Set user object for JSP
        
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String role = auth.getAuthorities().stream().findFirst().orElseThrow().getAuthority();
        model.addAttribute("username", auth.getName());
        model.addAttribute("role", role.replace("ROLE_", ""));
        
        // Basic counts for all roles
        model.addAttribute("patientsCount", patientService.countAllActive());
        model.addAttribute("dentistsCount", dentistService.countAllActive());
        model.addAttribute("clinicsCount", clinicService.countAllActive());
        model.addAttribute("todayAppointmentsCount", appointmentService.countActiveByDate(LocalDate.now()));
        
        // Calculate this week's appointments (current week from Monday to Sunday)
        LocalDate today = LocalDate.now();
        LocalDate startOfWeek = today.with(TemporalAdjusters.previousOrSame(java.time.DayOfWeek.MONDAY));
        LocalDate endOfWeek = today.with(TemporalAdjusters.nextOrSame(java.time.DayOfWeek.SUNDAY));
        model.addAttribute("weeklyAppointmentsCount", 
            appointmentService.countAppointmentsBetweenDates(startOfWeek, endOfWeek));
        
        // Recent appointments - for all users
        List<Appointment> recentAppointments = appointmentService.findRecentAppointments(10);
        model.addAttribute("recentAppointments", recentAppointments);
        
        // Add role-specific data
        if (role.equals("ROLE_ADMIN")) {
            // Admin-specific dashboard data
            model.addAttribute("pendingAppointmentsCount", 
                appointmentService.countByStatus(Appointment.Status.SCHEDULED));
        } 
        else if (role.equals("ROLE_DENTIST")) {
            // Dentist-specific dashboard data
            Dentist dentist = dentistService.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Dentist profile not found"));
            
            // Get dentist's today's appointments
            List<Appointment> todayAppointments = appointmentService.findByDentistAndDate(
                dentist, LocalDate.now());
            model.addAttribute("todayAppointments", todayAppointments);
            
            // Get dentist's upcoming appointments (next 7 days)
            List<Appointment> upcomingAppointments = appointmentService.findUpcomingByDentist(
                dentist, LocalDate.now(), LocalDate.now().plusDays(7), 5);
            model.addAttribute("upcomingAppointments", upcomingAppointments);
            
            // Count for dentist's appointments this week
            model.addAttribute("dentistWeeklyAppointmentsCount", 
                appointmentService.countByDentistBetweenDates(dentist, startOfWeek, endOfWeek));
        } 
        else if (role.equals("ROLE_PATIENT")) {
            // Patient-specific dashboard data
            Patient patient = patientService.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Patient profile not found"));
            
            // Get patient's upcoming appointments
            List<Appointment> patientAppointments = appointmentService.findByPatient(
                patient, 5);
            model.addAttribute("patientAppointments", patientAppointments);
            
            // Get last visit date
            Appointment lastVisit = appointmentService.findLastCompletedByPatient(patient);
            model.addAttribute("lastVisit", lastVisit);
            
            // Get next scheduled appointment
            Appointment nextAppointment = appointmentService.findNextScheduledByPatient(patient);
            model.addAttribute("nextAppointment", nextAppointment);
        }

        return "dashboard";
    }
}