package com.example.webapp.service;

import com.example.webapp.model.Appointment;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Service
public class EmailServiceImpl implements EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailServiceImpl.class);

    @Value("${spring.mail.username:noreply@hkdental.com}")
    private String fromEmail;

    @Value("${app.name:Hong Kong Dental Clinic}")
    private String appName;
    
    private final JavaMailSender emailSender;
    private final TemplateEngine templateEngine;

    public EmailServiceImpl(JavaMailSender emailSender) {
        this.emailSender = emailSender;
        
        // Set up a dedicated template engine for emails
        this.templateEngine = createTemplateEngine();
    }
    
    /**
     * Create and configure a template engine specifically for email templates
     */
    private TemplateEngine createTemplateEngine() {
        SpringTemplateEngine templateEngine = new SpringTemplateEngine();
        
        ClassLoaderTemplateResolver templateResolver = new ClassLoaderTemplateResolver();
        templateResolver.setPrefix("templates/emails/");  // Path in classpath
        templateResolver.setSuffix(".html");
        templateResolver.setTemplateMode(TemplateMode.HTML);
        templateResolver.setCharacterEncoding("UTF-8");
        templateResolver.setCacheable(false);  // For development, set to true for production
        
        templateEngine.setTemplateResolver(templateResolver);
        return templateEngine;
    }

    @Override
    public void sendAppointmentConfirmation(Appointment appointment) {
        try {
            // Get email address of patient
            String toEmail = appointment.getPatient().getUser().getEmail();
            String patientName = appointment.getPatient().getFirstName() + " " + appointment.getPatient().getLastName();
            
            // Format date and time
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy", Locale.ENGLISH);
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);
            
            String appointmentDate = appointment.getAppointmentDate().format(dateFormatter);
            String startTime = appointment.getStartTime().format(timeFormatter);
            String endTime = appointment.getEndTime().format(timeFormatter);
            
            // Set up Thymeleaf context
            final Context ctx = new Context();
            ctx.setVariable("patientName", patientName);
            ctx.setVariable("appointmentDate", appointmentDate);
            ctx.setVariable("startTime", startTime);
            ctx.setVariable("endTime", endTime);
            ctx.setVariable("clinicName", appointment.getClinic().getName());
            ctx.setVariable("clinicAddress", appointment.getClinic().getAddress());
            ctx.setVariable("clinicCity", appointment.getClinic().getCity());
            ctx.setVariable("clinicPostalCode", appointment.getClinic().getPostalCode());
            ctx.setVariable("dentistName", "Dr. " + appointment.getDentist().getFirstName() + " " + appointment.getDentist().getLastName());
            ctx.setVariable("appointmentId", appointment.getId());
            ctx.setVariable("appName", appName);
            
            // Process the HTML template with Thymeleaf
            final String htmlContent = this.templateEngine.process("appointment-confirmation", ctx);
            
            // Send email
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Your Dental Appointment Confirmation - " + appName);
            helper.setText(htmlContent, true);
            
            emailSender.send(message);
            logger.info("Appointment confirmation email sent to {}", toEmail);
            
        } catch (Exception e) {
            logger.error("Failed to send appointment confirmation email", e);
        }
    }

    @Override
    public void sendAppointmentCancellation(Appointment appointment) {
        try {
            String toEmail = appointment.getPatient().getUser().getEmail();
            String patientName = appointment.getPatient().getFirstName() + " " + appointment.getPatient().getLastName();
            
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy", Locale.ENGLISH);
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);
            
            final Context ctx = new Context();
            ctx.setVariable("patientName", patientName);
            ctx.setVariable("appointmentDate", appointment.getAppointmentDate().format(dateFormatter));
            ctx.setVariable("startTime", appointment.getStartTime().format(timeFormatter));
            ctx.setVariable("clinicName", appointment.getClinic().getName());
            ctx.setVariable("appointmentId", appointment.getId());
            ctx.setVariable("appName", appName);
            
            final String htmlContent = this.templateEngine.process("appointment-cancellation", ctx);
            
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Dental Appointment Cancellation - " + appName);
            helper.setText(htmlContent, true);
            
            emailSender.send(message);
            logger.info("Appointment cancellation email sent to {}", toEmail);
            
        } catch (Exception e) {
            logger.error("Failed to send appointment cancellation email", e);
        }
    }

    @Override
    public void sendAppointmentReminder(Appointment appointment) {
        try {
            String toEmail = appointment.getPatient().getUser().getEmail();
            String patientName = appointment.getPatient().getFirstName() + " " + appointment.getPatient().getLastName();
            
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy", Locale.ENGLISH);
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);
            
            final Context ctx = new Context();
            ctx.setVariable("patientName", patientName);
            ctx.setVariable("appointmentDate", appointment.getAppointmentDate().format(dateFormatter));
            ctx.setVariable("startTime", appointment.getStartTime().format(timeFormatter));
            ctx.setVariable("clinicName", appointment.getClinic().getName());
            ctx.setVariable("clinicAddress", appointment.getClinic().getAddress());
            ctx.setVariable("clinicCity", appointment.getClinic().getCity());
            ctx.setVariable("clinicPostalCode", appointment.getClinic().getPostalCode());
            ctx.setVariable("dentistName", "Dr. " + appointment.getDentist().getFirstName() + " " + appointment.getDentist().getLastName());
            ctx.setVariable("appointmentId", appointment.getId());
            ctx.setVariable("appName", appName);
            
            final String htmlContent = this.templateEngine.process("appointment-reminder", ctx);
            
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Reminder: Your Dental Appointment Tomorrow - " + appName);
            helper.setText(htmlContent, true);
            
            emailSender.send(message);
            logger.info("Appointment reminder email sent to {}", toEmail);
            
        } catch (Exception e) {
            logger.error("Failed to send appointment reminder email", e);
        }
    }

    @Override
    public void sendSimpleMessage(String to, String subject, String text) {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            
            emailSender.send(message);
            logger.info("Simple email sent to {}", to);
        } catch (Exception e) {
            logger.error("Failed to send simple email", e);
        }
    }

    @Override
    public void sendHtmlMessage(String to, String subject, String htmlContent) {
        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");
            
            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);
            
            emailSender.send(message);
            logger.info("HTML email sent to {}", to);
        } catch (Exception e) {
            logger.error("Failed to send HTML email", e);
        }
    }
}