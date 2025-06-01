{{ config(materialized='view') }}

WITH status_logs AS (
    SELECT
        order_id,
        updated_by AS driver_id,
        MAX(CASE WHEN status = 'created' THEN status_datetime END) AS assigned_time,
        MAX(CASE WHEN status = 'accepted' THEN status_datetime END) AS accepted_time,
        MAX(CASE WHEN status = 'completed' THEN status_datetime END) AS delivered_time,
        MAX(CASE WHEN status = 'canceled' THEN status_datetime END) AS cancelled_time
    FROM {{ ref('model_stg_order_status_logs') }}
    GROUP BY order_id, updated_by
)

SELECT
    order_id,
    driver_id,
    assigned_time,
    accepted_time,
    delivered_time,
    cancelled_time,
    -- Additional durations
    DATE_DIFF('minute', assigned_time, accepted_time) AS accept_delay_min,
    DATE_DIFF('minute', accepted_time, delivered_time) AS delivery_time_min
FROM status_logs
WHERE driver_id IS NOT NULL
