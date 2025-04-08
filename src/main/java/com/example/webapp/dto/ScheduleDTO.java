package com.example.webapp.dto;

import com.example.webapp.model.Schedule;
import java.time.LocalTime;

public class ScheduleDTO {
    private Long id;
    private Long dentistId;
    private String dentistName;
    private Long clinicId;
    private String clinicName;
    private String dayOfWeek;
    private LocalTime startTime;
    private LocalTime endTime;
    
    public ScheduleDTO() {}
    
    public ScheduleDTO(Schedule schedule) {
        this.id = schedule.getId();
        this.dentistId = schedule.getDentist().getId();
        this.dentistName = "Dr. " + schedule.getDentist().getFirstName() + " " + schedule.getDentist().getLastName();
        this.clinicId = schedule.getClinic().getId();
        this.clinicName = schedule.getClinic().getName();
        this.dayOfWeek = schedule.getDayOfWeek();
        this.startTime = schedule.getStartTime();
        this.endTime = schedule.getEndTime();
    }
    
    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public Long getDentistId() { return dentistId; }
    public void setDentistId(Long dentistId) { this.dentistId = dentistId; }
    
    public String getDentistName() { return dentistName; }
    public void setDentistName(String dentistName) { this.dentistName = dentistName; }
    
    public Long getClinicId() { return clinicId; }
    public void setClinicId(Long clinicId) { this.clinicId = clinicId; }
    
    public String getClinicName() { return clinicName; }
    public void setClinicName(String clinicName) { this.clinicName = clinicName; }
    
    public String getDayOfWeek() { return dayOfWeek; }
    public void setDayOfWeek(String dayOfWeek) { this.dayOfWeek = dayOfWeek; }
    
    public LocalTime getStartTime() { return startTime; }
    public void setStartTime(LocalTime startTime) { this.startTime = startTime; }
    
    public LocalTime getEndTime() { return endTime; }
    public void setEndTime(LocalTime endTime) { this.endTime = endTime; }
}