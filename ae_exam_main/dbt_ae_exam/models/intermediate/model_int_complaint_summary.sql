{{ config(materialized='view') }}

WITH ticket_base AS (
    SELECT
        t.ticket_id,
        t.order_id,
        t.customer_id,
        t.driver_id,
        t.restaurant_id,
        t.issue_type,
        t.issue_sub_type,
        t.channel,
        t.opened_datetime,
        t.resolved_datetime,
        t.csat_score,
        t.compensation_amount,
        l.latest_status
    FROM {{ ref('model_stg_support_tickets') }} t
    LEFT JOIN {{ ref('model_int_ticket_status_latest') }} l
      ON t.ticket_id = l.ticket_id
),

duration_calc AS (
    SELECT
        *,
        DATE_DIFF('minute', opened_datetime, resolved_datetime) AS resolution_time_min
    FROM ticket_base
)

SELECT
    issue_type,
    issue_sub_type,
    COUNT(*) AS total_tickets,
    COUNT(CASE WHEN latest_status != 'resolved' THEN 1 END) AS unresolved_or_escalated,
    ROUND(AVG(resolution_time_min), 2) AS avg_resolution_time_min,
    SUM(compensation_amount) AS total_compensation_issued,
    MIN(opened_datetime) AS first_ticket_datetime,
    MAX(opened_datetime) AS latest_ticket_datetime
FROM duration_calc
GROUP BY issue_type, issue_sub_type