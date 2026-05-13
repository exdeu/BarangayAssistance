-- Filter applications by assistance type and date range
SELECT 
    application_id,
    full_name,
    assistance_type,
    status,
    estimated_amount_requested,
    date_submitted
FROM assistance_applications
WHERE assistance_type = 'Medical'
AND   CAST(date_submitted AS DATE) >= '2026-01-01'
AND   CAST(date_submitted AS DATE) <= '2026-12-31'
ORDER BY date_submitted DESC;