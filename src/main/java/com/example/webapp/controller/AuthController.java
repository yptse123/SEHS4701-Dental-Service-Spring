package com.example.webapp.controller;

import com.example.webapp.model.Patient;  // Add this import
import com.example.webapp.model.User;
import com.example.webapp.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import jakarta.servlet.http.HttpServletRequest;
import java.time.LocalDate;  // Add this import
import java.util.Arrays;
import java.util.Map;

@Controller
public class AuthController {

    private final UserService userService;
    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }

   @ModelAttribute("user")
    public User userModel() {
        logger.info("Creating user model attribute");
        return new User();
    }

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        logger.info("Showing registration form");
        // Explicitly add user to model
        model.addAttribute("user", new User());
        return "auth/register";
    }

    @PostMapping("/register")
    public String registerUser(
            @RequestParam("username") String username,
            @RequestParam("email") String email,
            @RequestParam("password") String password,
            @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam("dateOfBirth") String dateOfBirth,
            Model model, 
            RedirectAttributes redirectAttributes) {
            
         logger.info("Manual params - username={}, email={}, firstName={}, lastName={}", 
                 username, email, firstName, lastName);
    
        try {
            // Check if username already exists
            if (userService.existsByUsername(username)) {
                model.addAttribute("error", "Username already taken");
                return "auth/register";
            }
            
            // Check if email already exists
            if (userService.existsByEmail(email)) {
                model.addAttribute("error", "Email already registered");
                return "auth/register";
            }
            
            // Create and save new user
            User user = new User();
            user.setUsername(username);
            user.setEmail(email);
            user.setPassword(password);
            user.setRole(User.Role.PATIENT);
            
            // Create patient object with personal information
            Patient patient = new Patient();
            patient.setFirstName(firstName);
            patient.setLastName(lastName);
            patient.setPhoneNumber(phoneNumber);
            
            // Parse date of birth
            try {
                LocalDate dob = LocalDate.parse(dateOfBirth);
                patient.setDateOfBirth(dob);
            } catch (Exception e) {
                model.addAttribute("error", "Invalid date format for Date of Birth");
                return "auth/register";
            }
            
            // Register user with patient profile
            userService.registerNewUserWithPatient(user, patient);
            
            return "redirect:/login?registered";
        } catch (Exception e) {
            logger.error("Error during registration: ", e);
            model.addAttribute("error", "Registration failed: " + e.getMessage());
            return "auth/register";
        }
    }
}