{{ config(materialized='table') }}

SELECT
    issue_type,
    issue_sub_type,
    COUNT(*) AS total_tickets,
    SUM(is_unresolved_or_escalated) AS unresolved_or_escalated,
    ROUND(AVG(resolution_time_min), 2) AS avg_resolution_time_min,
    SUM(compensation_amount) AS total_compensation_issued,
    MIN(opened_datetime) AS first_ticket_datetime,
    MAX(opened_datetime) AS latest_ticket_datetime
FROM {{ ref('model_int_ticket_resolution_summary') }}
GROUP BY issue_type, issue_sub_type
ORDER BY total_tickets DESC
