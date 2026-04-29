-- Count and sum applications by status
SELECT 
    COUNT(*)                                    AS TotalApplications,
    SUM(CASE WHEN status = 'Pending'  
             THEN 1 ELSE 0 END)                 AS TotalPending,
    SUM(CASE WHEN status = 'Approved' 
             THEN 1 ELSE 0 END)                 AS TotalApproved,
    SUM(CASE WHEN status = 'Rejected' 
             THEN 1 ELSE 0 END)                 AS TotalRejected,
    ISNULL(SUM(
        CASE WHEN status = 'Approved' 
             THEN estimated_amount_requested 
             ELSE 0 END), 0)                    AS TotalAmountReleased
FROM assistance_applications;