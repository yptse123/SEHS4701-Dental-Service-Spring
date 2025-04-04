package com.example.webapp.service;

import com.example.webapp.model.Patient; // Add this import
import com.example.webapp.model.User;

import java.util.Optional;

public interface UserService {
    User registerNewUser(User user);
    User registerNewUser(User user, Patient patientDetails);
    User registerNewUserWithPatient(User user, Patient patient);
    
    // Other existing methods
    User save(User user);
    Optional<User> findByUsername(String username);
    Optional<User> findByEmail(String email);
    boolean existsByUsername(String username);
    boolean existsByEmail(String email);
    Optional<User> findById(Long id);
}