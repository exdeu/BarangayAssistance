-- Search applications by beneficiary name
SELECT 
    application_id,
    full_name,
    assistance_type,
    status,
    date_submitted
FROM assistance_applications
WHERE full_name LIKE '%Cheacky%'
ORDER BY date_submitted DESC;