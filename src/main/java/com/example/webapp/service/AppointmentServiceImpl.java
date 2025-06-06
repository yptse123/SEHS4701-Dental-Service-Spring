package com.example.webapp.service;

import com.example.webapp.model.Appointment;
import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.Patient;
import com.example.webapp.model.Schedule;
import com.example.webapp.repository.AppointmentRepository;
import com.example.webapp.repository.ClinicRepository;
import com.example.webapp.repository.DentistRepository;
import com.example.webapp.repository.PatientRepository;
import com.example.webapp.repository.ScheduleRepository;

import jakarta.persistence.EntityNotFoundException;
import jakarta.persistence.criteria.Join;
import jakarta.transaction.Transactional;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.data.domain.Sort;
import org.springframework.data.jpa.domain.Specification;
import org.springframework.stereotype.Service;

import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Optional;

@Service
public class AppointmentServiceImpl implements AppointmentService {

    private final AppointmentRepository appointmentRepository;
    private final PatientRepository patientRepository;
    private final DentistRepository dentistRepository;
    private final ClinicRepository clinicRepository;
    private final ScheduleRepository scheduleRepository;

    public AppointmentServiceImpl(
            AppointmentRepository appointmentRepository,
            PatientRepository patientRepository,
            DentistRepository dentistRepository,
            ClinicRepository clinicRepository,
            ScheduleRepository scheduleRepository) {
        this.appointmentRepository = appointmentRepository;
        this.patientRepository = patientRepository;
        this.dentistRepository = dentistRepository;
        this.clinicRepository = clinicRepository;
        this.scheduleRepository = scheduleRepository;
    }

    @Override
    public Optional<Appointment> findById(Long id) {
        return appointmentRepository.findById(id).map(this::processAppointmentDates);
    }

    // Add this helper method to process dates from database
    private Appointment processAppointmentDates(Appointment appointment) {
        // Ensure we have valid date objects
        if (appointment.getAppointmentDate() == null) {
            // Try to convert from string or SQL date if needed
            // This depends on your actual implementation
            // For demo purposes, setting a default date
            appointment.setAppointmentDate(LocalDate.now());
        }

        if (appointment.getStartTime() == null) {
            appointment.setStartTime(LocalTime.of(9, 0));
        }

        if (appointment.getEndTime() == null) {
            appointment.setEndTime(LocalTime.of(10, 0));
        }

        return appointment;
    }

    @Override
    @Transactional
    public Appointment save(Appointment appointment) {
        // Set default status for new appointments
        if (appointment.getId() == null && appointment.getStatus() == null) {
            appointment.setStatus(Appointment.Status.SCHEDULED);
        }

        // Set created/updated timestamps
        LocalDateTime now = LocalDateTime.now();
        if (appointment.getCreatedAt() == null) {
            appointment.setCreatedAt(now);
        }
        appointment.setUpdatedAt(now);

        // Check if patient exists
        if (appointment.getPatient() != null && appointment.getPatient().getId() != null) {
            Patient patient = patientRepository.findById(appointment.getPatient().getId())
                    .orElseThrow(() -> new EntityNotFoundException("Patient not found"));
            appointment.setPatient(patient);
        }

        // Check if dentist exists
        if (appointment.getDentist() != null && appointment.getDentist().getId() != null) {
            Dentist dentist = dentistRepository.findById(appointment.getDentist().getId())
                    .orElseThrow(() -> new EntityNotFoundException("Dentist not found"));
            appointment.setDentist(dentist);
        }

        // Check if clinic exists
        if (appointment.getClinic() != null && appointment.getClinic().getId() != null) {
            Clinic clinic = clinicRepository.findById(appointment.getClinic().getId())
                    .orElseThrow(() -> new EntityNotFoundException("Clinic not found"));
            appointment.setClinic(clinic);
        }

        // Check for schedule conflicts
        if (!isDentistAvailable(
                appointment.getDentist().getId(),
                appointment.getAppointmentDate(),
                appointment.getStartTime(),
                appointment.getEndTime(),
                appointment.getId())) {
            throw new RuntimeException("Dentist is already booked during this time slot");
        }

        return appointmentRepository.save(appointment);
    }

