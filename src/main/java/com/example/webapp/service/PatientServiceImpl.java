package com.example.webapp.service;

import com.example.webapp.model.Patient;
import com.example.webapp.model.User;
import com.example.webapp.repository.PatientRepository;
import com.example.webapp.repository.UserRepository;

import jakarta.persistence.EntityNotFoundException;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Optional;

@Service
public class PatientServiceImpl implements PatientService {

    private final PatientRepository patientRepository;
    private final UserRepository userRepository;

    public PatientServiceImpl(PatientRepository patientRepository, UserRepository userRepository) {
        this.patientRepository = patientRepository;
        this.userRepository = userRepository;
    }

    @Override
    public Patient save(Patient patient) {
        // For existing patients
        if (patient.getId() != null) {
            // Load the existing patient to preserve relationships
            Patient existingPatient = patientRepository.findById(patient.getId())
                .orElseThrow(() -> new EntityNotFoundException("Patient not found"));
            
            // Keep the existing User reference to prevent ID changes
            User existingUser = existingPatient.getUser();
            patient.setUser(existingUser);
            
            // Preserve creation timestamp
            patient.setCreatedAt(existingPatient.getCreatedAt());
        }
        // For new patients with a user ID
        else if (patient.getUser() != null && patient.getUser().getId() != null) {
            // Load the actual user from the database to get a managed entity
            User managedUser = userRepository.findById(patient.getUser().getId().longValue())
                .orElseThrow(() -> new EntityNotFoundException("User not found"));
            
            patient.setUser(managedUser);
            patient.setCreatedAt(LocalDateTime.now());
        }
        
        // Always update the timestamp
        patient.setUpdatedAt(LocalDateTime.now());
        
        return patientRepository.save(patient);
    }

    @Override
    public Optional<Patient> findById(Long id) {
        return patientRepository.findById(id);
    }

    @Override
    public Optional<Patient> findByUser(User user) {
        return patientRepository.findByUser(user);
    }

    @Override
    public List<Patient> findAll() {
        return patientRepository.findAll();
    }

    @Override
    public Page<Patient> findAll(Pageable pageable) {
        return patientRepository.findAll(pageable);
    }

    @Override
    public List<Patient> search(String keyword) {
        return patientRepository.search(keyword);
    }

    @Override
    public Page<Patient> search(String keyword, Pageable pageable) {
        return patientRepository.search(keyword, pageable);
    }

    @Override
    public boolean existsByUserId(Long userId) {
        return patientRepository.existsByUserId(userId);
    }

    @Override
    @Transactional
    public void toggleStatus(Long id) {
        Patient patient = patientRepository.findById(id)
                .orElseThrow(() -> new IllegalArgumentException("Patient not found"));

        // Toggle the active status directly on the patient
        boolean currentStatus = patient.isActive();
        patient.setActive(!currentStatus);

        // Save the patient
        patientRepository.save(patient);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        patientRepository.deleteById(id);
    }

    @Override
    public List<Patient> findAllActive() {
        return patientRepository.findAllActive();
    }

    @Override
    public Page<Patient> findAllActive(Pageable pageable) {
        return patientRepository.findByActiveTrue(pageable);
    }

    @Override
    @Transactional
    public Patient createPatientWithUser(User user, String firstName, String lastName, 
                                     String dateOfBirth, String phoneNumber, String address) {
        Patient patient = new Patient();
        patient.setUser(user);
        patient.setFirstName(firstName);
        patient.setLastName(lastName);
        
        // Parse date of birth if provided
        if (dateOfBirth != null && !dateOfBirth.isEmpty()) {
            try {
                LocalDate dob = LocalDate.parse(dateOfBirth, DateTimeFormatter.ISO_DATE);
                patient.setDateOfBirth(dob);
            } catch (Exception e) {
                // Handle date parsing error
                throw new IllegalArgumentException("Invalid date format for date of birth", e);
            }
        }
        
        patient.setPhoneNumber(phoneNumber);
        patient.setAddress(address);
        patient.setActive(true);
        patient.setCreatedAt(LocalDateTime.now());
        patient.setUpdatedAt(LocalDateTime.now());
        
        return patientRepository.save(patient);
    }
}