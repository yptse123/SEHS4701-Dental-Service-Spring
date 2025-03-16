-- Sample users (password is 'password' hashed with BCrypt)
INSERT INTO `dental`.`users` (`username`, `password`, `email`, `role`) VALUES
('admin', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'admin@hkdc.com', 'ADMIN'),
('patient1', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient1@example.com', 'PATIENT'),
('patient2', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient2@example.com', 'PATIENT'),
('drlam', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'william.lam@hkdc.com', 'DENTIST'),
('drchen', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'sarah.chen@hkdc.com', 'DENTIST');

-- Sample patients
-- Insert sample data into patients
INSERT INTO `dental`.`patients` (`user_id`, `first_name`, `last_name`, `phone`, `address`, `date_of_birth`, `gender`, `is_active`)
VALUES
(2, 'John', 'Doe', '+852 9123 4567', '123 Main St, Central, Hong Kong', '1985-06-15', 'MALE', TRUE),
(3, 'Jane', 'Smith', '+852 9876 5432', '456 Park Avenue, TST, Kowloon', '1990-03-22', 'FEMALE', TRUE),
(4, 'David', 'Wong', '+852 6789 1234', '789 Garden Road, Sai Kung, New Territories', '1978-11-08', 'MALE', TRUE),
(5, 'Emily', 'Chan', '+852 5432 1098', '101 Harbor View, Wan Chai, Hong Kong', '2000-09-14', 'FEMALE', TRUE);

-- Updated Sample clinics with new schema
INSERT INTO `dental`.`clinics` (`name`, `address`, `city`, `postal_code`, `phone`, `email`, `opening_time`, `closing_time`, `is_active`, `description`) VALUES
('HKDC TST Branch', 'Shop 101, 1/F, Tsim Sha Tsui Centre, 66 Mody Road', 'Tsim Sha Tsui', 'TST', '23456789', 'tst@hkdc.com', '09:00', '18:00', TRUE, 'Our flagship branch in the heart of Tsim Sha Tsui offering comprehensive dental services.'),
('HKDC Kwai Chung Branch', 'Shop 203, 2/F, Metroplaza, 223 Hing Fong Road', 'Kwai Chung', 'NT', '24567890', 'kwaichung@hkdc.com', '09:00', '18:00', TRUE, 'Conveniently located in Metroplaza shopping center with modern equipment and facilities.'),
('HKDC Central Branch', 'Suite 505, 5/F, The Center, 99 Queen\'s Road', 'Central', 'HK', '25678901', 'central@hkdc.com', '09:00', '18:00', TRUE, 'Premium dental clinic catering to professionals in the Central business district.'),
('HKDC Causeway Bay Branch', 'Shop 303, 3/F, Times Square, 1 Matheson Street', 'Causeway Bay', 'HK', '26789012', 'cwb@hkdc.com', '09:00', '18:00', TRUE, 'Family-friendly dental clinic located in the heart of Causeway Bay shopping district.'),
('HKDC Mong Kok Branch', 'Shop 404, 4/F, Langham Place, 8 Argyle Street', 'Mong Kok', 'KL', '27890123', 'mongkok@hkdc.com', '09:00', '18:00', TRUE, 'Modern clinic with the latest dental technology serving the Mong Kok community.');

-- Sample dentists
INSERT INTO `dental`.`dentists` (`user_id`, `first_name`, `last_name`, `specialization`, `bio`, `is_active`) VALUES
(4, 'William', 'Lam', 'General Dentistry', 'Dr. William Lam has over 15 years of experience in general dentistry.', TRUE),
(5, 'Sarah', 'Chen', 'Orthodontics', 'Dr. Sarah Chen is a specialist in orthodontics with 10 years of experience.', TRUE);

-- Sample dentist clinic assignments
INSERT INTO `dental`.`dentist_clinic_assignments` (`dentist_id`, `clinic_id`, `is_primary`) VALUES
(1, 1, TRUE),  -- Dr. Lam's primary clinic is TST Branch
(1, 2, FALSE), -- Dr. Lam also works at Kwai Chung Branch
(2, 3, TRUE),  -- Dr. Chen's primary clinic is Central Branch
(2, 4, FALSE), -- Dr. Chen also works at Causeway Bay Branch
(2, 5, FALSE); -- Dr. Chen also works at Mong Kok Branch

-- Sample schedules
INSERT INTO `dental`.`schedules` (`dentist_id`, `clinic_id`, `day_of_week`, `start_time`, `end_time`) VALUES
(1, 1, 'MONDAY', '09:00:00', '12:00:00'),
(1, 1, 'WEDNESDAY', '09:00:00', '12:00:00'),
(1, 1, 'FRIDAY', '09:00:00', '12:00:00'),
(1, 2, 'TUESDAY', '15:00:00', '18:00:00'),
(1, 2, 'THURSDAY', '15:00:00', '18:00:00'),
(2, 3, 'MONDAY', '13:00:00', '18:00:00'),
(2, 3, 'WEDNESDAY', '13:00:00', '18:00:00'),
(2, 4, 'TUESDAY', '09:00:00', '15:00:00'),
(2, 4, 'THURSDAY', '09:00:00', '15:00:00'),
(2, 5, 'FRIDAY', '13:00:00', '18:00:00');

-- DML for appointments
INSERT INTO `dental`.`appointments` 
(`patient_id`, `dentist_id`, `clinic_id`, `appointment_date`, `start_time`, `end_time`, `status`, `notes`) 
VALUES 
(1, 1, 1, '2025-03-20', '10:00:00', '11:00:00', 'SCHEDULED', 'Regular checkup'),
(2, 2, 1, '2025-03-21', '14:00:00', '15:30:00', 'SCHEDULED', 'Root canal treatment'),
(1, 2, 2, '2025-03-22', '09:30:00', '10:30:00', 'SCHEDULED', 'Teeth whitening procedure'),
(3, 2, 3, '2025-03-18', '16:00:00', '16:30:00', 'COMPLETED', 'Dental hygiene appointment'),
(4, 1, 2, '2025-03-15', '11:00:00', '12:00:00', 'CANCELLED', 'Patient requested cancellation');