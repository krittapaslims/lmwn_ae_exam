{{ config(materialized='view') }}

WITH driver_rating_events AS (
    SELECT
        s.driver_id,
        s.ticket_id,
        s.issue_type,
        s.issue_sub_type,
        s.opened_datetime,
        s.resolved_datetime,
        s.csat_score,
        DATE_DIFF('minute', s.opened_datetime, s.resolved_datetime) AS resolution_time_min,
        CASE
            WHEN l.latest_status != 'resolved' THEN 1 ELSE 0
        END AS is_unresolved_or_escalated,
        dm.driver_rating AS driver_rating_after_complaint
    FROM {{ ref('model_stg_support_tickets') }} s
    LEFT JOIN {{ ref('model_int_ticket_status_latest') }} l
      ON s.ticket_id = l.ticket_id
    LEFT JOIN {{ ref('model_stg_drivers_master') }} dm
      ON s.driver_id = dm.driver_id
    WHERE s.driver_id IS NOT NULL
)

SELECT *
FROM driver_rating_events
