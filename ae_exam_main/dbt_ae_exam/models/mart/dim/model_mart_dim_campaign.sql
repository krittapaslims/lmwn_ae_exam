{{ config(materialized='table') }}

SELECT 
    campaign_id,
    campaign_name,
    campaign_type,
    objective,
    channel,
    cost_model,
    targeting_strategy,
    start_date,
    end_date,
    budget,
    is_active
FROM {{ ref('model_stg_campaign_master') }}