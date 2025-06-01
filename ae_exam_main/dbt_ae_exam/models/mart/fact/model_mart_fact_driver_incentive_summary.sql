{{ config(materialized='table') }}

WITH incentive_participation AS (
    SELECT * FROM {{ ref('model_int_driver_incentive_participation') }}
),

performance_during_incentive AS (
    SELECT * FROM {{ ref('model_int_driver_performance_during_incentive') }}
),

driver_feedback AS (
    SELECT * FROM {{ ref('model_int_driver_feedback_summary') }}
),

orders_with_revenue AS (
    SELECT
        o.driver_id,
        o.order_id,
        o.assigned_time,
        ot.total_amount
    FROM {{ ref('model_int_driver_order_events_with_time') }} o
    LEFT JOIN {{ ref('model_stg_order_transactions') }} AS ot
      ON o.order_id = ot.order_id
)

SELECT
    ip.incentive_program,
    COUNT(DISTINCT ip.driver_id) AS participating_drivers,
    COUNT(DISTINCT p.order_id) AS total_deliveries,
    
    ROUND(AVG(p.accept_delay_min), 2) AS avg_accept_delay_min,
    ROUND(AVG(p.delivery_time_min), 2) AS avg_delivery_time_min,

    -- Feedback
    SUM(df.total_feedback) AS total_feedback,
    SUM(df.positive_feedback) AS total_positive_feedback,
    SUM(df.negative_feedback) AS total_negative_feedback,
    ROUND(1.0 * SUM(df.positive_feedback) / NULLIF(SUM(df.total_feedback), 0), 2) AS positive_feedback_ratio,

    -- Bonus
    SUM(ip.bonus_amount) AS total_bonus_paid,

    -- Revenue
    SUM(owr.total_amount) AS total_revenue_generated,
    ROUND(SUM(owr.total_amount) / NULLIF(SUM(ip.bonus_amount), 0), 2) AS revenue_to_bonus_ratio


FROM incentive_participation ip
LEFT JOIN performance_during_incentive p
  ON ip.driver_id = p.driver_id
 AND ip.incentive_program = p.incentive_program

LEFT JOIN driver_feedback df
  ON ip.driver_id = df.driver_id

LEFT JOIN orders_with_revenue owr
  ON ip.driver_id = owr.driver_id
 AND owr.assigned_time BETWEEN ip.incentive_start_datetime AND ip.incentive_end_datetime

GROUP BY ip.incentive_program
ORDER BY ip.incentive_program
