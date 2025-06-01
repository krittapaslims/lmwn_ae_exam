{{ config(materialized='table') }}

WITH base AS (
    SELECT * FROM {{ ref('model_mart_fact_complaint_summary') }}
)

SELECT
    issue_type,
    issue_sub_type,
    total_tickets,
    unresolved_or_escalated,
    avg_resolution_time_min,
    total_compensation_issued,
    ROUND(1.0 * unresolved_or_escalated / NULLIF(total_tickets, 0), 2) AS unresolved_rate,
    DATE_TRUNC('month', first_ticket_datetime) AS first_month,
    DATE_TRUNC('month', latest_ticket_datetime) AS latest_month
FROM base
ORDER BY total_tickets DESC
