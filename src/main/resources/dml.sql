-- Sample users (password is 'password' hashed with BCrypt)
INSERT INTO `dental`.`users` (`username`, `password`, `email`, `role`) VALUES
('admin', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'admin@hkdental.me', 'ADMIN'),
('patient1', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient1@example.com', 'PATIENT'),
('patient2', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient2@example.com', 'PATIENT'),
('drlam', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'william.lam@hkdental.me', 'DENTIST'),
('drchen', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'sarah.chen@hkdental.me', 'DENTIST'),
('dryuen', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'alice.yuen@hkdental.me', 'DENTIST'),
('drwong', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'peter.wong@hkdental.me', 'DENTIST'),
('drli', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'jennifer.li@hkdental.me', 'DENTIST'),
('drzhang', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'michael.zhang@hkdental.me', 'DENTIST'),
('drchow', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'karen.chow@hkdental.me', 'DENTIST'),
('drfong', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'david.fong@hkdental.me', 'DENTIST'),
('drnguyen', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'sophia.nguyen@hkdental.me', 'DENTIST'),
('drtang', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'robert.tang@hkdental.me', 'DENTIST'),
('patient3', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient3@example.com', 'PATIENT'),
('patient4', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient4@example.com', 'PATIENT'),
('patient5', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient5@example.com', 'PATIENT'),
('patient6', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient6@example.com', 'PATIENT'),
('patient7', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient7@example.com', 'PATIENT'),
('patient8', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient8@example.com', 'PATIENT'),
('patient9', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient9@example.com', 'PATIENT'),
('patient10', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient10@example.com', 'PATIENT'),
('patient11', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient11@example.com', 'PATIENT'),
('patient12', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient12@example.com', 'PATIENT'),
('patient13', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient13@example.com', 'PATIENT'),
('patient14', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient14@example.com', 'PATIENT'),
('patient15', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient15@example.com', 'PATIENT'),
('patient16', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient16@example.com', 'PATIENT'),
('patient17', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient17@example.com', 'PATIENT'),
('patient18', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient18@example.com', 'PATIENT'),
('patient19', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient19@example.com', 'PATIENT'),
('patient20', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient20@example.com', 'PATIENT');

-- Sample patients
-- Insert sample data into patients
INSERT INTO `dental`.`patients` (`user_id`, `first_name`, `last_name`, `phone`, `address`, `date_of_birth`, `gender`, `is_active`)
VALUES
(2, 'John', 'Doe', '+852 9123 4567', '123 Main St, Central, Hong Kong', '1985-06-15', 'MALE', TRUE),
(3, 'Jane', 'Smith', '+852 9876 5432', '456 Park Avenue, TST, Kowloon', '1990-03-22', 'FEMALE', TRUE),
(14, 'Michael', 'Johnson', '+852 9123 8765', '22A Hennessy Road, Wan Chai, Hong Kong', '1982-07-21', 'MALE', TRUE),
(15, 'Emma', 'Lee', '+852 6234 5678', '15 Stanley Street, Central, Hong Kong', '1995-02-10', 'FEMALE', TRUE),
(16, 'Daniel', 'Cheung', '+852 9876 2345', '88 Nathan Road, Tsim Sha Tsui, Kowloon', '1978-11-30', 'MALE', TRUE),
(17, 'Olivia', 'Tam', '+852 6543 7890', '45 Canton Road, Tsim Sha Tsui, Kowloon', '1991-04-05', 'FEMALE', TRUE),
(18, 'Thomas', 'Lau', '+852 9432 1098', '123 Castle Peak Road, Tuen Mun, New Territories', '1987-09-12', 'MALE', TRUE),
(19, 'Sophia', 'Ho', '+852 6789 4321', '77 King\'s Road, North Point, Hong Kong', '1999-12-25', 'FEMALE', TRUE),
(20, 'William', 'Yip', '+852 9321 5678', '56 Des Voeux Road, Sheung Wan, Hong Kong', '1980-03-17', 'MALE', TRUE),
(21, 'Ava', 'Leung', '+852 6432 9876', '33 Tai Po Road, Sham Shui Po, Kowloon', '1993-08-02', 'FEMALE', TRUE),
(22, 'James', 'Kwok', '+852 9654 3210', '99 Tung Choi Street, Mong Kok, Kowloon', '1975-05-28', 'MALE', TRUE),
(23, 'Isabella', 'Choi', '+852 6789 0123', '44 Cameron Road, Tsim Sha Tsui, Kowloon', '1997-01-15', 'FEMALE', TRUE),
(24, 'Ethan', 'Yeung', '+852 9876 5432', '77 Bonham Road, Mid-levels, Hong Kong', '1984-10-09', 'MALE', TRUE),
(25, 'Charlotte', 'Wong', '+852 6543 2109', '88 Victoria Road, Kennedy Town, Hong Kong', '1992-06-13', 'FEMALE', TRUE),
(26, 'Matthew', 'Chan', '+852 9432 8765', '55 Johnston Road, Wan Chai, Hong Kong', '1986-04-19', 'MALE', TRUE),
(27, 'Amelia', 'Lim', '+852 6789 1234', '23 Hoi Wang Road, Tai Kok Tsui, Kowloon', '1998-11-07', 'FEMALE', TRUE),
(28, 'Alexander', 'Fung', '+852 9123 4567', '66 Tung Lo Wan Road, Causeway Bay, Hong Kong', '1979-07-22', 'MALE', TRUE),
(29, 'Mia', 'Yau', '+852 6543 8765', '44 Ma Tau Wai Road, To Kwa Wan, Kowloon', '1990-12-30', 'FEMALE', TRUE),
(30, 'Benjamin', 'Tsui', '+852 9876 1234', '35 Tin Hau Temple Road, North Point, Hong Kong', '1983-02-14', 'MALE', TRUE),
(31, 'Harper', 'Cheng', '+852 6234 9876', '67 Connaught Road, Sheung Wan, Hong Kong', '1996-09-09', 'FEMALE', TRUE);

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
(5, 'Sarah', 'Chen', 'Orthodontics', 'Dr. Sarah Chen is a specialist in orthodontics with 10 years of experience.', TRUE),
(6, 'Alice', 'Yuen', 'Periodontist', 'Dr. Alice Yuen specializes in treating gum diseases with 12 years of experience.', TRUE),
(7, 'Peter', 'Wong', 'Endodontist', 'Dr. Peter Wong is a root canal specialist with advanced training in saving teeth.', TRUE),
(8, 'Jennifer', 'Li', 'Oral Surgery', 'Dr. Jennifer Li is specialized in complex dental extractions and jaw surgeries.', TRUE),
(9, 'Michael', 'Zhang', 'Pediatric Dentistry', 'Dr. Michael Zhang has dedicated his career to children\'s oral health for over 8 years.', TRUE),
(10, 'Karen', 'Chow', 'Prosthodontist', 'Dr. Karen Chow specializes in dental prosthetics, including crowns and dentures.', TRUE),
(11, 'David', 'Fong', 'Cosmetic Dentistry', 'Dr. David Fong focuses on improving smile aesthetics with modern techniques.', TRUE),
(12, 'Sophia', 'Nguyen', 'Implant Specialist', 'Dr. Sophia Nguyen has performed over 1000 successful dental implant procedures.', TRUE),
(13, 'Robert', 'Tang', 'General Dentistry', 'Dr. Robert Tang provides comprehensive dental care with 10 years of clinical practice.', TRUE);

-- Sample dentist clinic assignments
INSERT INTO `dental`.`dentist_clinic_assignments` (`dentist_id`, `clinic_id`, `is_primary`) VALUES
(1, 1, TRUE),  -- Dr. Lam's primary clinic is TST Branch
(1, 2, FALSE), -- Dr. Lam also works at Kwai Chung Branch
(2, 3, TRUE),  -- Dr. Chen's primary clinic is Central Branch
(2, 4, FALSE), -- Dr. Chen also works at Causeway Bay Branch
(2, 5, FALSE), -- Dr. Chen also works at Mong Kok Branch
(3, 2, TRUE),  -- Dr. Yuen's primary clinic is Kwai Chung Branch
(3, 3, FALSE), -- Dr. Yuen also works at Central Branch
(4, 4, TRUE),  -- Dr. Wong's primary clinic is Causeway Bay Branch
(4, 5, FALSE), -- Dr. Wong also works at Mong Kok Branch
(5, 5, TRUE),  -- Dr. Li's primary clinic is Mong Kok Branch
(5, 1, FALSE), -- Dr. Li also works at TST Branch
(6, 1, TRUE),  -- Dr. Zhang's primary clinic is TST Branch
(6, 2, FALSE), -- Dr. Zhang also works at Kwai Chung Branch
(7, 3, TRUE),  -- Dr. Chow's primary clinic is Central Branch
(7, 4, FALSE), -- Dr. Chow also works at Causeway Bay Branch
(8, 4, TRUE),  -- Dr. Fong's primary clinic is Causeway Bay Branch
(8, 5, FALSE), -- Dr. Fong also works at Mong Kok Branch
(9, 5, TRUE),  -- Dr. Nguyen's primary clinic is Mong Kok Branch
(9, 1, FALSE), -- Dr. Nguyen also works at TST Branch
(10, 2, TRUE), -- Dr. Tang's primary clinic is Kwai Chung Branch
(10, 3, FALSE); -- Dr. Tang also works at Central Branch

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
(2, 5, 'FRIDAY', '13:00:00', '18:00:00'),
(3, 2, 'MONDAY', '09:00:00', '13:00:00'),
(3, 2, 'WEDNESDAY', '14:00:00', '18:00:00'),
(3, 3, 'FRIDAY', '09:00:00', '14:00:00'),
(4, 4, 'MONDAY', '09:30:00', '15:30:00'),
(4, 4, 'THURSDAY', '09:30:00', '15:30:00'),
(4, 5, 'TUESDAY', '14:00:00', '18:00:00'),
(5, 5, 'MONDAY', '10:00:00', '16:00:00'),
(5, 5, 'WEDNESDAY', '10:00:00', '16:00:00'),
(5, 1, 'FRIDAY', '10:00:00', '15:00:00'),
(6, 1, 'TUESDAY', '09:00:00', '15:00:00'),
(6, 1, 'THURSDAY', '09:00:00', '15:00:00'),
(6, 2, 'FRIDAY', '10:00:00', '16:00:00'),
(7, 3, 'MONDAY', '09:00:00', '14:00:00'),
(7, 3, 'THURSDAY', '09:00:00', '14:00:00'),
(7, 4, 'WEDNESDAY', '14:00:00', '18:00:00'),
(8, 4, 'TUESDAY', '09:00:00', '12:00:00'),
(8, 4, 'FRIDAY', '09:00:00', '12:00:00'),
(8, 5, 'THURSDAY', '14:00:00', '18:00:00'),
(9, 5, 'WEDNESDAY', '09:00:00', '15:00:00'),
(9, 5, 'FRIDAY', '09:00:00', '15:00:00'),
(9, 1, 'MONDAY', '14:00:00', '18:00:00'),
(10, 2, 'TUESDAY', '10:00:00', '16:00:00'),
(10, 2, 'THURSDAY', '10:00:00', '16:00:00'),
(10, 3, 'MONDAY', '09:00:00', '13:00:00');

-- DML for appointments
INSERT INTO `dental`.`appointments` 
(`patient_id`, `dentist_id`, `clinic_id`, `appointment_date`, `start_time`, `end_time`, `status`, `notes`) 
VALUES 
-- Week 1: March 3-7, 2025
(1, 1, 1, '2025-03-03', '09:30:00', '10:30:00', 'COMPLETED', 'Regular checkup'),
(2, 6, 1, '2025-03-04', '10:00:00', '11:00:00', 'COMPLETED', 'Cavity filling'),
(3, 2, 3, '2025-03-03', '14:30:00', '15:30:00', 'CANCELLED', 'Patient called sick'),
(4, 5, 5, '2025-03-03', '11:00:00', '12:00:00', 'COMPLETED', 'Wisdom tooth extraction'),
(5, 3, 2, '2025-03-03', '10:00:00', '11:00:00', 'COMPLETED', 'Gum treatment'),
(6, 1, 2, '2025-03-04', '16:00:00', '17:00:00', 'CANCELLED', 'Dentist emergency'),
(7, 4, 4, '2025-03-03', '10:30:00', '11:30:00', 'COMPLETED', 'Root canal procedure'),
(8, 7, 3, '2025-03-03', '10:00:00', '11:30:00', 'COMPLETED', 'Denture fitting'),
(9, 6, 1, '2025-03-06', '10:30:00', '11:30:00', 'COMPLETED', 'Child dental check'),
(10, 2, 4, '2025-03-04', '10:00:00', '11:00:00', 'CANCELLED', 'Schedule conflict'),

-- Week 2: March 10-14, 2025
(11, 9, 5, '2025-03-12', '10:00:00', '11:00:00', 'COMPLETED', 'Dental implant consultation'),
(12, 1, 1, '2025-03-10', '10:00:00', '11:30:00', 'COMPLETED', 'Deep cleaning'),
(13, 5, 5, '2025-03-10', '11:00:00', '12:00:00', 'COMPLETED', 'Dental surgery'),
(14, 9, 1, '2025-03-10', '15:00:00', '16:00:00', 'COMPLETED', 'Pediatric dental visit'),
(15, 7, 3, '2025-03-10', '09:30:00', '10:30:00', 'CANCELLED', 'Patient no-show'),
(16, 4, 4, '2025-03-10', '11:00:00', '12:00:00', 'COMPLETED', 'Emergency tooth repair'),
(17, 8, 4, '2025-03-11', '09:30:00', '10:30:00', 'COMPLETED', 'Cosmetic consultation'),
(18, 10, 2, '2025-03-11', '11:30:00', '12:30:00', 'CANCELLED', 'Patient rescheduled'),
(19, 3, 2, '2025-03-12', '15:30:00', '16:30:00', 'COMPLETED', 'Periodontal follow-up'),
(20, 5, 5, '2025-03-12', '11:30:00', '12:30:00', 'COMPLETED', 'Post-surgery checkup'),

-- Week 3: March 17-21, 2025
(1, 2, 3, '2025-03-17', '14:00:00', '15:00:00', 'COMPLETED', 'Braces installation'),
(2, 4, 4, '2025-03-17', '10:00:00', '11:00:00', 'CANCELLED', 'Clinic system maintenance'),
(3, 6, 1, '2025-03-18', '10:30:00', '11:30:00', 'COMPLETED', 'Child tooth extraction'),
(4, 10, 2, '2025-03-18', '11:00:00', '12:00:00', 'COMPLETED', 'Dental checkup'),
(5, 8, 4, '2025-03-21', '10:00:00', '11:00:00', 'CANCELLED', 'Patient overseas'),
(6, 5, 5, '2025-03-17', '12:00:00', '13:00:00', 'COMPLETED', 'Surgical extraction'),
(7, 2, 3, '2025-03-17', '15:00:00', '16:00:00', 'COMPLETED', 'Orthodontic adjustment'),
(8, 7, 3, '2025-03-20', '10:30:00', '11:30:00', 'COMPLETED', 'Denture adjustment'),
(9, 3, 2, '2025-03-19', '15:30:00', '16:30:00', 'CANCELLED', 'Dentist sick leave'),
(10, 1, 1, '2025-03-19', '10:00:00', '11:00:00', 'COMPLETED', 'Regular check'),

-- Week 4: March 24-28, 2025
(11, 9, 5, '2025-03-24', '10:00:00', '11:00:00', 'COMPLETED', 'Implant follow-up'),
(12, 2, 3, '2025-03-24', '13:30:00', '14:30:00', 'COMPLETED', 'Orthodontic adjustment'),
(13, 1, 1, '2025-03-24', '10:30:00', '11:30:00', 'CANCELLED', 'Patient emergency'),
(14, 5, 5, '2025-03-24', '11:00:00', '12:00:00', 'COMPLETED', 'Wisdom tooth assessment'),
(15, 8, 4, '2025-03-25', '10:00:00', '11:00:00', 'COMPLETED', 'Veneer consultation'),
(16, 10, 2, '2025-03-25', '12:00:00', '13:00:00', 'CANCELLED', 'Double booking'),
(17, 3, 2, '2025-03-26', '15:00:00', '16:00:00', 'COMPLETED', 'Gum disease treatment'),
(18, 7, 3, '2025-03-26', '10:00:00', '11:00:00', 'COMPLETED', 'Crown preparation'),
(19, 2, 4, '2025-03-27', '11:00:00', '12:00:00', 'COMPLETED', 'Braces tightening'),
(20, 4, 4, '2025-03-27', '10:00:00', '11:00:00', 'CANCELLED', 'Patient rescheduled');

-- Revised appointments for April 2025 (SCHEDULED)
INSERT INTO `dental`.`appointments` 
(`patient_id`, `dentist_id`, `clinic_id`, `appointment_date`, `start_time`, `end_time`, `status`, `notes`) 
VALUES 
-- Monday April 7, 2025
(1, 1, 1, '2025-04-07', '09:30:00', '10:30:00', 'SCHEDULED', 'Routine checkup'),
(2, 6, 1, '2025-04-07', '10:00:00', '11:00:00', 'SCHEDULED', 'Dental cleaning'),
(3, 9, 1, '2025-04-07', '15:00:00', '16:00:00', 'SCHEDULED', 'Cavity filling'),
(4, 3, 2, '2025-04-07', '10:00:00', '11:00:00', 'SCHEDULED', 'Wisdom tooth consultation'),
(5, 5, 5, '2025-04-07', '11:30:00', '12:30:00', 'SCHEDULED', 'Tooth pain investigation'),

-- Tuesday April 8, 2025
(6, 4, 4, '2025-04-08', '10:00:00', '11:00:00', 'SCHEDULED', 'Root canal treatment'),
(7, 8, 4, '2025-04-08', '10:00:00', '11:00:00', 'SCHEDULED', 'Cosmetic consultation'),
(8, 1, 2, '2025-04-08', '16:00:00', '17:00:00', 'SCHEDULED', 'Dental crown fitting'),
(9, 10, 2, '2025-04-08', '11:00:00', '12:00:00', 'SCHEDULED', 'Regular checkup'),

-- Wednesday April 9, 2025
(10, 3, 2, '2025-04-09', '15:00:00', '16:00:00', 'SCHEDULED', 'Periodontal treatment'),
(11, 5, 5, '2025-04-09', '11:00:00', '12:00:00', 'SCHEDULED', 'Dental implant consultation'),
(12, 7, 3, '2025-04-09', '15:00:00', '16:00:00', 'SCHEDULED', 'Denture adjustment'),

-- Thursday April 10, 2025
(13, 2, 4, '2025-04-10', '10:00:00', '11:00:00', 'SCHEDULED', 'Braces adjustment'),
(14, 4, 4, '2025-04-10', '11:00:00', '12:00:00', 'SCHEDULED', 'Emergency tooth repair'),
(15, 6, 1, '2025-04-10', '10:00:00', '11:00:00', 'SCHEDULED', 'Pediatric dental checkup'),
(16, 10, 2, '2025-04-10', '11:00:00', '12:30:00', 'SCHEDULED', 'Teeth whitening procedure'),

-- Friday April 11, 2025
(17, 1, 1, '2025-04-11', '10:00:00', '11:00:00', 'SCHEDULED', 'Follow-up after extraction'),
(18, 2, 5, '2025-04-11', '14:00:00', '15:00:00', 'SCHEDULED', 'Orthodontic consultation'),
(19, 3, 3, '2025-04-11', '10:00:00', '11:00:00', 'SCHEDULED', 'Deep cleaning session'),
(20, 8, 4, '2025-04-11', '10:00:00', '11:00:00', 'SCHEDULED', 'Veneers consultation'),
(1, 9, 5, '2025-04-11', '10:00:00', '11:00:00', 'SCHEDULED', 'Implant follow-up'),

-- Monday April 14, 2025
(2, 7, 3, '2025-04-14', '10:00:00', '11:00:00', 'SCHEDULED', 'Crown preparation'),
(3, 5, 5, '2025-04-14', '11:00:00', '12:00:00', 'SCHEDULED', 'Surgical extraction'),
(4, 6, 1, '2025-04-14', '14:00:00', '15:00:00', 'SCHEDULED', 'Child\'s first dental visit'),

-- Tuesday April 15, 2025
(5, 8, 4, '2025-04-15', '09:30:00', '10:30:00', 'SCHEDULED', 'Cosmetic dentistry'),
(6, 10, 2, '2025-04-15', '11:30:00', '12:30:00', 'SCHEDULED', 'Dental filling'),
(7, 6, 1, '2025-04-15', '10:30:00', '11:30:00', 'SCHEDULED', 'Smile makeover consultation'),

-- Wednesday April 16, 2025
(8, 3, 2, '2025-04-16', '15:30:00', '16:30:00', 'SCHEDULED', 'Gum disease treatment'),
(9, 7, 4, '2025-04-16', '15:00:00', '16:00:00', 'SCHEDULED', 'Denture fitting'),
(10, 5, 5, '2025-04-16', '11:00:00', '12:00:00', 'SCHEDULED', 'Complex extraction'),

-- Thursday April 17, 2025
(11, 6, 1, '2025-04-17', '11:00:00', '12:00:00', 'SCHEDULED', 'Toddler dental check'),
(12, 2, 4, '2025-04-17', '10:30:00', '11:30:00', 'SCHEDULED', 'Invisalign adjustment'),
(13, 4, 4, '2025-04-17', '12:00:00', '13:00:00', 'SCHEDULED', 'Post-treatment review'),

-- Friday April 18, 2025
(14, 9, 5, '2025-04-18', '10:00:00', '11:00:00', 'SCHEDULED', 'Implant placement'),
(15, 2, 5, '2025-04-18', '14:30:00', '15:30:00', 'SCHEDULED', 'Orthodontic assessment'),
(16, 1, 1, '2025-04-18', '10:30:00', '11:30:00', 'SCHEDULED', 'Annual dental check'),
(17, 5, 1, '2025-04-18', '11:00:00', '12:00:00', 'SCHEDULED', 'Teeth sensitivity evaluation'),
(18, 3, 3, '2025-04-18', '10:00:00', '11:00:00', 'SCHEDULED', 'Deep cleaning');