package com.example.webapp.service;

import com.example.webapp.model.Appointment;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.Patient;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

public interface AppointmentService {

        /**
         * Find appointment by ID
         */
        Optional<Appointment> findById(Long id);

        /**
         * Save an appointment
         */
        Appointment save(Appointment appointment);

        /**
         * Find appointments with various filters
         */
        Page<Appointment> findAppointments(
                        String keyword,
                        Long patientId,
                        Long dentistId,
                        Long clinicId,
                        String status,
                        LocalDate startDate,
                        LocalDate endDate,
                        Pageable pageable);

        /**
         * Find all appointments
         */
        List<Appointment> findAll();

        /**
         * Find appointments by patient ID
         */
        List<Appointment> findByPatientId(Long patientId);

        /**
         * Find appointments by dentist ID
         */
        List<Appointment> findByDentistId(Long dentistId);

        /**
         * Find appointments by clinic ID
         */
        List<Appointment> findByClinicId(Long clinicId);

        /**
         * Find appointments by date range
         */
        List<Appointment> findByDateRange(LocalDate startDate, LocalDate endDate);

        /**
         * Find upcoming appointments for a patient
         */
        List<Appointment> findUpcomingAppointmentsByPatientId(Long patientId);

        /**
         * Find upcoming appointments for a dentist
         */
        List<Appointment> findUpcomingAppointmentsByDentistId(Long dentistId);

        /**
         * Check if time slot is available for dentist
         */
        boolean isDentistAvailable(Long dentistId, LocalDate date,
                        java.time.LocalTime startTime, java.time.LocalTime endTime, Long excludeAppointmentId);

        /**
         * Cancel an appointment
         */
        void cancel(Long id);

        /**
         * Mark an appointment as completed
         */
        void complete(Long id);

        /**
         * Mark an appointment as no-show
         */
        void markNoShow(Long id);

        /**
         * Delete an appointment
         */
        void delete(Long id);

        /**
         * Count all active appointments
         */
        long countAllActive();

        /**
         * Count active appointments for a specific date
         */
        long countActiveByDate(LocalDate date);

        List<Appointment> findRecentAppointments(int limit);

        long countAppointmentsBetweenDates(LocalDate startDate, LocalDate endDate);

        long countByStatus(Appointment.Status status);

        List<Appointment> findByDentistAndDate(Dentist dentist, LocalDate date);

        List<Appointment> findUpcomingByDentist(Dentist dentist, LocalDate startDate, LocalDate endDate, int limit);

        long countByDentistBetweenDates(Dentist dentist, LocalDate startDate, LocalDate endDate);

        List<Appointment> findByPatient(Patient patient, int limit);

        Appointment findLastCompletedByPatient(Patient patient);

        Appointment findNextScheduledByPatient(Patient patient);

        List<Appointment> findByDentistBetweenDates(Dentist dentist, LocalDate startDate, LocalDate endDate);

        List<Appointment> findByDentistBetweenDates(Dentist dentist, LocalDate startDate, LocalDate endDate, int limit);
}