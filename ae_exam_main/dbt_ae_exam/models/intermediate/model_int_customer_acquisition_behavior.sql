{{ config(materialized='view') }}

WITH new_customers AS (
    SELECT DISTINCT 
        customer_id, 
        campaign_id, 
        interaction_datetime AS conversion_datetime, 
        ad_cost
    FROM {{ ref('model_stg_campaign_interactions') }}
    WHERE event_type = 'conversion' AND is_new_customer = true
),

orders AS (
    SELECT 
        customer_id, 
        order_datetime, 
        total_amount,
        order_id
    FROM {{ ref('model_stg_order_transactions') }}
),

first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_datetime) AS first_order_datetime,
        MAX(order_datetime) AS last_order_datetime
    FROM orders
    GROUP BY customer_id
)

SELECT 
    n.campaign_id,
    n.customer_id,
    MIN(o.order_datetime) AS first_order_datetime,
    MAX(o.order_datetime) AS last_order_datetime,
    COUNT(DISTINCT o.order_id) AS total_orders,
    SUM(o.total_amount) AS total_spent,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    ABS(date_diff('day', n.conversion_datetime, MIN(o.order_datetime))) AS days_to_first_order,
    date_diff('day', MIN(o.order_datetime), MAX(o.order_datetime)) AS days_active,
    n.ad_cost
FROM new_customers n
JOIN orders o 
  ON n.customer_id = o.customer_id
GROUP BY 
    n.campaign_id, 
    n.customer_id, 
    n.conversion_datetime, 
    n.ad_cost
