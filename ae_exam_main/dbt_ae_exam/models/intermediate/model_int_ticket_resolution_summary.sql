{{ config(materialized='view') }}

WITH base AS (
    SELECT
        s.ticket_id,
        s.issue_type,
        s.issue_sub_type,
        s.opened_datetime,
        s.resolved_datetime,
        s.compensation_amount,
        l.latest_status
    FROM {{ ref('model_stg_support_tickets') }} s
    LEFT JOIN {{ ref('model_int_ticket_status_latest') }} l
        ON s.ticket_id = l.ticket_id
),

never_resolved AS (
    SELECT ticket_id
    FROM {{ ref('model_int_tickets_never_resolved') }}
)

SELECT
    b.ticket_id,
    b.issue_type,
    b.issue_sub_type,
    b.opened_datetime,
    b.resolved_datetime,
    b.compensation_amount,
    b.latest_status,
    DATE_DIFF('minute', opened_datetime, resolved_datetime) AS resolution_time_min,
    CASE 
        WHEN nr.ticket_id IS NOT NULL OR b.latest_status != 'resolved' THEN 1
        ELSE 0
    END AS is_unresolved_or_escalated
FROM base b
LEFT JOIN never_resolved nr
    ON b.ticket_id = nr.ticket_id
