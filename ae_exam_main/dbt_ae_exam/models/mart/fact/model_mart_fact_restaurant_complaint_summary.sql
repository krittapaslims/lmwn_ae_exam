{{ config(materialized='table') }}

WITH complaints AS (
    SELECT
        restaurant_id,
        issue_sub_type,
        COUNT(*) AS total_complaints,
        ROUND(AVG(resolution_time_min), 2) AS avg_resolution_time_min,
        SUM(compensation_amount) AS total_compensation_issued,
        COUNT(DISTINCT customer_id) AS affected_customers
    FROM {{ ref('model_int_restaurant_complaint_summary') }}
    GROUP BY restaurant_id, issue_sub_type
),

orders AS (
    SELECT
        restaurant_id,
        COUNT(*) AS total_orders
    FROM {{ ref('model_stg_order_transactions') }}
    GROUP BY restaurant_id
),

repeat_behavior AS (
    SELECT
        r.restaurant_id,
        COUNT(DISTINCT o.customer_id) AS returning_customers
    FROM {{ ref('model_int_restaurant_complaint_summary') }} r
    JOIN {{ ref('model_int_restaurant_order_summary') }} o
      ON r.customer_id = o.customer_id
     AND r.restaurant_id = o.restaurant_id
     AND o.last_order_date > r.resolved_datetime
    GROUP BY r.restaurant_id
), 

restaurants AS (
    SELECT
        restaurant_id,
        name AS restaurant_name,
        category,
        city,
        average_rating
    FROM {{ ref('model_stg_restaurants_master') }}
)

SELECT
    c.restaurant_id,
    rstr.restaurant_name,
    rstr.category,
    rstr.city,
    rstr.average_rating,
    c.issue_sub_type,
    c.total_complaints,
    c.avg_resolution_time_min,
    c.total_compensation_issued,
    c.affected_customers,
    o.total_orders,
    ROUND(1.0 * c.total_complaints / NULLIF(o.total_orders, 0), 3) AS complaint_to_order_ratio,
    COALESCE(r.returning_customers, 0) AS returning_customers
FROM complaints c
LEFT JOIN orders o ON c.restaurant_id = o.restaurant_id
LEFT JOIN repeat_behavior r ON c.restaurant_id = r.restaurant_id
LEFT JOIN restaurants rstr ON c.restaurant_id = rstr.restaurant_id