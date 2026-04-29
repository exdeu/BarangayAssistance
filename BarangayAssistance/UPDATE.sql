-- Approve an assistance application
UPDATE assistance_applications
SET    status       = 'Approved',
       date_updated = GETDATE()
WHERE  application_id = 1
AND    status = 'Pending';