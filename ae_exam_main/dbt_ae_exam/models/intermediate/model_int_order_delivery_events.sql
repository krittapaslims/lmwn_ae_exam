{{ config(materialized='view') }}

WITH order_info AS (
    SELECT 
        o.order_id,
        o.driver_id,
        d.region AS driver_region
    FROM {{ ref('model_stg_order_transactions') }} o
    LEFT JOIN {{ ref('model_stg_drivers_master') }} d
        ON o.driver_id = d.driver_id
),

status_log AS (
    SELECT 
        osl.order_id,
        osl.status,
        osl.status_datetime
    FROM {{ ref('model_stg_order_status_logs') }} osl
    WHERE osl.status IN ('created', 'accepted', 'completed', 'canceled', 'failed')
),

pivot_status AS (
    SELECT
        oi.order_id,
        oi.driver_id,
        oi.driver_region,
        MAX(CASE WHEN sl.status = 'created' THEN sl.status_datetime END) AS assigned_time,
        MAX(CASE WHEN sl.status = 'accepted' THEN sl.status_datetime END) AS accepted_time,
        MAX(CASE WHEN sl.status = 'completed' THEN sl.status_datetime END) AS delivered_time,
        MAX(CASE WHEN sl.status = 'canceled' THEN sl.status_datetime END) AS canceled_time,
        MAX(CASE WHEN sl.status = 'failed' THEN sl.status_datetime END) AS failed_time
    FROM order_info oi
    LEFT JOIN status_log sl ON oi.order_id = sl.order_id
    GROUP BY oi.order_id, oi.driver_id, oi.driver_region
)

SELECT *
FROM pivot_status
