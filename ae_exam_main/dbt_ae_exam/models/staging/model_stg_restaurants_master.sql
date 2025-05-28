{{ config(materialized='table') }}

SELECT
    restaurant_id, 
    name, 
    category, 
    city, 
    average_rating, 
    active_status, 
    prep_time_min
FROM {{ source("main", "restaurants_master") }}