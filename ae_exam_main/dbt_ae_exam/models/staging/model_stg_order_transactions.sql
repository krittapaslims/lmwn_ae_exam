{{ config(materialized='table') }}

SELECT
    order_id, 
    customer_id, 
    restaurant_id, 
    driver_id, 
    order_datetime, 
    pickup_datetime, 
    delivery_datetime, 
    order_status, 
    delivery_zone, 
    total_amount, 
    payment_method, 
    is_late_delivery, 
    delivery_distance_km
FROM {{ source("main", "order_transactions") }}