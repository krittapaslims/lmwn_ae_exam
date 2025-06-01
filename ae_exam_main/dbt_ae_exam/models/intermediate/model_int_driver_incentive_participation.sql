{{ config(materialized='view') }}

SELECT
    driver_id,
    incentive_program,
    applied_date AS incentive_start_datetime,
    CAST(concat(applied_date, ' 23:59:59') AS TIMESTAMP) AS incentive_end_datetime,
    bonus_amount,
    bonus_qualified,
    delivery_target,
    actual_deliveries
FROM {{ ref('model_stg_driver_incentive_logs') }}
