package com.example.webapp.controller;

import com.example.webapp.model.User;
import com.example.webapp.service.UserService;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import java.util.Optional;

@Controller
public class ProfileController {

    private final UserService userService;
    private final PasswordEncoder passwordEncoder;

    public ProfileController(UserService userService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.passwordEncoder = passwordEncoder;
    }

    @GetMapping("/profile")
    public String viewProfile(Model model, Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        model.addAttribute("user", user);
        return "profile";
    }

    @GetMapping("/profile/settings")
    public String viewSettings(Model model, Authentication authentication) {
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        model.addAttribute("user", user);
        model.addAttribute("passwordUpdateDto", new PasswordUpdateDto());
        return "profile-settings";
    }

    @PostMapping("/profile/update-email")
    public String updateEmail(
            @RequestParam("email") String email,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {
        
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Check if email is already in use by another user
        Optional<User> existingUser = userService.findByEmail(email);
        if (existingUser.isPresent() && !existingUser.get().getId().equals(user.getId())) {
            redirectAttributes.addFlashAttribute("emailError", "This email is already in use");
            return "redirect:/profile/settings";
        }
        
        user.setEmail(email);
        userService.save(user);
        
        redirectAttributes.addFlashAttribute("successMessage", "Email updated successfully");
        return "redirect:/profile/settings";
    }

    @PostMapping("/profile/update-password")
    public String updatePassword(
            @Valid @ModelAttribute PasswordUpdateDto passwordUpdateDto,
            BindingResult bindingResult,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {
        
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        // Validate current password
        if (!passwordEncoder.matches(passwordUpdateDto.getCurrentPassword(), user.getPassword())) {
            bindingResult.rejectValue("currentPassword", "error.passwordUpdateDto", "Current password is incorrect");
        }
        
        // Check if passwords match
        if (!passwordUpdateDto.getNewPassword().equals(passwordUpdateDto.getConfirmPassword())) {
            bindingResult.rejectValue("confirmPassword", "error.passwordUpdateDto", "Passwords do not match");
        }
        
        if (bindingResult.hasErrors()) {
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.passwordUpdateDto", bindingResult);
            redirectAttributes.addFlashAttribute("passwordUpdateDto", passwordUpdateDto);
            redirectAttributes.addFlashAttribute("passwordError", "Password update failed. Please check the errors.");
            return "redirect:/profile/settings";
        }
        
        // Update password
        user.setPassword(passwordEncoder.encode(passwordUpdateDto.getNewPassword()));
        userService.save(user);
        
        redirectAttributes.addFlashAttribute("successMessage", "Password updated successfully");
        return "redirect:/profile/settings";
    }
    
    // DTO for password update
    public static class PasswordUpdateDto {
        private String currentPassword;
        private String newPassword;
        private String confirmPassword;
        
        // Getters and setters
        public String getCurrentPassword() {
            return currentPassword;
        }
        
        public void setCurrentPassword(String currentPassword) {
            this.currentPassword = currentPassword;
        }
        
        public String getNewPassword() {
            return newPassword;
        }
        
        public void setNewPassword(String newPassword) {
            this.newPassword = newPassword;
        }
        
        public String getConfirmPassword() {
            return confirmPassword;
        }
        
        public void setConfirmPassword(String confirmPassword) {
            this.confirmPassword = confirmPassword;
        }
    }
}