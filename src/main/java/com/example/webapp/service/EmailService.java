package com.example.webapp.service;

import com.example.webapp.model.Appointment;

public interface EmailService {
    void sendAppointmentConfirmation(Appointment appointment);
    void sendAppointmentCancellation(Appointment appointment);
    void sendAppointmentReminder(Appointment appointment);
    void sendSimpleMessage(String to, String subject, String text);
    void sendHtmlMessage(String to, String subject, String htmlContent);
}