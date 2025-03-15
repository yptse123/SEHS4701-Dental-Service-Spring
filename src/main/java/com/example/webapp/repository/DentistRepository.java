package com.example.webapp.repository;

import com.example.webapp.model.Clinic;
import com.example.webapp.model.Dentist;
import com.example.webapp.model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DentistRepository extends JpaRepository<Dentist, Long> {
    
    Optional<Dentist> findByUser(User user);
    
    @Query("SELECT d FROM Dentist d JOIN d.clinicAssignments a WHERE a.clinic.id = :clinicId")
    List<Dentist> findByClinicId(@Param("clinicId") Long clinicId);
    
    @Query("SELECT d FROM Dentist d JOIN d.clinicAssignments a WHERE a.clinic = :clinic")
    List<Dentist> findByClinic(@Param("clinic") Clinic clinic);
    
    @Query("SELECT d FROM Dentist d ORDER BY d.lastName, d.firstName")
    List<Dentist> findAllOrderByName();
    
    @Query("SELECT d FROM Dentist d WHERE CONCAT(d.firstName, ' ', d.lastName) LIKE %:keyword% OR d.specialization LIKE %:keyword%")
    List<Dentist> search(@Param("keyword") String keyword);
    
    boolean existsByUserId(Long userId);
}