    @Override
    public Page<Appointment> findAppointments(
            String keyword,
            Long patientId,
            Long dentistId,
            Long clinicId,
            String status,
            LocalDate startDate,
            LocalDate endDate,
            Pageable pageable) {

        // Build specifications for filtering
        Specification<Appointment> spec = Specification.where(null);

        // Add keyword search if provided
        if (keyword != null && !keyword.trim().isEmpty()) {
            spec = spec.and((root, query, cb) -> {
                String pattern = "%" + keyword.toLowerCase() + "%";
                return cb.or(
                        cb.like(cb.lower(root.get("notes")), pattern),
                        cb.like(cb.lower(root.join("patient").get("firstName")), pattern),
                        cb.like(cb.lower(root.join("patient").get("lastName")), pattern),
                        cb.like(cb.lower(root.join("dentist").get("firstName")), pattern),
                        cb.like(cb.lower(root.join("dentist").get("lastName")), pattern),
                        cb.like(cb.lower(root.join("clinic").get("name")), pattern));
            });
        }

        // Filter by patient
        if (patientId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.join("patient").get("id"), patientId));
        }

        // Filter by dentist
        if (dentistId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.join("dentist").get("id"), dentistId));
        }

        // Filter by clinic
        if (clinicId != null) {
            spec = spec.and((root, query, cb) -> cb.equal(root.join("clinic").get("id"), clinicId));
        }

        // Filter by status
        if (status != null && !status.isEmpty()) {
            Appointment.Status statusEnum = Appointment.Status.valueOf(status);
            spec = spec.and((root, query, cb) -> cb.equal(root.get("status"), statusEnum));
        }

        // Filter by date range
        if (startDate != null) {
            spec = spec.and((root, query, cb) -> cb.greaterThanOrEqualTo(root.get("appointmentDate"), startDate));
        }

        if (endDate != null) {
            spec = spec.and((root, query, cb) -> cb.lessThanOrEqualTo(root.get("appointmentDate"), endDate));
        }

        return appointmentRepository.findAll(spec, pageable);
    }

    @Override
    public List<Appointment> findAll() {
        return appointmentRepository.findAll();
    }

    @Override
    public List<Appointment> findByPatientId(Long patientId) {
        return appointmentRepository.findByPatientId(patientId);
    }

    @Override
    public List<Appointment> findByDentistId(Long dentistId) {
        return appointmentRepository.findByDentistId(dentistId);
    }

    @Override
    public List<Appointment> findByClinicId(Long clinicId) {
        return appointmentRepository.findByClinicId(clinicId);
    }

    @Override
    public List<Appointment> findByDateRange(LocalDate startDate, LocalDate endDate) {
        return appointmentRepository.findByAppointmentDateBetween(startDate, endDate);
    }

    @Override
    public List<Appointment> findUpcomingAppointmentsByPatientId(Long patientId) {
        return appointmentRepository
                .findByPatientIdAndAppointmentDateGreaterThanEqualAndStatusOrderByAppointmentDateAscStartTimeAsc(
                        patientId, LocalDate.now(), Appointment.Status.SCHEDULED);
    }

    @Override
    public List<Appointment> findUpcomingAppointmentsByDentistId(Long dentistId) {
        return appointmentRepository
                .findByDentistIdAndAppointmentDateGreaterThanEqualAndStatusOrderByAppointmentDateAscStartTimeAsc(
                        dentistId, LocalDate.now(), Appointment.Status.SCHEDULED);
    }

    @Override
    public boolean isDentistAvailable(Long dentistId, LocalDate date,
            LocalTime startTime, LocalTime endTime, Long excludeAppointmentId) {

        List<Appointment> conflicts;

        if (excludeAppointmentId != null) {
            conflicts = appointmentRepository.findConflictingAppointmentsExcludingSelf(
                    dentistId, date, startTime, endTime, excludeAppointmentId);
        } else {
            conflicts = appointmentRepository.findConflictingAppointments(
                    dentistId, date, startTime, endTime);
        }

        return conflicts.isEmpty();
    }

    @Override
    @Transactional
    public void cancel(Long id) {
        Appointment appointment = findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Appointment not found"));

        appointment.setStatus(Appointment.Status.CANCELLED);
        appointment.setUpdatedAt(LocalDateTime.now());

        appointmentRepository.save(appointment);
    }

    @Override
    @Transactional
    public void complete(Long id) {
        Appointment appointment = findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Appointment not found"));

        appointment.setStatus(Appointment.Status.COMPLETED);
        appointment.setUpdatedAt(LocalDateTime.now());

        appointmentRepository.save(appointment);
    }

    @Override
    @Transactional
    public void markNoShow(Long id) {
        Appointment appointment = findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Appointment not found"));

        appointment.setStatus(Appointment.Status.NO_SHOW);
        appointment.setUpdatedAt(LocalDateTime.now());

        appointmentRepository.save(appointment);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        appointmentRepository.deleteById(id);
    }

    @Override
    public long countAllActive() {
        return appointmentRepository.countActiveAppointments();
    }

    @Override
    public long countActiveByDate(LocalDate date) {
        return appointmentRepository.countActiveAppointmentsByDate(date);
    }

    @Override
    public List<Appointment> findRecentAppointments(int limit) {
        PageRequest pageRequest = PageRequest.of(0, limit,
                Sort.by(Sort.Direction.DESC, "appointmentDate", "startTime"));
        return appointmentRepository.findAll(pageRequest).getContent();
    }

    @Override
    public long countAppointmentsBetweenDates(LocalDate startDate, LocalDate endDate) {
        return appointmentRepository.countByAppointmentDateBetween(startDate, endDate);
    }

    @Override
    public long countByStatus(Appointment.Status status) {
        return appointmentRepository.countByStatus(status);
    }

    @Override
    public List<Appointment> findByDentistAndDate(Dentist dentist, LocalDate date) {
        return appointmentRepository.findByDentistAndAppointmentDateOrderByStartTimeAsc(dentist, date);
    }

    @Override
    public List<Appointment> findUpcomingByDentist(Dentist dentist, LocalDate startDate, LocalDate endDate, int limit) {
        PageRequest pageRequest = PageRequest.of(0, limit, Sort.by(Sort.Direction.ASC, "appointmentDate", "startTime"));
        return appointmentRepository.findByDentistAndAppointmentDateBetweenAndStatus(
                dentist, startDate, endDate, Appointment.Status.SCHEDULED, pageRequest);
    }

    @Override
    public long countByDentistBetweenDates(Dentist dentist, LocalDate startDate, LocalDate endDate) {
        return appointmentRepository.countByDentistAndAppointmentDateBetween(dentist, startDate, endDate);
    }

    @Override
    public List<Appointment> findByPatient(Patient patient, int limit) {
        PageRequest pageRequest = PageRequest.of(0, limit,
                Sort.by(Sort.Direction.DESC, "appointmentDate", "startTime"));
        return appointmentRepository.findByPatient(patient, pageRequest);
    }

    @Override
    public Appointment findLastCompletedByPatient(Patient patient) {
        PageRequest pageRequest = PageRequest.of(0, 1, Sort.by(Sort.Direction.DESC, "appointmentDate", "startTime"));
        List<Appointment> completed = appointmentRepository.findByPatientAndStatus(
                patient, Appointment.Status.COMPLETED, pageRequest);
        return completed.isEmpty() ? null : completed.get(0);
    }

    @Override
    public Appointment findNextScheduledByPatient(Patient patient) {
        PageRequest pageRequest = PageRequest.of(0, 1, Sort.by(Sort.Direction.ASC, "appointmentDate", "startTime"));
        List<Appointment> scheduled = appointmentRepository.findByPatientAndStatusAndAppointmentDateGreaterThanEqual(
                patient, Appointment.Status.SCHEDULED, LocalDate.now(), pageRequest);
        return scheduled.isEmpty() ? null : scheduled.get(0);
    }

    @Override
    public List<Appointment> findByDentistBetweenDates(Dentist dentist, LocalDate startDate, LocalDate endDate) {
        return appointmentRepository.findByDentistAndAppointmentDateBetweenOrderByAppointmentDateAscStartTimeAsc(
                dentist, startDate, endDate);
    }

    @Override
    public List<Appointment> findByDentistBetweenDates(Dentist dentist, LocalDate startDate, LocalDate endDate,
            int limit) {
        PageRequest pageRequest = PageRequest.of(0, limit, Sort.by(Sort.Direction.ASC, "appointmentDate", "startTime"));
        return appointmentRepository.findByDentistAndAppointmentDateBetween(dentist, startDate, endDate, pageRequest)
                .getContent();
    }

    @Override
    public List<Appointment> findByDentistWithFilters(
            Dentist dentist,
            String status,
            LocalDate startDate,
            LocalDate endDate,
            String patientName,
            int page,
            int size) {

        // Create specification for filtering
        Specification<Appointment> spec = Specification.where(
                (root, query, criteriaBuilder) -> criteriaBuilder.equal(root.get("dentist"), dentist));

        // Add status filter if provided
        if (status != null && !status.isEmpty()) {
            try {
                Appointment.Status statusEnum = Appointment.Status.valueOf(status.toUpperCase());
                spec = spec
                        .and((root, query, criteriaBuilder) -> criteriaBuilder.equal(root.get("status"), statusEnum));
            } catch (IllegalArgumentException e) {
                // Invalid status, ignore this filter
            }
        }

        // Add date range filter
        if (startDate != null) {
            spec = spec.and((root, query, criteriaBuilder) -> criteriaBuilder
                    .greaterThanOrEqualTo(root.get("appointmentDate"), startDate));
        }

        if (endDate != null) {
            spec = spec.and((root, query, criteriaBuilder) -> criteriaBuilder
                    .lessThanOrEqualTo(root.get("appointmentDate"), endDate));
        }

        // Add patient name filter
        if (patientName != null && !patientName.isEmpty()) {
            spec = spec.and((root, query, criteriaBuilder) -> {
                Join<Appointment, Patient> patientJoin = root.join("patient");
                String pattern = "%" + patientName.toLowerCase() + "%";
                return criteriaBuilder.or(
                        criteriaBuilder.like(criteriaBuilder.lower(patientJoin.get("firstName")), pattern),
                        criteriaBuilder.like(criteriaBuilder.lower(patientJoin.get("lastName")), pattern));
            });
        }

        // Create pageable request
        Pageable pageable = PageRequest.of(page, size, Sort.by(
                Sort.Order.asc("appointmentDate"),
                Sort.Order.asc("startTime")));

        // Execute query
        Page<Appointment> appointmentsPage = appointmentRepository.findAll(spec, pageable);

        return appointmentsPage.getContent();
    }

    @Override
    public long countByDentistWithFilters(
            Dentist dentist,
            String status,
            LocalDate startDate,
            LocalDate endDate,
            String patientName) {

        // Create specification for filtering - same as above but for counting
        Specification<Appointment> spec = Specification.where(
                (root, query, criteriaBuilder) -> criteriaBuilder.equal(root.get("dentist"), dentist));

        // Add status filter if provided
        if (status != null && !status.isEmpty()) {
            try {
                Appointment.Status statusEnum = Appointment.Status.valueOf(status.toUpperCase());
                spec = spec
                        .and((root, query, criteriaBuilder) -> criteriaBuilder.equal(root.get("status"), statusEnum));
            } catch (IllegalArgumentException e) {
                // Invalid status, ignore this filter
            }
        }

        // Add date range filter
        if (startDate != null) {
            spec = spec.and((root, query, criteriaBuilder) -> criteriaBuilder
                    .greaterThanOrEqualTo(root.get("appointmentDate"), startDate));
        }

        if (endDate != null) {
            spec = spec.and((root, query, criteriaBuilder) -> criteriaBuilder
                    .lessThanOrEqualTo(root.get("appointmentDate"), endDate));
        }

        // Add patient name filter
        if (patientName != null && !patientName.isEmpty()) {
            spec = spec.and((root, query, criteriaBuilder) -> {
                Join<Appointment, Patient> patientJoin = root.join("patient");
                String pattern = "%" + patientName.toLowerCase() + "%";
                return criteriaBuilder.or(
                        criteriaBuilder.like(criteriaBuilder.lower(patientJoin.get("firstName")), pattern),
                        criteriaBuilder.like(criteriaBuilder.lower(patientJoin.get("lastName")), pattern));
            });
        }

        // Count matches
        return appointmentRepository.count(spec);
    }

    @Override
    public List<Appointment> findByDentist(Dentist dentist) {
        return appointmentRepository.findByDentist(dentist);
    }

    @Override
    public List<Appointment> findByClinic(Clinic clinic) {
        return appointmentRepository.findByClinic(clinic);
    }

    @Override
    public List<Appointment> findByStatus(Appointment.Status status) {
        return appointmentRepository.findByStatus(status);
    }

    @Override
    public List<Appointment> findByAppointmentDate(LocalDate date) {
        return appointmentRepository.findByAppointmentDate(date);
    }

    @Override
    public List<Appointment> findByPatientAndDentist(Patient patient, Dentist dentist) {
        return appointmentRepository.findByPatientAndDentist(patient, dentist);
    }

    @Override
    public int countByPatientAndStatusAndDateAfter(Patient patient, Appointment.Status status, LocalDate date) {
        return appointmentRepository.countByPatientAndStatusAndAppointmentDateGreaterThanEqual(patient, status, date);
    }

    @Override
    public int countByPatientAndDateBeforeOrStatus(Patient patient, LocalDate date, Appointment.Status status) {
        return appointmentRepository.countByPatientAndAppointmentDateLessThanOrStatus(patient, date, status);
    }

    @Override
    public List<Appointment> findUpcomingByPatient(Patient patient, LocalDate date, int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("appointmentDate").ascending()
                .and(Sort.by("startTime").ascending()));
        return appointmentRepository.findByPatientAndStatusAndAppointmentDateGreaterThanEqual(
                patient, Appointment.Status.SCHEDULED, date, pageable);
    }

    @Override
    public boolean checkForConflicts(Dentist dentist, LocalDate date, LocalTime startTime, LocalTime endTime) {
        // Find all non-cancelled appointments for this dentist on this date
        List<Appointment> existingAppointments = appointmentRepository.findByDentistAndAppointmentDateAndStatusNot(
                dentist, date, Appointment.Status.CANCELLED);

        return hasConflict(dentist, date, startTime, endTime, existingAppointments);
    }

    // Helper method to check for conflicts
    private boolean hasConflict(Dentist dentist, LocalDate date, LocalTime startTime, LocalTime endTime,
            List<Appointment> existingAppointments) {
        for (Appointment existing : existingAppointments) {
            // Skip if not for the same dentist
            if (!existing.getDentist().getId().equals(dentist.getId())) {
                continue;
            }

            // Check if the time periods overlap
            if ((startTime.isBefore(existing.getEndTime()) || startTime.equals(existing.getEndTime())) &&
                    (endTime.isAfter(existing.getStartTime()) || endTime.equals(existing.getStartTime()))) {
                return true; // Conflict found
            }
        }

        return false; // No conflict
    }

    @Override
    public List<Appointment> findPastByPatient(Patient patient, LocalDate today, int limit) {
        Pageable pageable = PageRequest.of(0, limit, Sort.by("appointmentDate").descending()
                .and(Sort.by("startTime").descending()));

        // Get past appointments (before today OR with COMPLETED/CANCELLED status)
        return appointmentRepository.findByPatientAndAppointmentDateBeforeOrPatientAndStatusIn(
                patient, today, patient,
                List.of(Appointment.Status.COMPLETED, Appointment.Status.CANCELLED, Appointment.Status.NO_SHOW),
                pageable);
    }

    @Override
    public List<Object[]> findAvailableTimeSlots(Clinic clinic, LocalDate date) {
        // Define clinic operating hours (modify these according to your business rules)
        LocalTime startOfDay = LocalTime.of(9, 0); // 9:00 AM
        LocalTime endOfDay = LocalTime.of(17, 0); // 5:00 PM
        int slotDurationMinutes = 30; // 30-minute slots

        // Get all dentists for this clinic
        List<Dentist> clinicDentists = dentistRepository.findByClinic(clinic);
        if (clinicDentists.isEmpty()) {
            return List.of(); // No dentists available at this clinic
        }

        // Get all booked appointments for this date and clinic
        List<Appointment> bookedAppointments = appointmentRepository
                .findByClinicAndAppointmentDateAndStatusNot(
                        clinic, date, Appointment.Status.CANCELLED);

        // Generate all possible time slots
        List<Object[]> availableSlots = new ArrayList<>();

        LocalTime currentTime = startOfDay;
        while (currentTime.plusMinutes(slotDurationMinutes).compareTo(endOfDay) <= 0) {
            LocalTime slotStart = currentTime;
            LocalTime slotEnd = currentTime.plusMinutes(slotDurationMinutes);

            // Check if this slot is available for at least one dentist
            boolean isAvailable = false;
            for (Dentist dentist : clinicDentists) {
                if (!hasConflict(dentist, date, slotStart, slotEnd, bookedAppointments)) {
                    isAvailable = true;
                    break;
                }
            }

            if (isAvailable) {
                availableSlots.add(new Object[] {
                        slotStart.toString(),
                        slotEnd.toString()
                });
            }

            // Move to next slot
            currentTime = currentTime.plusMinutes(slotDurationMinutes);
        }

        return availableSlots;
    }

    @Override
    public List<Map<String, String>> getDentistScheduleForDate(Dentist dentist, LocalDate date) {
        List<Map<String, String>> scheduleData = new ArrayList<>(); // Initialize as empty list

        if (dentist == null || date == null) {
            return scheduleData; // Return empty list if parameters are null
        }

        // Get the day of week for the date
        DayOfWeek dayOfWeek = date.getDayOfWeek();
        String dayOfWeekString = dayOfWeek.toString(); // This gives "MONDAY", "TUESDAY", etc.

        // Find the schedule for this dentist for this day of week
        List<Schedule> schedules = scheduleRepository.findByDentistIdAndDayOfWeek(
                dentist.getId(), dayOfWeekString);

        for (Schedule schedule : schedules) {
            Map<String, String> timeSlot = new HashMap<>();
            timeSlot.put("clinicId", String.valueOf(schedule.getClinic().getId()));
            timeSlot.put("dayOfWeek", schedule.getDayOfWeek());
            timeSlot.put("startTime", schedule.getStartTime().toString());
            timeSlot.put("endTime", schedule.getEndTime().toString());
            scheduleData.add(timeSlot);
        }

        return scheduleData; // Will be empty list if no schedules found
    }
}