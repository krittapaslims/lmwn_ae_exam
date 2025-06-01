{{ config(materialized='table') }}

SELECT * 
FROM {{ ref('model_mart_fact_driver_performance_summary') }}
ORDER BY tasks_completed DESC
