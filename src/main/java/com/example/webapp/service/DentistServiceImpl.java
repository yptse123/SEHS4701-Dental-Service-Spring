package com.example.webapp.service;

import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.DentistClinicAssignment;
import com.example.webapp.model.User;
import com.example.webapp.repository.DentistRepository;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class DentistServiceImpl implements DentistService {

    private final DentistRepository dentistRepository;
    private final ClinicService clinicService;

    public DentistServiceImpl(DentistRepository dentistRepository, ClinicService clinicService) {
        this.dentistRepository = dentistRepository;
        this.clinicService = clinicService;
    }

    @Override
    @Transactional
    public Dentist save(Dentist dentist) {
        if (dentist.getId() == null) {
            dentist.setCreatedAt(LocalDateTime.now());
        }
        dentist.setUpdatedAt(LocalDateTime.now());
        return dentistRepository.save(dentist);
    }

    @Override
    public Optional<Dentist> findById(Long id) {
        return dentistRepository.findById(id);
    }

    @Override
    public Optional<Dentist> findByUser(User user) {
        return dentistRepository.findByUser(user);
    }

    @Override
    public List<Dentist> findAll() {
        return dentistRepository.findAll();
    }

    @Override
    public Page<Dentist> findAll(Pageable pageable) {
        return dentistRepository.findAll(pageable);
    }

    @Override
    public List<Dentist> findByClinic(Clinic clinic) {
        return dentistRepository.findByClinic(clinic);
    }

    @Override
    public List<Dentist> findByClinicId(Long clinicId) {
        return dentistRepository.findByClinicId(clinicId);
    }

    @Override
    public List<Dentist> search(String keyword) {
        return dentistRepository.search(keyword);
    }

    @Override
    public Page<Dentist> search(String keyword, Pageable pageable) {
        return dentistRepository.search(keyword, pageable);
    }

    @Override
    public boolean existsByUserId(Long userId) {
        return dentistRepository.existsByUserId(userId);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        dentistRepository.deleteById(id);
    }

    @Override
    @Transactional
    public void assignPrimaryClinic(Long dentistId, Long clinicId) {
        Dentist dentist = dentistRepository.findById(dentistId)
                .orElseThrow(() -> new IllegalArgumentException("Dentist not found"));

        Clinic clinic = clinicService.findById(clinicId)
                .orElseThrow(() -> new IllegalArgumentException("Clinic not found"));

        // Remove existing primary clinic assignments
        dentist.getClinicAssignments().stream()
                .filter(DentistClinicAssignment::isPrimary)
                .forEach(assignment -> assignment.setPrimary(false));

        // Check if an assignment already exists for this clinic
        Optional<DentistClinicAssignment> existingAssignment = dentist.getClinicAssignments().stream()
                .filter(assignment -> assignment.getClinic().getId().equals(clinicId))
                .findFirst();

        if (existingAssignment.isPresent()) {
            // Update existing assignment to primary
            existingAssignment.get().setPrimary(true);
        } else {
            // Create new primary assignment
            DentistClinicAssignment assignment = new DentistClinicAssignment(dentist, clinic, true);
            dentist.getClinicAssignments().add(assignment);
        }

        dentistRepository.save(dentist);
    }

    @Override
    @Transactional
    public void assignClinic(Long dentistId, Long clinicId, boolean isPrimary) {
        Dentist dentist = dentistRepository.findById(dentistId)
                .orElseThrow(() -> new IllegalArgumentException("Dentist not found"));

        Clinic clinic = clinicService.findById(clinicId)
                .orElseThrow(() -> new IllegalArgumentException("Clinic not found"));

        // If this is a primary assignment, remove existing primary assignments
        if (isPrimary) {
            dentist.getClinicAssignments().stream()
                    .filter(DentistClinicAssignment::isPrimary)
                    .forEach(assignment -> assignment.setPrimary(false));
        }

        // Check if an assignment already exists for this clinic
        Optional<DentistClinicAssignment> existingAssignment = dentist.getClinicAssignments().stream()
                .filter(assignment -> assignment.getClinic().getId().equals(clinicId))
                .findFirst();

        if (existingAssignment.isPresent()) {
            // Update existing assignment
            existingAssignment.get().setPrimary(isPrimary);
        } else {
            // Create new assignment
            DentistClinicAssignment assignment = new DentistClinicAssignment(dentist, clinic, isPrimary);
            dentist.getClinicAssignments().add(assignment);
        }

        dentistRepository.save(dentist);
    }

    @Override
    @Transactional
    public void removeFromClinic(Long dentistId, Long clinicId) {
        Dentist dentist = dentistRepository.findById(dentistId)
                .orElseThrow(() -> new IllegalArgumentException("Dentist not found"));

        dentist.getClinicAssignments().removeIf(assignment -> assignment.getClinic().getId().equals(clinicId));

        dentistRepository.save(dentist);
    }

    @Override
    public Optional<Clinic> getPrimaryClinic(Long dentistId) {
        return dentistRepository.findById(dentistId)
                .flatMap(dentist -> dentist.getClinicAssignments().stream()
                        .filter(DentistClinicAssignment::isPrimary)
                        .map(DentistClinicAssignment::getClinic)
                        .findFirst());
    }

    @Override
    @Transactional
    public Dentist createDentistWithUser(User user, String firstName, String lastName,
            String specialization, String bio) {
        Dentist dentist = new Dentist();
        dentist.setUser(user);
        dentist.setFirstName(firstName);
        dentist.setLastName(lastName);
        dentist.setSpecialization(specialization);
        dentist.setBio(bio);
        dentist.setCreatedAt(LocalDateTime.now());
        dentist.setUpdatedAt(LocalDateTime.now());

        return dentistRepository.save(dentist);
    }

    @Override
    @Transactional
    public void toggleStatus(Long dentistId) {
        Dentist dentist = dentistRepository.findById(dentistId)
                .orElseThrow(() -> new IllegalArgumentException("Dentist not found"));

        // Toggle the active status directly on the dentist
        boolean currentStatus = dentist.isActive();
        dentist.setActive(!currentStatus);

        // Save the dentist
        dentistRepository.save(dentist);
    }

    @Override
    @Transactional
    public void assignSecondaryClinics(Long dentistId, List<Long> clinicIds) {
        Dentist dentist = dentistRepository.findById(dentistId)
                .orElseThrow(() -> new IllegalArgumentException("Dentist not found"));

        // Remove any existing secondary clinic assignments not in the new list
        dentist.getClinicAssignments()
                .removeIf(assignment -> !assignment.isPrimary() && !clinicIds.contains(assignment.getClinic().getId()));

        // Get IDs of clinics already assigned
        List<Long> existingClinicIds = dentist.getClinicAssignments().stream()
                .map(assignment -> assignment.getClinic().getId())
                .collect(Collectors.toList());

        // Assign new clinics
        for (Long clinicId : clinicIds) {
            if (!existingClinicIds.contains(clinicId)) {
                Clinic clinic = clinicService.findById(clinicId)
                        .orElseThrow(() -> new IllegalArgumentException("Clinic not found with ID: " + clinicId));

                DentistClinicAssignment assignment = new DentistClinicAssignment(dentist, clinic, false);
                dentist.getClinicAssignments().add(assignment);
            }
        }

        dentistRepository.save(dentist);
    }

    @Override
    public List<Long> getSecondaryClinicIds(Long dentistId) {
        return dentistRepository.findById(dentistId)
                .map(dentist -> dentist.getClinicAssignments().stream()
                        .filter(assignment -> !assignment.isPrimary())
                        .map(assignment -> assignment.getClinic().getId())
                        .collect(Collectors.toList()))
                .orElse(new ArrayList<>());
    }

    @Override
    public List<Dentist> findAllActive() {
        return dentistRepository.findAllActive();
    }

    @Override
    public Page<Dentist> findAllActive(Pageable pageable) {
        return dentistRepository.findByActiveTrue(pageable);
    }

    @Override
    public List<Dentist> findActiveByClinicId(Long clinicId) {
        return dentistRepository.findActiveByClinicId(clinicId);
    }
}