package com.example.webapp.service;

import com.example.webapp.model.Profile;
import com.example.webapp.model.User;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Optional;

public interface ProfileService {
    /**
     * Find profile by user
     */
    Optional<Profile> findByUser(User user);
    
    /**
     * Create or update profile for user
     */
    Profile save(Profile profile);
    
    /**
     * Update profile basic information
     */
    Profile updateBasicInfo(Profile profile, String firstName, String lastName, String phoneNumber);
    
    /**
     * Update profile address information
     */
    Profile updateAddress(Profile profile, String address, String city, String postalCode);
    
    /**
     * Upload and set profile image
     */
    String uploadProfileImage(Profile profile, MultipartFile imageFile) throws IOException;
    
    /**
     * Get profile image as resource
     */
    byte[] getProfileImage(Profile profile) throws IOException;
}