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