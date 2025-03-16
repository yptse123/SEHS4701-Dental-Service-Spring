package com.example.webapp.service;

import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.User;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;

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
     * Find all dentists with pagination
     */
    Page<Dentist> findAll(Pageable pageable);

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
     * Search dentists by keyword with pagination
     */
    Page<Dentist> search(String keyword, Pageable pageable);

    /**
     * Check if dentist exists for user
     */
    boolean existsByUserId(Long userId);

    /**
     * Delete dentist
     */
    void delete(Long id);

    /**
     * Assign a primary clinic to a dentist
     */
    void assignPrimaryClinic(Long dentistId, Long clinicId);

    /**
     * Assign a clinic to a dentist
     */
    void assignClinic(Long dentistId, Long clinicId, boolean isPrimary);

    /**
     * Remove a dentist from a clinic
     */
    void removeFromClinic(Long dentistId, Long clinicId);

    /**
     * Get a dentist's primary clinic
     */
    Optional<Clinic> getPrimaryClinic(Long dentistId);

    /**
     * Create a new dentist with user
     */
    Dentist createDentistWithUser(User user, String firstName, String lastName, String specialization, String bio);

    public void toggleStatus(Long dentistId);

    /**
     * Assigns secondary clinics to a dentist
     * 
     * @param dentistId the ID of the dentist
     * @param clinicIds the list of clinic IDs to assign as secondary clinics
     */
    public void assignSecondaryClinics(Long dentistId, List<Long> clinicIds);

    public List<Long> getSecondaryClinicIds(Long dentistId);

    /**
     * Find all active dentists
     */
    List<Dentist> findAllActive();

    /**
     * Find all active dentists with pagination
     */
    Page<Dentist> findAllActive(Pageable pageable);

    /**
     * Find active dentists by clinic ID
     */
    List<Dentist> findActiveByClinicId(Long clinicId);

    /**
     * Count all active dentists
     */
    long countAllActive();
}