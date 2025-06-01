{{ config(materialized='view') }}

SELECT
    s.restaurant_id,
    s.issue_type,
    s.issue_sub_type,
    s.ticket_id,
    s.customer_id,
    s.opened_datetime,
    s.resolved_datetime,
    s.compensation_amount,
    DATE_DIFF('minute', s.opened_datetime, s.resolved_datetime) AS resolution_time_min
FROM {{ ref('model_stg_support_tickets') }} s
WHERE s.restaurant_id IS NOT NULL
  AND s.issue_type = 'food'
