{{ config(materialized='table') }}

SELECT
    customer_id, 
    signup_date, 
    customer_segment, 
    status, 
    referral_source, 
    birth_year, 
    gender, 
    preferred_device
FROM {{ ref('model_stg_customers_master') }}