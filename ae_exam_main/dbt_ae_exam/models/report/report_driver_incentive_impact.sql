{{ config(materialized='table') }}

SELECT
    incentive_program,
    participating_drivers,
    total_deliveries,
    avg_accept_delay_min,
    avg_delivery_time_min,
    total_bonus_paid,
    total_feedback,
    total_positive_feedback,
    total_negative_feedback,
    positive_feedback_ratio,
    total_revenue_generated,
    revenue_to_bonus_ratio
FROM {{ ref('model_mart_fact_driver_incentive_summary') }}

