package com.example.webapp.service;

import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

public interface ClinicService {
    
    /**
     * Save a clinic
     */
    Clinic save(Clinic clinic);
    
    /**
     * Get all clinics
     */
    List<Clinic> findAll();
    
    /**
     * Get all active clinics
     */
    List<Clinic> findAllActive();
    
    /**
     * Get clinics with pagination
     */
    Page<Clinic> findAll(Pageable pageable);
    
    /**
     * Find a clinic by ID
     */
    Optional<Clinic> findById(Long id);
    
    /**
     * Delete a clinic
     */
    void delete(Long id);
    
    /**
     * Check if clinic exists by name
     */
    boolean existsByName(String name);
    
    /**
     * Find clinics by search term
     */
    Page<Clinic> search(String keyword, Pageable pageable);
    
    /**
     * Find clinics by dentist
     */
    List<Clinic> findByDentist(Dentist dentist);
    
    /**
     * Assign a dentist to a clinic
     */
    void assignDentistToClinic(Dentist dentist, Clinic clinic, boolean isPrimary);
    
    /**
     * Remove a dentist from a clinic
     */
    void removeDentistFromClinic(Dentist dentist, Clinic clinic);
}