{{ config(materialized='view') }}

WITH campaign_retargeting AS (
    SELECT 
        ci.interaction_id,
        ci.customer_id,
        ci.campaign_id,
        ci.interaction_datetime AS retarget_interaction_date
    FROM {{ ref('model_stg_campaign_interactions') }} ci
    JOIN {{ ref('model_stg_campaign_master') }} cm
      ON ci.campaign_id = cm.campaign_id
    WHERE cm.campaign_type = 'retargeting'
),

first_orders AS (
    SELECT 
        customer_id,
        MIN(order_datetime) AS first_order_date
    FROM {{ ref('model_stg_order_transactions') }}
    GROUP BY customer_id
),

return_orders AS (
    SELECT 
        r.interaction_id,
        r.customer_id,
        r.campaign_id,
        MIN(o.order_datetime) AS return_order_date,
        COUNT(o.order_id) AS num_orders_after,
        SUM(o.total_amount) AS total_spend_after
    FROM campaign_retargeting r
    JOIN {{ ref('model_stg_order_transactions') }} o
      ON r.customer_id = o.customer_id
     AND o.order_datetime > r.retarget_interaction_date
    GROUP BY r.interaction_id, r.customer_id, r.campaign_id
)

SELECT 
    r.customer_id,
    r.campaign_id,
    f.first_order_date,
    r.retarget_interaction_date,
    ro.return_order_date,
    date_diff('day', f.first_order_date, ro.return_order_date) AS days_between_orders,
    ro.num_orders_after,
    ro.total_spend_after
FROM campaign_retargeting r
JOIN first_orders f ON r.customer_id = f.customer_id
LEFT JOIN return_orders ro 
       ON r.customer_id = ro.customer_id 
      AND r.campaign_id = ro.campaign_id
