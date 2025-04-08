package com.example.webapp.controller;

import com.example.webapp.dto.ScheduleDTO;
import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.Schedule;
import com.example.webapp.repository.ClinicRepository;
import com.example.webapp.repository.DentistRepository;
import com.example.webapp.repository.ScheduleRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.time.LocalTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/admin/schedules")
public class ScheduleController {

    private final ScheduleRepository scheduleRepository;
    private final DentistRepository dentistRepository;
    private final ClinicRepository clinicRepository;

    @Autowired
    public ScheduleController(ScheduleRepository scheduleRepository,
            DentistRepository dentistRepository,
            ClinicRepository clinicRepository) {
        this.scheduleRepository = scheduleRepository;
        this.dentistRepository = dentistRepository;
        this.clinicRepository = clinicRepository;
    }

    @GetMapping("/dentist/{dentistId}")
    @ResponseBody
    public List<ScheduleDTO> getDentistSchedules(@PathVariable Long dentistId) {
        List<Schedule> schedules = scheduleRepository.findByDentistId(dentistId);
        return schedules.stream()
                .map(ScheduleDTO::new)
                .collect(Collectors.toList());
    }

    @PostMapping
    @ResponseBody
    public ResponseEntity<?> createSchedule(@RequestBody Map<String, String> payload) {
        try {
            Long dentistId = Long.parseLong(payload.get("dentistId"));
            Long clinicId = Long.parseLong(payload.get("clinicId"));
            String dayOfWeek = payload.get("dayOfWeek");
            LocalTime startTime = LocalTime.parse(payload.get("startTime"));
            LocalTime endTime = LocalTime.parse(payload.get("endTime"));

            // Validate input
            if (startTime.isAfter(endTime) || startTime.equals(endTime)) {
                return ResponseEntity.badRequest().body("Start time must be before end time");
            }

            // Find dentist and clinic
            Optional<Dentist> dentistOpt = dentistRepository.findById(dentistId);
            Optional<Clinic> clinicOpt = clinicRepository.findById(clinicId);

            if (dentistOpt.isEmpty() || clinicOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Invalid dentist or clinic ID");
            }

            // Check for schedule conflicts
            List<Schedule> existingSchedules = scheduleRepository.findByDentistIdAndDayOfWeek(dentistId, dayOfWeek);
            for (Schedule existing : existingSchedules) {
                if (!(endTime.isBefore(existing.getStartTime()) || startTime.isAfter(existing.getEndTime()))) {
                    return ResponseEntity.badRequest().body("Schedule conflicts with existing schedule");
                }
            }

            // Create new schedule
            Schedule schedule = new Schedule();
            schedule.setDentist(dentistOpt.get());
            schedule.setClinic(clinicOpt.get());
            schedule.setDayOfWeek(dayOfWeek);
            schedule.setStartTime(startTime);
            schedule.setEndTime(endTime);

            Schedule saved = scheduleRepository.save(schedule);
            return ResponseEntity.ok(new ScheduleDTO(saved));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error creating schedule: " + e.getMessage());
        }
    }

    @PutMapping("/{scheduleId}")
    @ResponseBody
    public ResponseEntity<?> updateSchedule(@PathVariable Long scheduleId, @RequestBody Map<String, String> payload) {
        try {
            Optional<Schedule> scheduleOpt = scheduleRepository.findById(scheduleId);
            if (scheduleOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Schedule not found");
            }

            Schedule schedule = scheduleOpt.get();

            // Update clinic if provided
            if (payload.containsKey("clinicId")) {
                Long clinicId = Long.parseLong(payload.get("clinicId"));
                Optional<Clinic> clinicOpt = clinicRepository.findById(clinicId);
                if (clinicOpt.isEmpty()) {
                    return ResponseEntity.badRequest().body("Invalid clinic ID");
                }
                schedule.setClinic(clinicOpt.get());
            }

            // Update day of week if provided
            if (payload.containsKey("dayOfWeek")) {
                schedule.setDayOfWeek(payload.get("dayOfWeek"));
            }

            // Update times if provided
            LocalTime startTime = payload.containsKey("startTime") ? LocalTime.parse(payload.get("startTime"))
                    : schedule.getStartTime();

            LocalTime endTime = payload.containsKey("endTime") ? LocalTime.parse(payload.get("endTime"))
                    : schedule.getEndTime();

            // Validate times
            if (startTime.isAfter(endTime) || startTime.equals(endTime)) {
                return ResponseEntity.badRequest().body("Start time must be before end time");
            }

            // Check for conflicts with other schedules
            Long dentistId = schedule.getDentist().getId();
            List<Schedule> existingSchedules = scheduleRepository.findByDentistIdAndDayOfWeek(dentistId,
                    schedule.getDayOfWeek());
            for (Schedule existing : existingSchedules) {
                // Skip the current schedule being updated
                if (existing.getId().equals(scheduleId)) {
                    continue;
                }

                if (!(endTime.isBefore(existing.getStartTime()) || startTime.isAfter(existing.getEndTime()))) {
                    return ResponseEntity.badRequest().body("Schedule conflicts with existing schedule");
                }
            }

            schedule.setStartTime(startTime);
            schedule.setEndTime(endTime);

            Schedule saved = scheduleRepository.save(schedule);
            return ResponseEntity.ok(new ScheduleDTO(saved));

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error updating schedule: " + e.getMessage());
        }
    }

    @DeleteMapping("/{scheduleId}")
    @ResponseBody
    public ResponseEntity<?> deleteSchedule(@PathVariable Long scheduleId) {
        try {
            Optional<Schedule> scheduleOpt = scheduleRepository.findById(scheduleId);
            if (scheduleOpt.isEmpty()) {
                return ResponseEntity.badRequest().body("Schedule not found");
            }

            scheduleRepository.delete(scheduleOpt.get());

            Map<String, String> response = new HashMap<>();
            response.put("message", "Schedule deleted successfully");
            return ResponseEntity.ok(response);

        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body("Error deleting schedule: " + e.getMessage());
        }
    }
}