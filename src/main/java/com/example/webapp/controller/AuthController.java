package com.example.webapp.controller;

import com.example.webapp.model.User;
import com.example.webapp.service.UserService;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

@Controller
public class AuthController {

    private final UserService userService;

    public AuthController(UserService userService) {
        this.userService = userService;
    }

    @GetMapping("/login")
    public String login() {
        return "auth/login";
    }

    @GetMapping("/register")
    public String showRegistrationForm(Model model) {
        model.addAttribute("user", new User());
        return "auth/register";
    }

    @PostMapping("/register")
    public String registerUser(@ModelAttribute("user") User user) {
        // Check if username is already taken
        if (userService.existsByUsername(user.getUsername())) {
            return "redirect:/register?error=username";
        }

        // Check if email is already registered
        if (userService.existsByEmail(user.getEmail())) {
            return "redirect:/register?error=email";
        }

        // Set default role to PATIENT for registrations
        user.setRole(User.Role.PATIENT);
        
        // Register the user
        userService.registerNewUser(user);
        
        return "redirect:/login?registered";
    }
}