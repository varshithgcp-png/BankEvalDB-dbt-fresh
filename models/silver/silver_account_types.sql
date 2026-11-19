{{ config(materialized='table') }}

WITH ranked_account_types AS (

    SELECT
        AccountTypeID,
        TypeName,
        SAFE_CAST(OverdraftLimit AS NUMERIC) AS OverdraftLimit,
        _source_file,
        _batch_id,
        SAFE_CAST(_ingested_at AS TIMESTAMP) AS _ingested_at,

        ROW_NUMBER() OVER (
            PARTITION BY AccountTypeID
            ORDER BY SAFE_CAST(_ingested_at AS TIMESTAMP) DESC
        ) AS row_num

    FROM {{ ref('stg_account_types') }}

)

SELECT
    AccountTypeID,
    TypeName,
    OverdraftLimit,
    _source_file,
    _batch_id,
    _ingested_at
FROM ranked_account_types
WHERE row_num = 1
