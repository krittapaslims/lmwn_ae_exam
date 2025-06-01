{{ config(materialized='view') }}

WITH order_info AS (
    SELECT order_id, driver_id
    FROM {{ ref('model_stg_order_transactions') }}
),

status_log AS (
    SELECT 
        osl.order_id,
        oi.driver_id,
        osl.status,
        osl.status_datetime
    FROM {{ ref('model_stg_order_status_logs') }} osl
    LEFT JOIN order_info oi ON osl.order_id = oi.order_id
    WHERE osl.status IN ('created', 'accepted', 'completed', 'canceled')
),

status_pivot AS (
    SELECT 
        order_id,
        driver_id,
        MAX(CASE WHEN status = 'created' THEN status_datetime END) AS assigned_time,
        MAX(CASE WHEN status = 'accepted' THEN status_datetime END) AS accepted_time,
        MAX(CASE WHEN status = 'completed' THEN status_datetime END) AS delivered_time,
        MAX(CASE WHEN status = 'canceled' THEN status_datetime END) AS cancelled_time
    FROM status_log
    GROUP BY order_id, driver_id
)

SELECT 
    driver_id,
    COUNT(order_id) AS tasks_assigned,
    COUNT(delivered_time) AS tasks_completed,
    ROUND(AVG(date_diff('minute', assigned_time, accepted_time)), 2) AS avg_accept_delay_min,
    ROUND(AVG(date_diff('minute', accepted_time, delivered_time)), 2) AS avg_delivery_time_min,
    COUNT(CASE WHEN delivered_time IS NOT NULL AND date_diff('minute', accepted_time, delivered_time) > 45 THEN 1 END) AS late_deliveries
FROM status_pivot
WHERE driver_id IS NOT NULL
GROUP BY driver_id
