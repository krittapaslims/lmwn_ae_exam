{{ config(materialized='table') }}

WITH complaints AS (
    SELECT
        driver_id,
        COUNT(*) AS total_complaints,
        MODE() WITHIN GROUP (ORDER BY issue_type) AS common_issue_type,
        ROUND(AVG(resolution_time_min), 2) AS avg_resolution_time_min,
        ROUND(AVG(csat_score), 2) AS avg_csat_score
    FROM {{ ref('model_int_driver_complaint_summary') }}
    GROUP BY driver_id
),

orders AS (
    SELECT
        driver_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM {{ ref('model_stg_order_transactions') }}
    GROUP BY driver_id
),

driver_ratings_raw AS (
    SELECT *
    FROM {{ ref('model_int_driver_rating_logs') }}
),

ratings AS (
    SELECT * FROM {{ ref('model_int_driver_avg_rating_summary') }}
)


SELECT
    c.driver_id,
    c.total_complaints,
    c.common_issue_type,
    c.avg_resolution_time_min,
    c.avg_csat_score,
    o.total_orders,
    ROUND(1.0 * c.total_complaints / NULLIF(o.total_orders, 0), 3) AS complaint_to_order_ratio,
    r.avg_rating_before_complaint,
    r.avg_rating_after_complaint
FROM complaints c
LEFT JOIN orders o ON c.driver_id = o.driver_id
LEFT JOIN ratings r ON c.driver_id = r.driver_id
