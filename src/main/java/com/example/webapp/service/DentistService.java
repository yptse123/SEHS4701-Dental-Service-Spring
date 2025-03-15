package com.example.webapp.service;

import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.User;

import java.util.List;
import java.util.Optional;

public interface DentistService {
    
    /**
     * Save a dentist
     */
    Dentist save(Dentist dentist);
    
    /**
     * Find dentist by ID
     */
    Optional<Dentist> findById(Long id);
    
    /**
     * Find dentist by user
     */
    Optional<Dentist> findByUser(User user);
    
    /**
     * Find all dentists
     */
    List<Dentist> findAll();
    
    /**
     * Find dentists by clinic
     */
    List<Dentist> findByClinic(Clinic clinic);
    
    /**
     * Find dentists by clinic ID
     */
    List<Dentist> findByClinicId(Long clinicId);
    
    /**
     * Search dentists by keyword
     */
    List<Dentist> search(String keyword);
    
    /**
     * Check if dentist exists for user
     */
    boolean existsByUserId(Long userId);
    
    /**
     * Delete dentist
     */
    void delete(Long id);
}