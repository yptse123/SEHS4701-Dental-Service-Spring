package com.example.webapp.repository;

import com.example.webapp.model.Appointment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.JpaSpecificationExecutor;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

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
     * Find conflicting appointments for a dentist (excluding an existing appointment)
     */
    @Query("SELECT a FROM Appointment a WHERE a.dentist.id = :dentistId " +
           "AND a.appointmentDate = :date " +
           "AND a.id <> :excludeId " +
           "AND a.status = com.example.webapp.model.Appointment$Status.SCHEDULED " +
           "AND ((a.startTime <= :endTime AND a.endTime >= :startTime))")
    List<Appointment> findConflictingAppointmentsExcludingSelf(
            @Param("dentistId") Long dentistId,
            @Param("date") LocalDate date,
            @Param("startTime") LocalTime startTime,
            @Param("endTime") LocalTime endTime,
            @Param("excludeId") Long excludeId);
    
    /**
     * Find conflicting appointments for a dentist
     */
    @Query("SELECT a FROM Appointment a WHERE a.dentist.id = :dentistId " +
           "AND a.appointmentDate = :date " +
           "AND a.status = com.example.webapp.model.Appointment$Status.SCHEDULED " +
           "AND ((a.startTime <= :endTime AND a.endTime >= :startTime))")
    List<Appointment> findConflictingAppointments(
            @Param("dentistId") Long dentistId,
            @Param("date") LocalDate date,
            @Param("startTime") LocalTime startTime,
            @Param("endTime") LocalTime endTime);
}