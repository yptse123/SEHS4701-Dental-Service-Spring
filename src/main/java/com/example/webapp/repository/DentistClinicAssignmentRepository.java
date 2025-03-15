package com.example.webapp.repository;

import com.example.webapp.model.DentistClinicAssignment;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DentistClinicAssignmentRepository extends JpaRepository<DentistClinicAssignment, Long> {
    
    List<DentistClinicAssignment> findByDentistId(Long dentistId);
    
    List<DentistClinicAssignment> findByClinicId(Long clinicId);
    
    Optional<DentistClinicAssignment> findByDentistIdAndClinicId(Long dentistId, Long clinicId);
    
    void deleteByDentistIdAndClinicId(Long dentistId, Long clinicId);
    
    boolean existsByDentistIdAndClinicId(Long dentistId, Long clinicId);
}