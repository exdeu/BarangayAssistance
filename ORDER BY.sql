-- Display notifications ordered by unread first then latest date
SELECT 
    notification_id,
    title,
    message,
    type,
    is_read,
    date_created
FROM notifications
WHERE beneficiary_id = 1
ORDER BY is_read ASC, date_created DESC;