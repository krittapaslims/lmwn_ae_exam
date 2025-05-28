{{ config(materialized='table') }}

SELECT
    interaction_id, 
    campaign_id, 
    customer_id, 
    interaction_datetime, 
    event_type, 
    platform, 
    device_type, 
    ad_cost, 
    order_id, 
    is_new_customer, 
    revenue, 
    session_id
FROM {{ source("main", "campaign_interactions") }}
