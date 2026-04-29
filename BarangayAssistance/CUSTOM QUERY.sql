-- Get full dashboard summary per beneficiary
SELECT 
    b.beneficiary_id,
    b.first_name + ' ' + b.last_name         AS FullName,
    b.beneficiary_type,
    COUNT(a.application_id)                   AS TotalApplications,
    SUM(CASE WHEN a.status = 'Pending'  
             THEN 1 ELSE 0 END)               AS Pending,
    SUM(CASE WHEN a.status = 'Approved' 
             THEN 1 ELSE 0 END)               AS Approved,
    SUM(CASE WHEN a.status = 'Rejected' 
             THEN 1 ELSE 0 END)               AS Rejected,
    ISNULL(SUM(
        CASE WHEN a.status = 'Approved'
             THEN a.estimated_amount_requested 
             ELSE 0 END), 0)                  AS TotalReceived
FROM beneficiaries b
LEFT JOIN assistance_applications a 
    ON b.beneficiary_id = a.beneficiary_id
GROUP BY 
    b.beneficiary_id, 
    b.first_name, 
    b.last_name, 
    b.beneficiary_type
ORDER BY TotalApplications DESC;