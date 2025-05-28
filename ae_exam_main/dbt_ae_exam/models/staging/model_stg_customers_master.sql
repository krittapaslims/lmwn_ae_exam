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
FROM {{ source("main", "customers_master") }}
