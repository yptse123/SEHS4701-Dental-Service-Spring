package com.example.webapp.service;

import com.example.webapp.model.Patient;
import com.example.webapp.model.User;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

import java.util.List;
import java.util.Optional;

public interface PatientService {
    
    /**
     * Save a patient
     */
    Patient save(Patient patient);
    
    /**
     * Find patient by ID
     */
    Optional<Patient> findById(Long id);
    
    /**
     * Find patient by user
     */
    Optional<Patient> findByUser(User user);
    
    /**
     * Find all patients
     */
    List<Patient> findAll();
    
    /**
     * Find all patients with pagination
     */
    Page<Patient> findAll(Pageable pageable);
    
    /**
     * Search patients by keyword
     */
    List<Patient> search(String keyword);
    
    /**
     * Search patients by keyword with pagination
     */
    Page<Patient> search(String keyword, Pageable pageable);
    
    /**
     * Check if patient exists for user
     */
    boolean existsByUserId(Long userId);
    
    /**
     * Toggle a patient's active status
     */
    void toggleStatus(Long id);
    
    /**
     * Delete patient
     */
    void delete(Long id);
    
    /**
     * Find all active patients
     */
    List<Patient> findAllActive();
    
    /**
     * Find all active patients with pagination
     */
    Page<Patient> findAllActive(Pageable pageable);
    
    /**
     * Create a new patient with user
     */
    Patient createPatientWithUser(User user, String firstName, String lastName, 
                                String dateOfBirth, String phoneNumber, String address);
}