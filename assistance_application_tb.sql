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