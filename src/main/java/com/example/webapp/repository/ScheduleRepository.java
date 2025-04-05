package com.example.webapp.repository;

import com.example.webapp.model.Schedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ScheduleRepository extends JpaRepository<Schedule, Long> {
    
    /**
     * Find schedules by dentist ID and day of week
     * 
     * @param dentistId the ID of the dentist
     * @param dayOfWeek the day of week (e.g., "MONDAY", "TUESDAY", etc.)
     * @return list of schedules
     */
    List<Schedule> findByDentistIdAndDayOfWeek(Long dentistId, String dayOfWeek);
    
    /**
     * Find schedules by dentist ID and clinic ID
     * 
     * @param dentistId the ID of the dentist
     * @param clinicId the ID of the clinic
     * @return list of schedules
     */
    List<Schedule> findByDentistIdAndClinicId(Long dentistId, Long clinicId);
    
    /**
     * Find schedules by clinic ID and day of week
     * 
     * @param clinicId the ID of the clinic
     * @param dayOfWeek the day of week (e.g., "MONDAY", "TUESDAY", etc.)
     * @return list of schedules
     */
    List<Schedule> findByClinicIdAndDayOfWeek(Long clinicId, String dayOfWeek);
}