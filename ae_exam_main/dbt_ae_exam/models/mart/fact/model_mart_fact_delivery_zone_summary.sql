{{ config(materialized='table') }}

SELECT
    region,
    total_orders,
    completed_orders,
    cancelled_or_failed_orders,
    completion_rate,
    avg_delivery_time_min,
    total_drivers,
    supply_demand_ratio
FROM {{ ref('model_int_zone_delivery_summary') }}
