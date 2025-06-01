{{ config(materialized='table') }}

SELECT
    restaurant_id, 
    name, 
    category, 
    city, 
    average_rating, 
    active_status, 
    prep_time_min
FROM {{ ref('model_stg_restaurants_master') }}