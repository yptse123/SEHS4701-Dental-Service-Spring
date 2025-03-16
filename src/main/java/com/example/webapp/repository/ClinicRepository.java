package com.example.webapp.repository;

import com.example.webapp.model.Clinic;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClinicRepository extends JpaRepository<Clinic, Long> {

    List<Clinic> findByActive(boolean active);

    Page<Clinic> findByActive(boolean active, Pageable pageable);

    @Query("SELECT c FROM Clinic c WHERE c.name LIKE %:keyword% OR c.address LIKE %:keyword% OR c.city LIKE %:keyword%")
    Page<Clinic> search(@Param("keyword") String keyword, Pageable pageable);

    boolean existsByName(String name);

    @Query("SELECT c FROM Clinic c JOIN c.dentistAssignments a WHERE a.dentist.id = :dentistId")
    List<Clinic> findByDentistId(@Param("dentistId") Long dentistId);

    @Query("SELECT c FROM Clinic c ORDER BY c.name ASC")
    List<Clinic> findAllOrderByName();

    @Query("SELECT COUNT(c) FROM Clinic c WHERE c.active = true")
    long countByActiveTrue();
}