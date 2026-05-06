CREATE DATABASE BarangayDB;

USE BarangayDB;

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

    profile_picture VARCHAR(255) NULL,

    date_registered DATETIME NOT NULL DEFAULT GETDATE(),
    status VARCHAR(30) NOT NULL DEFAULT 'Active'
);

CREATE TABLE assistance_applications (
    application_id INT IDENTITY(1,1) PRIMARY KEY,
    beneficiary_id INT NOT NULL,

    full_name VARCHAR(150) NOT NULL,
    beneficiary_type VARCHAR(50) NOT NULL,
    contact_number VARCHAR(20) NOT NULL,

    assistance_type VARCHAR(50) NOT NULL,
    preferred_date DATE NOT NULL,
    estimated_amount_requested DECIMAL(12,2) NULL,
    urgency_level VARCHAR(30) NOT NULL,

    reason_for_application TEXT NOT NULL,
    additional_notes TEXT NULL,

    status VARCHAR(30) NOT NULL DEFAULT 'Pending',
    date_submitted DATETIME NOT NULL DEFAULT GETDATE(),
    date_updated DATETIME NULL,

    CONSTRAINT FK_assistance_beneficiary
        FOREIGN KEY (beneficiary_id)
        REFERENCES beneficiaries(beneficiary_id)
);

CREATE TABLE admins (
    admin_id INT IDENTITY(1,1) PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    role VARCHAR(50) NOT NULL DEFAULT 'Admin',
    date_created DATETIME NOT NULL DEFAULT GETDATE(),
    status VARCHAR(20) NOT NULL DEFAULT 'Active'
);

INSERT INTO admins (username, password_hash, full_name, role, status)
VALUES 
('admin1', 'admin123', 'System Administrator', 'Admin', 'Active'),
('superadmin', 'super123', 'Super Admin User', 'Admin', 'Active'),
('staff1', 'staff123', 'Barangay Staff', 'Admin', 'Active');

CREATE TABLE notifications (
    [notification_id] INT IDENTITY(1,1) PRIMARY KEY,

    [beneficiary_id] INT NULL,   -- NULL = for all users (broadcast)
    
    [title] VARCHAR(150) NOT NULL,
    [message] TEXT NOT NULL,

    [type] VARCHAR(50) NOT NULL, 
    -- Examples: Application, Approval, Rejection, Reminder, General

    [is_read] BIT DEFAULT 0,     -- 0 = unread, 1 = read

    [date_created] DATETIME DEFAULT GETDATE(),
    [date_read] DATETIME NULL,

    CONSTRAINT FK_notifications_beneficiary
        FOREIGN KEY (beneficiary_id)
        REFERENCES beneficiaries(beneficiary_id)
);

CREATE TABLE complaints_feedback (
    complaint_id     INT IDENTITY(1,1) PRIMARY KEY,
    type             NVARCHAR(20),
    category         NVARCHAR(50),
    subject          NVARCHAR(200),
    details          NVARCHAR(1000),
    rating           INT DEFAULT 0,
    status           NVARCHAR(20) DEFAULT 'Pending',
    admin_response   NVARCHAR(500) NULL,
    date_submitted   DATETIME DEFAULT GETDATE(),
    date_resolved    DATETIME NULL,
    admin_reply TEXT NULL
);
