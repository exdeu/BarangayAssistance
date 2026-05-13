-- Display all assistance applications
SELECT 
    application_id,
    full_name,
    assistance_type,
    estimated_amount_requested,
    urgency_level,
    status,
    date_submitted
FROM assistance_applications
ORDER BY date_submitted DESC;