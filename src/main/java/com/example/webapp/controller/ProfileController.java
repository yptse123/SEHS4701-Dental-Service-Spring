package com.example.webapp.controller;

import com.example.webapp.model.Profile;
import com.example.webapp.model.User;
import com.example.webapp.model.UserPreferences;
import com.example.webapp.service.ProfileService;
import com.example.webapp.service.UserService;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.validation.Valid;
import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Optional;

@Controller
public class ProfileController {

    private final UserService userService;
    private final ProfileService profileService;
    private final PasswordEncoder passwordEncoder;

    public ProfileController(UserService userService, ProfileService profileService, PasswordEncoder passwordEncoder) {
        this.userService = userService;
        this.profileService = profileService;
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

    @PostMapping("/profile/update-info")
    public String updateProfileInfo(
            @RequestParam("firstName") String firstName,
            @RequestParam("lastName") String lastName,
            @RequestParam("phoneNumber") String phoneNumber,
            @RequestParam(value = "dateOfBirth", required = false) String dateOfBirth,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        Profile profile = user.getProfile();

        // Update basic info
        profile.setFirstName(firstName);
        profile.setLastName(lastName);
        profile.setPhoneNumber(phoneNumber);

        // Process date of birth
        if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
            try {
                LocalDate dob = LocalDate.parse(dateOfBirth);
                profile.setDateOfBirth(dob);
            } catch (Exception e) {
                redirectAttributes.addFlashAttribute("errorMessage", "Invalid date format for date of birth");
                return "redirect:/profile";
            }
        }

        profile.setUpdatedAt(LocalDateTime.now());
        profileService.save(profile);

        redirectAttributes.addFlashAttribute("successMessage", "Profile information updated successfully");
        return "redirect:/profile";
    }

    @PostMapping("/profile/update-address")
    public String updateAddress(
            @RequestParam("address") String address,
            @RequestParam("city") String city,
            @RequestParam("postalCode") String postalCode,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        Profile profile = user.getProfile();
        profileService.updateAddress(profile, address, city, postalCode);

        redirectAttributes.addFlashAttribute("successMessage", "Address updated successfully");
        return "redirect:/profile";
    }

    @PostMapping("/profile/update-dob")
    public String updateDateOfBirth(
            @RequestParam("dateOfBirth") String dateOfBirth,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        Profile profile = user.getProfile();
        try {
            LocalDate dob = LocalDate.parse(dateOfBirth, DateTimeFormatter.ISO_DATE);
            profile.setDateOfBirth(dob);
            profile.setUpdatedAt(LocalDateTime.now());
            profileService.save(profile);

            redirectAttributes.addFlashAttribute("successMessage", "Date of birth updated successfully");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid date format");
        }

        return "redirect:/profile";
    }

    @PostMapping("/profile/upload-image")
    public String uploadProfileImage(
            @RequestParam("profileImage") MultipartFile profileImage,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        Profile profile = user.getProfile();

        try {
            if (!profileImage.isEmpty()) {
                profileService.uploadProfileImage(profile, profileImage);
                redirectAttributes.addFlashAttribute("successMessage", "Profile image updated successfully");
            } else {
                redirectAttributes.addFlashAttribute("errorMessage", "Please select an image to upload");
            }
        } catch (IOException e) {
            redirectAttributes.addFlashAttribute("errorMessage", "Failed to upload image: " + e.getMessage());
        }

        return "redirect:/profile";
    }

    @GetMapping("/profile/image/{userId}")
    public ResponseEntity<byte[]> getProfileImage(@PathVariable Long userId) {
        Optional<User> userOpt = userService.findById(userId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            Profile profile = user.getProfile();

            try {
                byte[] imageData = profileService.getProfileImage(profile);
                if (imageData != null) {
                    return ResponseEntity
                            .ok()
                            .contentType(MediaType.IMAGE_JPEG)
                            .body(imageData);
                }
            } catch (IOException e) {
                // Log error
            }
        }

        // Return default image or empty response
        return ResponseEntity.notFound().build();
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
            redirectAttributes.addFlashAttribute("org.springframework.validation.BindingResult.passwordUpdateDto",
                    bindingResult);
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

    @PostMapping("/profile/update-preferences")
    public String updatePreferences(
            @RequestParam(value = "emailNotifications", required = false) Boolean emailNotifications,
            @RequestParam(value = "smsNotifications", required = false) Boolean smsNotifications,
            Authentication authentication,
            RedirectAttributes redirectAttributes) {

        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        User user = userService.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));

        UserPreferences preferences = user.getPreferences();
        preferences.setEmailNotifications(emailNotifications != null);
        preferences.setSmsNotifications(smsNotifications != null);
        preferences.setUpdatedAt(LocalDateTime.now());

        userService.save(user);

        redirectAttributes.addFlashAttribute("successMessage", "Notification preferences updated successfully");
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