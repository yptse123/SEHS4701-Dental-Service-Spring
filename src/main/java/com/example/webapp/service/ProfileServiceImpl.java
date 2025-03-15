package com.example.webapp.service;

import com.example.webapp.model.Profile;
import com.example.webapp.model.User;
import com.example.webapp.repository.ProfileRepository;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.LocalDateTime;
import java.util.Optional;
import java.util.UUID;

@Service
public class ProfileServiceImpl implements ProfileService {

    private final ProfileRepository profileRepository;
    
    @Value("${app.upload.dir:${user.home}/uploads}")
    private String uploadDir;
    
    public ProfileServiceImpl(ProfileRepository profileRepository) {
        this.profileRepository = profileRepository;
    }
    
    @Override
    public Optional<Profile> findByUser(User user) {
        return profileRepository.findByUser(user);
    }
    
    @Override
    @Transactional
    public Profile save(Profile profile) {
        profile.setUpdatedAt(LocalDateTime.now());
        return profileRepository.save(profile);
    }
    
    @Override
    @Transactional
    public Profile updateBasicInfo(Profile profile, String firstName, String lastName, String phoneNumber) {
        profile.setFirstName(firstName);
        profile.setLastName(lastName);
        profile.setPhoneNumber(phoneNumber);
        profile.setUpdatedAt(LocalDateTime.now());
        return profileRepository.save(profile);
    }
    
    @Override
    @Transactional
    public Profile updateAddress(Profile profile, String address, String city, String postalCode) {
        profile.setAddress(address);
        profile.setCity(city);
        profile.setPostalCode(postalCode);
        profile.setUpdatedAt(LocalDateTime.now());
        return profileRepository.save(profile);
    }
    
    @Override
    @Transactional
    public String uploadProfileImage(Profile profile, MultipartFile imageFile) throws IOException {
        // Create upload directory if it doesn't exist
        Path uploadPath = Paths.get(uploadDir);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }
        
        // Generate a unique file name
        String uniqueFilename = UUID.randomUUID().toString() + "_" + imageFile.getOriginalFilename();
        Path filePath = uploadPath.resolve(uniqueFilename);
        
        // Save the file
        Files.copy(imageFile.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
        
        // Update profile with new image path
        profile.setProfileImagePath(uniqueFilename);
        profile.setUpdatedAt(LocalDateTime.now());
        profileRepository.save(profile);
        
        return uniqueFilename;
    }
    
    @Override
    public byte[] getProfileImage(Profile profile) throws IOException {
        if (profile.getProfileImagePath() == null) {
            return null;
        }
        
        Path imagePath = Paths.get(uploadDir).resolve(profile.getProfileImagePath());
        if (Files.exists(imagePath)) {
            return Files.readAllBytes(imagePath);
        }
        
        return null;
    }
}