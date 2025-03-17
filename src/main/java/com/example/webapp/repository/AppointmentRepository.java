package com.example.webapp.repository;

import com.example.webapp.model.Appointment;
import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.Patient;

import org.springframework.data.domain.Page;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.domain.Pageable;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

public interface AppointmentRepository extends JpaRepository<Appointment, Long>, JpaSpecificationExecutor<Appointment> {

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
         * Find appointments between date range
         */
        List<Appointment> findByAppointmentDateBetween(LocalDate startDate, LocalDate endDate);

        /**
         * Find upcoming appointments for a patient
         */
        List<Appointment> findByPatientIdAndAppointmentDateGreaterThanEqualAndStatusOrderByAppointmentDateAscStartTimeAsc(
                        Long patientId, LocalDate date, Appointment.Status status);

        /**
         * Find upcoming appointments for a dentist
         */
        List<Appointment> findByDentistIdAndAppointmentDateGreaterThanEqualAndStatusOrderByAppointmentDateAscStartTimeAsc(
                        Long dentistId, LocalDate date, Appointment.Status status);

        /**
         * Find conflicting appointments for a dentist (excluding an existing
         * appointment)
         */
        @Query("SELECT a FROM Appointment a WHERE a.dentist.id = :dentistId AND a.appointmentDate = :date " +
                        "AND a.id <> :excludeId " +
                        "AND ((a.startTime <= :endTime AND a.endTime > :startTime) OR " +
                        "(a.startTime < :endTime AND a.endTime >= :endTime) OR " +
                        "(a.startTime <= :startTime AND a.endTime >= :endTime))")
        List<Appointment> findConflictingAppointmentsExcludingSelf(
                        @Param("dentistId") Long dentistId,
                        @Param("date") LocalDate date,
                        @Param("startTime") LocalTime startTime,
                        @Param("endTime") LocalTime endTime,
                        @Param("excludeId") Long excludeId);

        /**
         * Find conflicting appointments for a dentist
         */
        @Query("SELECT a FROM Appointment a WHERE a.dentist.id = :dentistId AND a.appointmentDate = :date " +
                        "AND ((a.startTime <= :endTime AND a.endTime > :startTime) OR " +
                        "(a.startTime < :endTime AND a.endTime >= :endTime) OR " +
                        "(a.startTime <= :startTime AND a.endTime >= :endTime))")
        List<Appointment> findConflictingAppointments(
                        @Param("dentistId") Long dentistId,
                        @Param("date") LocalDate date,
                        @Param("startTime") LocalTime startTime,
                        @Param("endTime") LocalTime endTime);

        @Query("SELECT COUNT(a) FROM Appointment a WHERE a.status = com.example.webapp.model.Appointment$Status.SCHEDULED")
        long countActiveAppointments();

        @Query("SELECT COUNT(a) FROM Appointment a WHERE a.appointmentDate = :date AND a.status = com.example.webapp.model.Appointment$Status.SCHEDULED")
        long countActiveAppointmentsByDate(@Param("date") LocalDate date);

        // Add these methods to your AppointmentRepository
        long countByAppointmentDateBetween(LocalDate startDate, LocalDate endDate);

        long countByStatus(Appointment.Status status);

        List<Appointment> findByDentistAndAppointmentDateOrderByStartTimeAsc(Dentist dentist, LocalDate date);

        List<Appointment> findByDentistAndAppointmentDateBetweenAndStatus(
                        Dentist dentist, LocalDate startDate, LocalDate endDate, Appointment.Status status,
                        Pageable pageable);

        long countByDentistAndAppointmentDateBetween(Dentist dentist, LocalDate startDate, LocalDate endDate);

        List<Appointment> findByPatient(Patient patient, Pageable pageable);

        List<Appointment> findByPatientAndStatus(Patient patient, Appointment.Status status, Pageable pageable);

        List<Appointment> findByPatientAndStatusAndAppointmentDateGreaterThanEqual(
                        Patient patient, Appointment.Status status, LocalDate date, Pageable pageable);

        List<Appointment> findByDentistAndAppointmentDateBetweenOrderByAppointmentDateAscStartTimeAsc(
                        Dentist dentist, LocalDate startDate, LocalDate endDate);

        Page<Appointment> findByDentistAndAppointmentDateBetween(
                        Dentist dentist, LocalDate startDate, LocalDate endDate, Pageable pageable);

        List<Appointment> findByDentist(Dentist dentist);

        List<Appointment> findByClinic(Clinic clinic);

        List<Appointment> findByStatus(Appointment.Status status);

        List<Appointment> findByAppointmentDate(LocalDate date);

        List<Appointment> findByPatientAndDentist(Patient patient, Dentist dentist);

        int countByPatientAndStatusAndAppointmentDateGreaterThanEqual(Patient patient, Appointment.Status status,
                        LocalDate date);

        int countByPatientAndAppointmentDateLessThanOrStatus(Patient patient, LocalDate date,
                        Appointment.Status status);
}