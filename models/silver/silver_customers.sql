{{ config(materialized='table') }}

WITH ranked_customers AS (

    SELECT
        CustomerID,
        FirstName,
        LastName,
        Email,
        Phone,
        City,
        Status,
        UpdatedAt,
        _source_file,
        _batch_id,
        _ingested_at,

        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY
                SAFE_CAST(UpdatedAt AS TIMESTAMP) DESC,
                SAFE_CAST(_ingested_at AS TIMESTAMP) DESC
        ) AS row_num

    FROM {{ ref('stg_customers') }}

)

SELECT
    CustomerID,
    FirstName,
    LastName,
    Email,
    Phone,
    City,
    Status,
    UpdatedAt,
    _source_file,
    _batch_id,
    _ingested_at
FROM ranked_customers
WHERE row_num = 1
