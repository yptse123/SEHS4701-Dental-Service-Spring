package com.example.webapp.service;

import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.User;
import com.example.webapp.repository.DentistRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
public class DentistServiceImpl implements DentistService {

    private final DentistRepository dentistRepository;

    public DentistServiceImpl(DentistRepository dentistRepository) {
        this.dentistRepository = dentistRepository;
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
        return dentistRepository.findAllOrderByName();
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
    public boolean existsByUserId(Long userId) {
        return dentistRepository.existsByUserId(userId);
    }

    @Override
    @Transactional
    public void delete(Long id) {
        dentistRepository.deleteById(id);
    }
}