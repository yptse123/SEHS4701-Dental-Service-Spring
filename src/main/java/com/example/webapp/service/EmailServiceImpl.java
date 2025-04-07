package com.example.webapp.service;

import com.example.webapp.model.Appointment;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Locale;

@Service
public class EmailServiceImpl implements EmailService {

    private static final Logger logger = LoggerFactory.getLogger(EmailServiceImpl.class);
    private static final DateTimeFormatter LOG_TIMESTAMP = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");

    @Value("${spring.mail.username}")
    private String fromEmail;

    @Value("${app.name:Hong Kong Dental Clinic}")
    private String appName;

    @Value("${app.base-url:https://hkdental.me}")
    private String baseUrl;

    private final JavaMailSender emailSender;
    private final TemplateEngine templateEngine;

    public EmailServiceImpl(JavaMailSender emailSender, TemplateEngine templateEngine) {
        this.emailSender = emailSender;
        this.templateEngine = templateEngine;
    }

    @Override
    public void sendAppointmentConfirmation(Appointment appointment) {
        String toEmail = appointment.getPatient().getUser().getEmail();
        String logPrefix = createLogPrefix("CONFIRMATION", appointment.getId());

        logger.info("{} Preparing to send appointment confirmation email FROM: {} TO: {}",
                logPrefix, fromEmail, toEmail);

        try {
            String patientName = appointment.getPatient().getFirstName() + " " + appointment.getPatient().getLastName();

            // Format date and time
            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy", Locale.ENGLISH);
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);

            String appointmentDate = appointment.getAppointmentDate().format(dateFormatter);
            String startTime = appointment.getStartTime().format(timeFormatter);
            String endTime = appointment.getEndTime().format(timeFormatter);

            // Set up Thymeleaf context
            final Context ctx = new Context();
            ctx.setVariable("baseUrl", baseUrl);
            ctx.setVariable("patientName", patientName);
            ctx.setVariable("appointmentDate", appointmentDate);
            ctx.setVariable("startTime", startTime);
            ctx.setVariable("endTime", endTime);
            ctx.setVariable("clinicName", appointment.getClinic().getName());
            ctx.setVariable("clinicAddress", appointment.getClinic().getAddress());
            ctx.setVariable("clinicCity", appointment.getClinic().getCity());
            ctx.setVariable("clinicPostalCode", appointment.getClinic().getPostalCode());
            ctx.setVariable("dentistName",
                    "Dr. " + appointment.getDentist().getFirstName() + " " + appointment.getDentist().getLastName());
            ctx.setVariable("appointmentId", appointment.getId());
            ctx.setVariable("appName", appName);

            logger.debug("{} Template context variables set successfully", logPrefix);

            // Process the HTML template with Thymeleaf
            final String htmlContent = this.templateEngine.process("appointment-confirmation", ctx);
            logger.debug("{} Template processed successfully", logPrefix);

            // Send email
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Your Dental Appointment Confirmation - " + appName);
            helper.setText(htmlContent, true);

            logger.debug("{} About to send email message", logPrefix);
            long startTimeL = System.currentTimeMillis();

            emailSender.send(message);

            long endTimeL = System.currentTimeMillis();
            logger.info("{} Email sent successfully FROM: {} TO: {} in {}ms",
                    logPrefix, fromEmail, toEmail, (endTimeL - startTimeL));

        } catch (MessagingException e) {
            logger.error("{} Failed to prepare confirmation email TO: {} - Error: {}",
                    logPrefix, toEmail, e.getMessage(), e);
        } catch (MailException e) {
            logger.error("{} Failed to send confirmation email FROM: {} TO: {} - Error: {}",
                    logPrefix, fromEmail, toEmail, e.getMessage(), e);
        } catch (Exception e) {
            logger.error("{} Unexpected error sending confirmation email TO: {} - Error: {}",
                    logPrefix, toEmail, e.getMessage(), e);
        }
    }

    @Override
    public void sendAppointmentCancellation(Appointment appointment) {
        String toEmail = appointment.getPatient().getUser().getEmail();
        String logPrefix = createLogPrefix("CANCELLATION", appointment.getId());

        logger.info("{} Preparing to send appointment cancellation email FROM: {} TO: {}",
                logPrefix, fromEmail, toEmail);

        try {
            String patientName = appointment.getPatient().getFirstName() + " " + appointment.getPatient().getLastName();

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy", Locale.ENGLISH);
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);

            final Context ctx = new Context();
            ctx.setVariable("baseUrl", baseUrl);
            ctx.setVariable("patientName", patientName);
            ctx.setVariable("appointmentDate", appointment.getAppointmentDate().format(dateFormatter));
            ctx.setVariable("startTime", appointment.getStartTime().format(timeFormatter));
            ctx.setVariable("clinicName", appointment.getClinic().getName());
            ctx.setVariable("appointmentId", appointment.getId());
            ctx.setVariable("appName", appName);

            logger.debug("{} Template context variables set successfully", logPrefix);

            final String htmlContent = this.templateEngine.process("appointment-cancellation", ctx);
            logger.debug("{} Template processed successfully", logPrefix);

            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Dental Appointment Cancellation - " + appName);
            helper.setText(htmlContent, true);

            logger.debug("{} About to send email message", logPrefix);
            long startTime = System.currentTimeMillis();

            emailSender.send(message);

            long endTime = System.currentTimeMillis();
            logger.info("{} Email sent successfully FROM: {} TO: {} in {}ms",
                    logPrefix, fromEmail, toEmail, (endTime - startTime));

        } catch (MessagingException e) {
            logger.error("{} Failed to prepare cancellation email TO: {} - Error: {}",
                    logPrefix, toEmail, e.getMessage(), e);
        } catch (MailException e) {
            logger.error("{} Failed to send cancellation email FROM: {} TO: {} - Error: {}",
                    logPrefix, fromEmail, toEmail, e.getMessage(), e);
        } catch (Exception e) {
            logger.error("{} Unexpected error sending cancellation email TO: {} - Error: {}",
                    logPrefix, toEmail, e.getMessage(), e);
        }
    }

    @Override
    public void sendAppointmentReminder(Appointment appointment) {
        String toEmail = appointment.getPatient().getUser().getEmail();
        String logPrefix = createLogPrefix("REMINDER", appointment.getId());

        logger.info("{} Preparing to send appointment reminder email FROM: {} TO: {}",
                logPrefix, fromEmail, toEmail);

        try {
            String patientName = appointment.getPatient().getFirstName() + " " + appointment.getPatient().getLastName();

            DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy", Locale.ENGLISH);
            DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("h:mm a", Locale.ENGLISH);

            final Context ctx = new Context();
            ctx.setVariable("baseUrl", baseUrl);
            ctx.setVariable("patientName", patientName);
            ctx.setVariable("appointmentDate", appointment.getAppointmentDate().format(dateFormatter));
            ctx.setVariable("startTime", appointment.getStartTime().format(timeFormatter));
            ctx.setVariable("clinicName", appointment.getClinic().getName());
            ctx.setVariable("clinicAddress", appointment.getClinic().getAddress());
            ctx.setVariable("clinicCity", appointment.getClinic().getCity());
            ctx.setVariable("clinicPostalCode", appointment.getClinic().getPostalCode());
            ctx.setVariable("dentistName",
                    "Dr. " + appointment.getDentist().getFirstName() + " " + appointment.getDentist().getLastName());
            ctx.setVariable("appointmentId", appointment.getId());
            ctx.setVariable("appName", appName);

            logger.debug("{} Template context variables set successfully", logPrefix);

            final String htmlContent = this.templateEngine.process("appointment-reminder", ctx);
            logger.debug("{} Template processed successfully", logPrefix);

            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            helper.setSubject("Reminder: Your Dental Appointment Tomorrow - " + appName);
            helper.setText(htmlContent, true);

            logger.debug("{} About to send email message", logPrefix);
            long startTime = System.currentTimeMillis();

            emailSender.send(message);

            long endTime = System.currentTimeMillis();
            logger.info("{} Email sent successfully FROM: {} TO: {} in {}ms",
                    logPrefix, fromEmail, toEmail, (endTime - startTime));

        } catch (MessagingException e) {
            logger.error("{} Failed to prepare reminder email TO: {} - Error: {}",
                    logPrefix, toEmail, e.getMessage(), e);
        } catch (MailException e) {
            logger.error("{} Failed to send reminder email FROM: {} TO: {} - Error: {}",
                    logPrefix, fromEmail, toEmail, e.getMessage(), e);
        } catch (Exception e) {
            logger.error("{} Unexpected error sending reminder email TO: {} - Error: {}",
                    logPrefix, toEmail, e.getMessage(), e);
        }
    }

    @Override
    public void sendSimpleMessage(String to, String subject, String text) {
        String logPrefix = createLogPrefix("SIMPLE", null);

        logger.info("{} Preparing to send simple email FROM: {} TO: {}",
                logPrefix, fromEmail, to);

        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setFrom(fromEmail);
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);

            logger.debug("{} About to send simple email message with subject: {}", logPrefix, subject);
            long startTime = System.currentTimeMillis();

            emailSender.send(message);

            long endTime = System.currentTimeMillis();
            logger.info("{} Simple email sent successfully FROM: {} TO: {} in {}ms",
                    logPrefix, fromEmail, to, (endTime - startTime));

        } catch (MailException e) {
            logger.error("{} Failed to send simple email FROM: {} TO: {} - Error: {}",
                    logPrefix, fromEmail, to, e.getMessage(), e);
        } catch (Exception e) {
            logger.error("{} Unexpected error sending simple email TO: {} - Error: {}",
                    logPrefix, to, e.getMessage(), e);
        }
    }

    @Override
    public void sendHtmlMessage(String to, String subject, String htmlContent) {
        String logPrefix = createLogPrefix("HTML", null);

        logger.info("{} Preparing to send HTML email FROM: {} TO: {}",
                logPrefix, fromEmail, to);

        try {
            MimeMessage message = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setFrom(fromEmail);
            helper.setTo(to);
            helper.setSubject(subject);
            helper.setText(htmlContent, true);

            logger.debug("{} About to send HTML email message with subject: {}", logPrefix, subject);
            long startTime = System.currentTimeMillis();

            emailSender.send(message);

            long endTime = System.currentTimeMillis();
            logger.info("{} HTML email sent successfully FROM: {} TO: {} in {}ms",
                    logPrefix, fromEmail, to, (endTime - startTime));

        } catch (MessagingException e) {
            logger.error("{} Failed to prepare HTML email TO: {} - Error: {}",
                    logPrefix, to, e.getMessage(), e);
        } catch (MailException e) {
            logger.error("{} Failed to send HTML email FROM: {} TO: {} - Error: {}",
                    logPrefix, fromEmail, to, e.getMessage(), e);
        } catch (Exception e) {
            logger.error("{} Unexpected error sending HTML email TO: {} - Error: {}",
                    logPrefix, to, e.getMessage(), e);
        }
    }

    /**
     * Create a consistent log prefix for all email-related logs
     */
    private String createLogPrefix(String emailType, Long appointmentId) {
        String timestamp = LocalDateTime.now().format(LOG_TIMESTAMP);
        String id = appointmentId != null ? "APPT_ID:" + appointmentId : "GENERAL";
        return String.format("[EMAIL_%s][%s][%s]", emailType, id, timestamp);
    }

    @Override
    public void sendContactMessage(String name, String email, String phone, String message) {
        String logPrefix = createLogPrefix("CONTACT", null);

        logger.info("{} Preparing to send contact form confirmation FROM: info@hkdental.me TO: {}",
                logPrefix, email);

        try {
            // Create Thymeleaf context for the email
            final Context ctx = new Context();
            ctx.setVariable("name", name);
            ctx.setVariable("message", message);
            ctx.setVariable("currentDate",
                    LocalDateTime.now().format(DateTimeFormatter.ofPattern("MMMM d, yyyy", Locale.ENGLISH)));
            ctx.setVariable("appName", appName);

            // Process the template
            final String htmlContent = this.templateEngine.process("contact-confirmation", ctx);

            // Send the email
            MimeMessage emailMessage = emailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(emailMessage, true, "UTF-8");

            // Set FROM address as the clinic's contact email, not the default noreply
            helper.setFrom(fromEmail);
            helper.setTo(email);
            helper.setSubject("We've Received Your Message - " + appName);
            helper.setText(htmlContent, true);

            logger.debug("{} About to send contact confirmation email", logPrefix);
            long startTime = System.currentTimeMillis();

            emailSender.send(emailMessage);

            long endTime = System.currentTimeMillis();
            logger.info("{} Contact confirmation email sent successfully TO: {} in {}ms",
                    logPrefix, email, (endTime - startTime));

            // Also forward the message to the clinic's email address
            MimeMessage forwardMessage = emailSender.createMimeMessage();
            MimeMessageHelper forwardHelper = new MimeMessageHelper(forwardMessage, true, "UTF-8");

            forwardHelper.setFrom(fromEmail);
            forwardHelper.setTo(fromEmail);
            forwardHelper.setReplyTo(email);
            forwardHelper.setSubject("New Contact Form Message from " + name);

            String forwardContent = "<h3>New Website Contact Message</h3>" +
                    "<p><strong>From:</strong> " + name + "</p>" +
                    "<p><strong>Email:</strong> " + email + "</p>" +
                    "<p><strong>Phone:</strong> " + (phone != null && !phone.isEmpty() ? phone : "Not provided")
                    + "</p>" +
                    "<h4>Message:</h4>" +
                    "<div style='padding: 10px; border-left: 4px solid #0d6efd; background-color: #f8f9fa;'>" +
                    "<p>" + message.replace("\n", "<br>") + "</p>" +
                    "</div>";

            forwardHelper.setText(forwardContent, true);
            emailSender.send(forwardMessage);

        } catch (MessagingException e) {
            logger.error("{} Failed to prepare contact confirmation email TO: {} - Error: {}",
                    logPrefix, email, e.getMessage(), e);
        } catch (MailException e) {
            logger.error("{} Failed to send contact confirmation email TO: {} - Error: {}",
                    logPrefix, email, e.getMessage(), e);
        } catch (Exception e) {
            logger.error("{} Unexpected error sending contact confirmation email TO: {} - Error: {}",
                    logPrefix, email, e.getMessage(), e);
        }
    }
}