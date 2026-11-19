{{ config(materialized='table') }}

WITH ranked_transaction_types AS (

    SELECT
        TransactionTypeID,
        TypeName,
        _source_file,
        _batch_id,
        SAFE_CAST(_ingested_at AS TIMESTAMP) AS _ingested_at,

        ROW_NUMBER() OVER (
            PARTITION BY TransactionTypeID
            ORDER BY SAFE_CAST(_ingested_at AS TIMESTAMP) DESC
        ) AS row_num

    FROM {{ ref('stg_transaction_types') }}

)

SELECT
    TransactionTypeID,
    TypeName,
    _source_file,
    _batch_id,
    _ingested_at
FROM ranked_transaction_types
WHERE row_num = 1
