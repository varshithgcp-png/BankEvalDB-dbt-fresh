{{ config(materialized='table') }}

WITH ranked_transactions AS (

    SELECT
        TransactionID,
        AccountID,
        TransactionTypeID,

        SAFE_CAST(TransactionDate AS TIMESTAMP) AS TransactionDate,
        SAFE_CAST(Amount AS NUMERIC) AS Amount,

        Currency,
        Channel,
        Direction,
        _source_file,
        _batch_id,

        SAFE_CAST(_ingested_at AS TIMESTAMP) AS _ingested_at,

        ROW_NUMBER() OVER (
            PARTITION BY TransactionID
            ORDER BY SAFE_CAST(_ingested_at AS TIMESTAMP) DESC
        ) AS row_num

    FROM {{ ref('stg_transactions') }}

)

SELECT
    TransactionID,
    AccountID,
    TransactionTypeID,
    TransactionDate,
    Amount,
    Currency,
    Channel,
    Direction,
    _source_file,
    _batch_id,
    _ingested_at

FROM ranked_transactions

WHERE row_num = 1