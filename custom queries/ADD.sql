-- Register new beneficiary
INSERT INTO beneficiaries 
(username, password_hash, last_name, first_name, middle_name, 
date_of_birth, age, sex, contact_number, civil_status, purok_street, 
household_members, monthly_income, beneficiary_type, 
government_id_presented, date_registered, status)
VALUES 
('juan01', 'pass123', 'Dela Cruz', 'Juan', 'Santos',
'1990-01-01', 34, 'Male', '09123456789', 'Single', 'Purok 1',
4, 5000.00, 'Indigent', 'Barangay ID', GETDATE(), 'Active');