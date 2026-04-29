-- Delete a rejected application
DELETE FROM assistance_applications
WHERE application_id = 1
AND   status = 'Rejected';