-- Join beneficiaries and assistance_applications
SELECT 
    b.beneficiary_id,
    b.first_name + ' ' + b.last_name AS BeneficiaryName,
    b.contact_number,
    b.beneficiary_type,
    a.application_id,
    a.assistance_type,
    a.estimated_amount_requested,
    a.status,
    a.date_submitted
FROM beneficiaries b
INNER JOIN assistance_applications a 
    ON b.beneficiary_id = a.beneficiary_id
ORDER BY a.date_submitted DESC;