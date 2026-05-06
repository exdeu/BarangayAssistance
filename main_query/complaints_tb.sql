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
