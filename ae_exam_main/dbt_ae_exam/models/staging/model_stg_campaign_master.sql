{{ config(materialized='table') }}

SELECT
    campaign_id,
    campaign_name,
    start_date,
    end_date,
    campaign_type,
    objective,
    channel,
    budget,
    cost_model,
    targeting_strategy,
    is_active
FROM {{ source("main", "campaign_master") }}
