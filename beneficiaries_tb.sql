CREATE TABLE beneficiaries (
    beneficiary_id INT IDENTITY(1,1) PRIMARY KEY,

    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,

    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(100) NULL,

    date_of_birth DATE NOT NULL,
    age INT NULL,
    sex VARCHAR(10) NOT NULL,

    contact_number VARCHAR(20) NOT NULL,
    civil_status VARCHAR(30) NOT NULL,

    purok_street VARCHAR(150) NOT NULL,
    household_members INT NOT NULL,
    monthly_income DECIMAL(12,2) NULL,

    beneficiary_type VARCHAR(50) NOT NULL,
    government_id_presented VARCHAR(50) NULL,

    date_registered DATETIME NOT NULL DEFAULT GETDATE(),
    status VARCHAR(30) NOT NULL DEFAULT 'Active'
);