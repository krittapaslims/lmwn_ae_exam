{{ config(materialized='view') }}

WITH delivery_events AS (
    SELECT *
    FROM {{ ref('model_int_order_delivery_events') }}
),

drivers_per_region AS (
    SELECT
        region AS driver_region,
        COUNT(DISTINCT driver_id) AS total_drivers
    FROM {{ ref('model_stg_drivers_master') }}
    GROUP BY region
),

zone_summary AS (
    SELECT
        d.driver_region AS region,
        COUNT(*) AS total_orders,
        COUNT(CASE WHEN delivered_time IS NOT NULL THEN 1 END) AS completed_orders,
        COUNT(CASE WHEN canceled_time IS NOT NULL OR failed_time IS NOT NULL THEN 1 END) AS cancelled_or_failed_orders,
        ROUND(AVG(CASE 
                    WHEN delivered_time IS NOT NULL AND accepted_time IS NOT NULL
                    THEN date_diff('minute', accepted_time, delivered_time)
                  END), 2) AS avg_delivery_time_min
    FROM delivery_events d
    GROUP BY d.driver_region
)

SELECT 
    z.region,
    z.total_orders,
    z.completed_orders,
    z.cancelled_or_failed_orders,
    ROUND(1.0 * z.completed_orders / NULLIF(z.total_orders, 0), 4) AS completion_rate,
    z.avg_delivery_time_min,
    d.total_drivers,
    ROUND(1.0 * d.total_drivers / NULLIF(z.total_orders, 0), 4) AS supply_demand_ratio
FROM zone_summary z
LEFT JOIN drivers_per_region d ON z.region = d.driver_region
