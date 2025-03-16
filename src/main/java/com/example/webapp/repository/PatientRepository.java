package com.example.webapp.repository;

import com.example.webapp.model.Patient;
import com.example.webapp.model.User;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface PatientRepository extends JpaRepository<Patient, Long> {

       /**
        * Find patient by user
        */
       Optional<Patient> findByUser(User user);

       /**
        * Check if patient exists for user ID
        */
       boolean existsByUserId(Long userId);

       /**
        * Find all active patients - FIX: Changed Patients to Patient
        */
       @Query("SELECT p FROM Patient p WHERE p.active = true")
       List<Patient> findAllActive();

       /**
        * Find patients by active status with pagination
        */
       Page<Patient> findByActiveTrue(Pageable pageable);

       /**
        * Search patients by keyword (name, email, phone) - FIX: Changed Patients to
        * Patient
        */
       @Query("SELECT p FROM Patient p WHERE " +
                     "LOWER(p.firstName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                     "LOWER(p.lastName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                     "LOWER(p.user.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                     "p.phoneNumber LIKE CONCAT('%', :keyword, '%')")
       List<Patient> search(@Param("keyword") String keyword);

       /**
        * Search patients by keyword with pagination - FIX: Changed Patients to Patient
        */
       @Query("SELECT p FROM Patient p WHERE " +
                     "LOWER(p.firstName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                     "LOWER(p.lastName) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                     "LOWER(p.user.email) LIKE LOWER(CONCAT('%', :keyword, '%')) OR " +
                     "p.phoneNumber LIKE CONCAT('%', :keyword, '%')")
       Page<Patient> search(@Param("keyword") String keyword, Pageable pageable);

       @Query("SELECT COUNT(p) FROM Patient p WHERE p.active = true")
       long countByActiveTrue();
}