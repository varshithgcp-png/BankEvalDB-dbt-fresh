{{ config(materialized='view') }}

SELECT *
FROM {{ source('bronze', 'AccountTypes') }}
