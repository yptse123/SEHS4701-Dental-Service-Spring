package com.example.webapp.service;

import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.DentistClinicAssignment;
import com.example.webapp.repository.ClinicRepository;
import com.example.webapp.repository.DentistClinicAssignmentRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class ClinicServiceImpl implements ClinicService {

    private final ClinicRepository clinicRepository;
    private final DentistClinicAssignmentRepository assignmentRepository;

    public ClinicServiceImpl(ClinicRepository clinicRepository, 
                             DentistClinicAssignmentRepository assignmentRepository) {
        this.clinicRepository = clinicRepository;
        this.assignmentRepository = assignmentRepository;
    }

    @Override
    @Transactional
    public Clinic save(Clinic clinic) {
        if (clinic.getId() == null) {
            clinic.setCreatedAt(LocalDateTime.now());
        }
        clinic.setUpdatedAt(LocalDateTime.now());
        return clinicRepository.save(clinic);
    }

    @Override
    public List<Clinic> findAll() {
        return clinicRepository.findAll();
    }

    @Override
    public List<Clinic> findAllActive() {
        return clinicRepository.findByActive(true);
    }

    @Override
    public Page<Clinic> findAll(Pageable pageable) {
        return clinicRepository.findAll(pageable);
    }

    @Override
    public Optional<Clinic> findById(Long id) {
        return clinicRepository.findById(id);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        clinicRepository.deleteById(id);
    }

    @Override
    public boolean existsByName(String name) {
        return clinicRepository.existsByName(name);
    }

    @Override
    public Page<Clinic> search(String keyword, Pageable pageable) {
        return clinicRepository.search(keyword, pageable);
    }

    @Override
    public List<Clinic> findByDentist(Dentist dentist) {
        return clinicRepository.findByDentistId(dentist.getId());
    }

    @Override
    @Transactional
    public void assignDentistToClinic(Dentist dentist, Clinic clinic, boolean isPrimary) {
        // Check if assignment already exists
        Optional<DentistClinicAssignment> existingAssignment = 
            assignmentRepository.findByDentistIdAndClinicId(dentist.getId(), clinic.getId());
        
        if (existingAssignment.isPresent()) {
            DentistClinicAssignment assignment = existingAssignment.get();
            assignment.setPrimary(isPrimary);
            assignment.setUpdatedAt(LocalDateTime.now());
            assignmentRepository.save(assignment);
        } else {
            DentistClinicAssignment newAssignment = new DentistClinicAssignment(dentist, clinic, isPrimary);
            assignmentRepository.save(newAssignment);
        }
    }

    @Override
    @Transactional
    public void removeDentistFromClinic(Dentist dentist, Clinic clinic) {
        assignmentRepository.deleteByDentistIdAndClinicId(dentist.getId(), clinic.getId());
    }
}