{{ config(materialized='table') }}

SELECT
    driver_id, 
    join_date, 
    vehicle_type, 
    region, 
    active_status, 
    driver_rating, 
    bonus_tier
FROM {{ ref('model_stg_drivers_master') }}