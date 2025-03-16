package com.example.webapp.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

import java.time.LocalDateTime;
import java.util.HashSet;
import java.util.Set;

@Entity
@Table(name = "dentists")
public class Dentist {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "dentist_id")
    private Long id;

    @OneToOne
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @NotBlank(message = "First name is required")
    @Size(max = 50)
    @Column(name = "first_name", nullable = false)
    private String firstName;

    @NotBlank(message = "Last name is required")
    @Size(max = 50)
    @Column(name = "last_name", nullable = false)
    private String lastName;

    @Size(max = 100)
    @Column(name = "specialization")
    private String specialization;

    @Column(name = "bio")
    private String bio;
    
    @Column(name = "is_active")
    private boolean active = true;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @OneToMany(mappedBy = "dentist", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<DentistClinicAssignment> clinicAssignments = new HashSet<>();

    // Constructors
    public Dentist() {
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }

    public Dentist(User user, String firstName, String lastName) {
        this();
        this.user = user;
        this.firstName = firstName;
        this.lastName = lastName;
    }

    // Getters and Setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public User getUser() {
        return user;
    }

    public void setUser(User user) {
        this.user = user;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }
    
    public boolean isActive() {
        return active;
    }

    public void setActive(boolean active) {
        this.active = active;
    }

    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Set<DentistClinicAssignment> getClinicAssignments() {
        return clinicAssignments;
    }

    public void setClinicAssignments(Set<DentistClinicAssignment> clinicAssignments) {
        this.clinicAssignments = clinicAssignments;
    }

    // Helper methods for managing relationships
    public void addClinicAssignment(Clinic clinic, boolean isPrimary) {
        DentistClinicAssignment assignment = new DentistClinicAssignment(this, clinic, isPrimary);
        clinicAssignments.add(assignment);
        clinic.getDentistAssignments().add(assignment);
    }

    public void removeClinicAssignment(Clinic clinic) {
        for (DentistClinicAssignment assignment : new HashSet<>(clinicAssignments)) {
            if (assignment.getClinic().equals(clinic)) {
                clinicAssignments.remove(assignment);
                clinic.getDentistAssignments().remove(assignment);
                assignment.setDentist(null);
                assignment.setClinic(null);
            }
        }
    }

    // Utility methods
    public String getFullName() {
        return firstName + " " + lastName;
    }
    
    // Method to get primary clinic
    public Clinic getPrimaryClinic() {
        return clinicAssignments.stream()
                .filter(DentistClinicAssignment::isPrimary)
                .map(DentistClinicAssignment::getClinic)
                .findFirst()
                .orElse(null);
    }
    
    // Method to get all assigned clinics
    public Set<Clinic> getClinics() {
        Set<Clinic> clinics = new HashSet<>();
        for (DentistClinicAssignment assignment : clinicAssignments) {
            clinics.add(assignment.getClinic());
        }
        return clinics;
    }
}