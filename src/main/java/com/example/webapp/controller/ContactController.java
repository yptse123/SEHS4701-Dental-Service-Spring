package com.example.webapp.controller;

import com.example.webapp.service.EmailService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/contact")
public class ContactController {

    private static final Logger logger = LoggerFactory.getLogger(ContactController.class);
    private final EmailService emailService;
    
    @Autowired
    public ContactController(EmailService emailService) {
        this.emailService = emailService;
    }
    
    @PostMapping("/send")
    public String sendContactMessage(
            @RequestParam("name") String name,
            @RequestParam("email") String email,
            @RequestParam("phone") String phone,
            @RequestParam("message") String message,
            RedirectAttributes redirectAttributes) {
        
        logger.info("Received contact form submission from: {} <{}>", name, email);
        
        try {
            // Call the email service to send confirmation and notification emails
            emailService.sendContactMessage(name, email, phone, message);
            
            redirectAttributes.addAttribute("success", true);
            logger.info("Contact form processed successfully for: {}", email);
            
        } catch (Exception e) {
            logger.error("Error processing contact form: {}", e.getMessage(), e);
            redirectAttributes.addAttribute("error", true);
        }
        
        // Redirect back to homepage's contact section
        return "redirect:/#contact";
    }
}