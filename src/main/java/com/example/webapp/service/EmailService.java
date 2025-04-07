package com.example.webapp.service;

import com.example.webapp.model.Appointment;

public interface EmailService {
    void sendAppointmentConfirmation(Appointment appointment);
    void sendAppointmentCancellation(Appointment appointment);
    void sendAppointmentReminder(Appointment appointment);
    void sendSimpleMessage(String to, String subject, String text);
    void sendHtmlMessage(String to, String subject, String htmlContent);

    /**
     * Send a confirmation email to someone who submits the contact form
     * 
     * @param name The name of the person who submitted the form
     * @param email The email address of the person who submitted the form
     * @param phone The phone number provided (may be null/empty)
     * @param message The message content they submitted
     */
    void sendContactMessage(String name, String email, String phone, String message);
}