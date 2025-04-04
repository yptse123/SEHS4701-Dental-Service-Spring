package com.example.webapp.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.time.format.TextStyle;
import java.time.temporal.TemporalAdjusters;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

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

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
public class DashboardController {

    private final UserService userService;
    private final PatientService patientService;
    private final DentistService dentistService;
    private final ClinicService clinicService;
    private final AppointmentService appointmentService;
    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

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
        } else if (role.equals("ROLE_DENTIST")) {

            logger.info("Dentist dashboard accessed by user: {}", username);

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

            // Weekly Schedule - Add this new section
            List<Map<String, Object>> weeklySchedule = new ArrayList<>();

            // Generate data for each day of the current week
            for (int i = 0; i < 7; i++) {
                LocalDate currentDay = startOfWeek.plusDays(i);

                Map<String, Object> dayData = new HashMap<>();
                dayData.put("dayOfWeek", currentDay.getDayOfWeek().getDisplayName(TextStyle.FULL, Locale.getDefault()));
                dayData.put("date", currentDay);
                dayData.put("formattedDate", currentDay.format(DateTimeFormatter.ofPattern("MMM d")));
                dayData.put("isToday", currentDay.equals(today));

                // Get schedules for this day
                List<Appointment> dayAppointments = appointmentService.findByDentistAndDate(dentist, currentDay);

                // Convert appointments to schedule format
                List<Map<String, Object>> schedules = new ArrayList<>();
                for (Appointment apt : dayAppointments) {
                    Map<String, Object> schedule = new HashMap<>();
                    schedule.put("startTime", apt.getStartTime());
                    schedule.put("endTime", apt.getEndTime());
                    schedule.put("clinic", apt.getClinic());
                    schedule.put("patient", apt.getPatient());
                    schedule.put("status", apt.getStatus());
                    schedule.put("appointmentId", apt.getId());
                    schedules.add(schedule);
                }

                dayData.put("schedules", schedules);
                weeklySchedule.add(dayData);
            }

            model.addAttribute("weeklySchedule", weeklySchedule);
        } else if (role.equals("ROLE_PATIENT")) {

            logger.info("Patient dashboard accessed by user: {}", username);
            
            // Patient-specific dashboard data
            Patient patient = patientService.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Patient profile not found"));
            
            // Count upcoming appointments (future appointments with SCHEDULED status)
            int upcomingCount = appointmentService.countByPatientAndStatusAndDateAfter(
                patient, Appointment.Status.SCHEDULED, today);
            model.addAttribute("upcomingAppointmentsCount", upcomingCount);
            
            // Count past appointments (appointments before today or with COMPLETED status)
            int pastCount = appointmentService.countByPatientAndDateBeforeOrStatus(
                patient, today, Appointment.Status.COMPLETED);
            model.addAttribute("pastAppointmentsCount", pastCount);
            
            // Get patient's upcoming appointments
            List<Appointment> upcomingAppointments = appointmentService.findUpcomingByPatient(
                patient, today, 5);
            model.addAttribute("upcomingAppointments", upcomingAppointments);
            
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