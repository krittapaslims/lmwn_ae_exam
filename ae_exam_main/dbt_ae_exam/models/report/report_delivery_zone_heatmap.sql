{{ config(materialized='table') }}

WITH benchmark AS (
    SELECT 10.0 AS target_delivery_time_min
)

SELECT
    dz.region AS delivery_region,
    dz.total_orders,
    dz.completed_orders,
    dz.cancelled_or_failed_orders,
    ROUND(1.0 * dz.completed_orders / NULLIF(dz.total_orders, 0), 3) AS completion_rate,
    dz.avg_delivery_time_min,
    b.target_delivery_time_min,
    ROUND(dz.avg_delivery_time_min - b.target_delivery_time_min, 2) AS delivery_time_gap_min,
    CASE
        WHEN dz.avg_delivery_time_min <= b.target_delivery_time_min THEN 'meet SLA'
        ELSE 'slow delivery'
    END AS delivery_speed_status,
    dz.total_drivers,
    ROUND(1.0 * dz.total_drivers / NULLIF(dz.total_orders, 0), 3) AS supply_demand_ratio,
    CASE
        WHEN dz.total_drivers < dz.total_orders THEN 'high tension'
        WHEN dz.total_drivers = dz.total_orders THEN 'balanced'
        ELSE 'oversupply'
    END AS supply_demand_status
FROM {{ ref('model_mart_fact_delivery_zone_summary') }} dz
CROSS JOIN benchmark b
