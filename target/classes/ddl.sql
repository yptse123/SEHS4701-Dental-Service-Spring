DROP DATABASE IF EXISTS `dental`;

CREATE DATABASE `dental`;

CREATE TABLE `dental`.`users` (
    `user_id` BIGINT NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(50) NOT NULL UNIQUE,
    `password` VARCHAR(255) NOT NULL,
    `email` VARCHAR(100) NOT NULL UNIQUE,
    `role` ENUM('ADMIN', 'PATIENT', 'DENTIST') NOT NULL,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`user_id`)
);

CREATE TABLE `dental`.`user_preferences` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint NOT NULL,
  `email_notifications` boolean DEFAULT true,
  `sms_notifications` boolean DEFAULT false,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_preferences_user_id` (`user_id`),
  CONSTRAINT `fk_preferences_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
);

CREATE TABLE `dental`.`user_profiles` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `first_name` VARCHAR(100),
  `last_name` VARCHAR(100),
  `phone_number` VARCHAR(20),
  `address` VARCHAR(500),
  `city` VARCHAR(100),
  `postal_code` VARCHAR(20),
  `date_of_birth` DATE,
  `profile_image_path` VARCHAR(255),
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_user_profiles_user_id` (`user_id`),
  CONSTRAINT `fk_profile_user_id` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
);

CREATE TABLE `dental`.`patients` (
  `patient_id` BIGINT NOT NULL AUTO_INCREMENT,
  `user_id` BIGINT NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(20) NOT NULL,
  `address` VARCHAR(255),
  `date_of_birth` DATE,
  `gender` ENUM('MALE', 'FEMALE', 'OTHER'),
  `is_active` BOOLEAN DEFAULT TRUE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`patient_id`),
  CONSTRAINT `fk_patient_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
);

CREATE TABLE `dental`.`clinics` (
  `clinic_id` BIGINT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(100) NOT NULL,
  `address` VARCHAR(500) NOT NULL,
  `city` VARCHAR(50),
  `postal_code` VARCHAR(20),
  `phone` VARCHAR(20),
  `email` VARCHAR(100),
  `opening_time` VARCHAR(20),
  `closing_time` VARCHAR(20),
  `is_active` BOOLEAN DEFAULT TRUE,
  `description` TEXT,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`clinic_id`),
  UNIQUE KEY `uk_clinic_name` (`name`)
);

CREATE TABLE `dental`.`dentists` (
    `dentist_id` BIGINT NOT NULL AUTO_INCREMENT,
    `user_id` BIGINT NOT NULL,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `specialization` VARCHAR(100),
    `bio` TEXT,
    `is_active` BOOLEAN DEFAULT TRUE,
    PRIMARY KEY (`dentist_id`),
    CONSTRAINT `fk_dentist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
);

CREATE TABLE `dental`.`dentist_clinic_assignments` (
  `id` BIGINT NOT NULL AUTO_INCREMENT,
  `dentist_id` BIGINT NOT NULL,
  `clinic_id` BIGINT NOT NULL,
  `is_primary` BOOLEAN DEFAULT FALSE,
  `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_dentist_clinic` (`dentist_id`, `clinic_id`),
  CONSTRAINT `fk_assignment_dentist` FOREIGN KEY (`dentist_id`) REFERENCES `dentists` (`dentist_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_assignment_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`clinic_id`) ON DELETE CASCADE
);

CREATE TABLE `dental`.`schedules` (
    `schedule_id` BIGINT NOT NULL AUTO_INCREMENT,
    `dentist_id` BIGINT NOT NULL,
    `clinic_id` BIGINT NOT NULL,
    `day_of_week` ENUM('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY') NOT NULL,
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
    PRIMARY KEY (`schedule_id`),
    CONSTRAINT `fk_schedule_dentist` FOREIGN KEY (`dentist_id`) REFERENCES `dentists` (`dentist_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_schedule_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`clinic_id`) ON DELETE CASCADE
);

CREATE TABLE `dental`.`appointments` (
    `appointment_id` BIGINT NOT NULL AUTO_INCREMENT,
    `patient_id` BIGINT NOT NULL,
    `dentist_id` BIGINT NOT NULL,
    `clinic_id` BIGINT NOT NULL,
    `appointment_date` DATE NOT NULL,
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
    `status` ENUM('SCHEDULED', 'COMPLETED', 'CANCELLED', 'NO_SHOW') NOT NULL DEFAULT 'SCHEDULED',
    `notes` TEXT,
    `created_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    `updated_at` TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (`appointment_id`),
    CONSTRAINT `fk_appointment_patient` FOREIGN KEY (`patient_id`) REFERENCES `patients` (`patient_id`),
    CONSTRAINT `fk_appointment_dentist` FOREIGN KEY (`dentist_id`) REFERENCES `dentists` (`dentist_id`),
    CONSTRAINT `fk_appointment_clinic` FOREIGN KEY (`clinic_id`) REFERENCES `clinics` (`clinic_id`)
);