-- Sample users (password is 'password' hashed with BCrypt)
INSERT INTO `dental`.`users` (`username`, `password`, `email`, `role`) VALUES
('admin', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'admin@hkdc.com', 'ADMIN'),
('patient1', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient1@example.com', 'PATIENT'),
('patient2', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'patient2@example.com', 'PATIENT'),
('drlam', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'william.lam@hkdc.com', 'DENTIST'),
('drchen', '$2a$10$v06WAFp7ldRMTTVm59iDGeLqsIOAtFY.fD0IqPppEVSmTlW79b3P.', 'sarah.chen@hkdc.com', 'DENTIST');

-- Sample patients
INSERT INTO `dental`.`patients` (`user_id`, `first_name`, `last_name`, `phone`, `address`, `date_of_birth`, `gender`) VALUES
(2, 'John', 'Doe', '98765432', '123 Main St, Hong Kong', '1985-05-15', 'MALE'),
(3, 'Jane', 'Smith', '91234567', '456 Park Ave, Kowloon', '1990-10-20', 'FEMALE');

-- Sample clinics
INSERT INTO `dental`.`clinics` (`name`, `address`, `phone`, `open_time`, `close_time`) VALUES
('HKDC TST Branch', 'Shop 101, 1/F, Tsim Sha Tsui Centre, 66 Mody Road, TST', '23456789', '09:00:00', '18:00:00'),
('HKDC Kwai Chung Branch', 'Shop 203, 2/F, Metroplaza, 223 Hing Fong Road, Kwai Chung', '24567890', '09:00:00', '18:00:00'),
('HKDC Central Branch', 'Suite 505, 5/F, The Center, 99 Queen\'s Road Central, Central', '25678901', '09:00:00', '18:00:00'),
('HKDC Causeway Bay Branch', 'Shop 303, 3/F, Times Square, 1 Matheson Street, Causeway Bay', '26789012', '09:00:00', '18:00:00'),
('HKDC Mong Kok Branch', 'Shop 404, 4/F, Langham Place, 8 Argyle Street, Mong Kok', '27890123', '09:00:00', '18:00:00');

-- Sample dentists
INSERT INTO `dental`.`dentists` (`user_id`, `first_name`, `last_name`, `specialization`, `bio`) VALUES
(4, 'William', 'Lam', 'General Dentistry', 'Dr. William Lam has over 15 years of experience in general dentistry.'),
(5, 'Sarah', 'Chen', 'Orthodontics', 'Dr. Sarah Chen is a specialist in orthodontics with 10 years of experience.');

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

-- Sample appointments
INSERT INTO `dental`.`appointments` (`patient_id`, `dentist_id`, `clinic_id`, `appointment_date`, `start_time`, `end_time`, `status`, `notes`) VALUES
(1, 1, 1, CURDATE() + INTERVAL 7 DAY, '10:00:00', '11:00:00', 'SCHEDULED', 'Regular check-up'),
(2, 2, 3, CURDATE() + INTERVAL 10 DAY, '14:00:00', '15:00:00', 'SCHEDULED', 'Orthodontic consultation');