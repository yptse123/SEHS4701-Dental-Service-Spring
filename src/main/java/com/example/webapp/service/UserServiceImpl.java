package com.example.webapp.service;

import com.example.webapp.model.Patient;
import com.example.webapp.model.User;
import com.example.webapp.repository.PatientRepository;
import com.example.webapp.repository.UserRepository;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Optional;

@Service
public class UserServiceImpl implements UserService {

     private final UserRepository userRepository;
    private final PatientRepository patientRepository;
    private final PasswordEncoder passwordEncoder;
    private static final Logger logger = LoggerFactory.getLogger(UserServiceImpl.class);

    public UserServiceImpl(UserRepository userRepository, 
                          PatientRepository patientRepository,
                          PasswordEncoder passwordEncoder) {
        this.userRepository = userRepository;
        this.patientRepository = patientRepository;
        this.passwordEncoder = passwordEncoder;
    }
    @Override
    @Transactional
    public User registerNewUser(User user) {
        logger.info("Registering new user (basic): {}", user.getUsername());
        
        // Encode password
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        
        // Save the user
        User savedUser = userRepository.save(user);
        logger.info("User saved with ID: {}", savedUser.getId());
        
        // If this is a patient, create a default patient profile
        if (user.getRole() == User.Role.PATIENT) {
            logger.info("Creating default patient profile for user: {}", savedUser.getUsername());
            try {
                Patient patient = new Patient();
                patient.setUser(savedUser);
                patient.setFirstName(savedUser.getUsername());
                patient.setLastName("User");
                patient.setPhoneNumber("");
                patient.setActive(true);
                patient.setCreatedAt(LocalDateTime.now());
                patient.setUpdatedAt(LocalDateTime.now());
                
                Patient savedPatient = patientRepository.save(patient);
                logger.info("Default patient profile saved with ID: {}", savedPatient.getId());
            } catch (Exception e) {
                logger.error("Failed to create default patient profile", e);
                throw e;
            }
        }
        
        return savedUser;
    }

    @Override
    @Transactional
    public User registerNewUserWithPatient(User user, Patient patient) {
        logger.info("Registering new user with patient profile: {}", user.getUsername());
        
        // This method can simply call our existing implementation
        // since the functionality is identical
        return registerNewUser(user, patient);
    }

    @Override
    @Transactional
    public User registerNewUser(User user, Patient patientDetails) {
        logger.info("Registering new user with patient details: {}", user.getUsername());
        
        // Encode password
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        user.setCreatedAt(LocalDateTime.now());
        user.setUpdatedAt(LocalDateTime.now());
        
        // Save the user first
        User savedUser = userRepository.save(user);
        logger.info("User saved with ID: {}", savedUser.getId());
        
        // If this is a patient, create a patient profile
        if (user.getRole() == User.Role.PATIENT) {
            logger.info("Creating patient profile for user: {}", savedUser.getUsername());
            try {
                // Use the provided patient details
                patientDetails.setUser(savedUser);
                patientDetails.setActive(true);
                patientDetails.setCreatedAt(LocalDateTime.now());
                patientDetails.setUpdatedAt(LocalDateTime.now());
                
                Patient savedPatient = patientRepository.save(patientDetails);
                logger.info("Patient saved with ID: {}", savedPatient.getId());
            } catch (Exception e) {
                logger.error("Failed to create patient profile", e);
                throw e;
            }
        }
        
        return savedUser;
    }

    @Override
    public User save(User user) {
        // Update the timestamp
        user.setUpdatedAt(LocalDateTime.now());

        // Save to repository
        return userRepository.save(user);
    }

    @Override
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }

    @Override
    public Optional<User> findByEmail(String email) {
        return userRepository.findByEmail(email);
    }

    @Override
    public boolean existsByUsername(String username) {
        return userRepository.existsByUsername(username);
    }

    @Override
    public boolean existsByEmail(String email) {
        return userRepository.existsByEmail(email);
    }

    @Override
    public Optional<User> findById(Long id) {
        return userRepository.findById(id);
    }
}