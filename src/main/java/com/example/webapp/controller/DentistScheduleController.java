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
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.stream.Collectors;
import java.util.Collections;
import java.util.Comparator;

@Controller
@RequestMapping("/dentist/schedule")
public class DentistScheduleController {

    private final UserService userService;
    private final DentistService dentistService;
    private final AppointmentService appointmentService;

    public DentistScheduleController(UserService userService,
            DentistService dentistService,
            AppointmentService appointmentService) {
        this.userService = userService;
        this.dentistService = dentistService;
        this.appointmentService = appointmentService;
    }

    @GetMapping
    public String viewSchedule(
            @RequestParam(required = false) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate date,
            @RequestParam(required = false) String view,
            Model model,
            RedirectAttributes redirectAttributes) {

        // Get current authenticated user
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();

        // Get user and dentist information
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        Dentist dentist = dentistService.findByUser(user)
                .orElseThrow(() -> new RuntimeException("Dentist profile not found"));

        // Default to today's date if not specified
        LocalDate selectedDate = (date != null) ? date : LocalDate.now();

        // Default view is daily
        String selectedView = (view != null) ? view : "daily";

        // Add user and dentist info to model
        model.addAttribute("user", user);
        model.addAttribute("dentist", dentist);
        model.addAttribute("selectedDate", selectedDate);
        model.addAttribute("selectedView", selectedView);

        switch (selectedView) {
            case "daily":
                return handleDailyView(model, dentist, selectedDate);
            case "weekly":
                return handleWeeklyView(model, dentist, selectedDate);
            case "monthly":
                return handleMonthlyView(model, dentist, selectedDate);
            default:
                return handleDailyView(model, dentist, selectedDate);
        }
    }

    private String handleDailyView(Model model, Dentist dentist, LocalDate date) {
        // Get appointments for the selected date
        List<Appointment> appointments = appointmentService.findByDentistAndDate(dentist, date);

        // Format date for display
        String formattedDate = date.format(DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy"));

        model.addAttribute("appointments", appointments);
        model.addAttribute("formattedDate", formattedDate);
        model.addAttribute("previousDay", date.minusDays(1));
        model.addAttribute("nextDay", date.plusDays(1));

        return "dentist/daily-schedule";
    }

    private String handleWeeklyView(Model model, Dentist dentist, LocalDate date) {
        // Calculate start of week (Monday) and end of week (Sunday)
        LocalDate startOfWeek = date.minusDays(date.getDayOfWeek().getValue() - 1);
        LocalDate endOfWeek = startOfWeek.plusDays(6);

        // Create a map for each day with its appointments (use TreeMap for sorted keys)
        Map<LocalDate, List<Appointment>> weeklySchedule = new TreeMap<>();

        for (int i = 0; i < 7; i++) {
            LocalDate currentDate = startOfWeek.plusDays(i);
            List<Appointment> dayAppointments = appointmentService.findByDentistAndDate(dentist, currentDate);
            weeklySchedule.put(currentDate, dayAppointments);
        }

        // Format date range for display
        String weekRange = startOfWeek.format(DateTimeFormatter.ofPattern("MMM d"))
                + " - " + endOfWeek.format(DateTimeFormatter.ofPattern("MMM d, yyyy"));

        model.addAttribute("weeklySchedule", weeklySchedule);
        model.addAttribute("weekRange", weekRange);
        model.addAttribute("previousWeek", startOfWeek.minusWeeks(1));
        model.addAttribute("nextWeek", startOfWeek.plusWeeks(1));
        model.addAttribute("selectedDate", date);

        return "dentist/weekly-schedule";
    }

    private String handleMonthlyView(Model model, Dentist dentist, LocalDate date) {
        // Get first day of month and last day of month
        YearMonth yearMonth = YearMonth.from(date);
        LocalDate firstOfMonth = yearMonth.atDay(1);
        LocalDate lastOfMonth = yearMonth.atEndOfMonth();

        // Get all appointments for the month
        List<Appointment> monthAppointments = appointmentService.findByDentistBetweenDates(
                dentist, firstOfMonth, lastOfMonth);

        // Group appointments by date
        Map<LocalDate, List<Appointment>> monthlySchedule = monthAppointments.stream()
                .collect(Collectors.groupingBy(Appointment::getAppointmentDate));

        // Calendar data for display
        int firstDayOfWeek = firstOfMonth.getDayOfWeek().getValue(); // 1 = Monday, 7 = Sunday
        int daysInMonth = yearMonth.lengthOfMonth();

        // Format month for display
        String formattedMonth = date.format(DateTimeFormatter.ofPattern("MMMM yyyy"));

        // Calculate total appointments in month
        int monthAppointmentsTotal = monthAppointments.size();

        // Find busiest day
        String busiestDay = "None";
        if (!monthlySchedule.isEmpty()) {
            LocalDate busiestDate = Collections.max(
                    monthlySchedule.entrySet(),
                    Comparator.comparingInt(e -> e.getValue().size())).getKey();
            busiestDay = busiestDate.format(DateTimeFormatter.ofPattern("MMMM d"));
        }

        model.addAttribute("monthlySchedule", monthlySchedule);
        model.addAttribute("firstDayOfWeek", firstDayOfWeek);
        model.addAttribute("daysInMonth", daysInMonth);
        model.addAttribute("formattedMonth", formattedMonth);
        model.addAttribute("currentMonth", date);
        model.addAttribute("previousMonth", date.minusMonths(1));
        model.addAttribute("nextMonth", date.plusMonths(1));
        model.addAttribute("monthAppointmentsTotal", monthAppointmentsTotal);
        model.addAttribute("busiestDay", busiestDay);
        model.addAttribute("selectedDate", date);

        return "dentist/monthly-schedule";
    }
}