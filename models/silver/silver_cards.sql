{{ config(materialized='table') }}

WITH ranked_cards AS (

    SELECT
        CardID,
        AccountID,
        CardType,
        Status,
        _source_file,
        _batch_id,
        SAFE_CAST(_ingested_at AS TIMESTAMP) AS _ingested_at,

        ROW_NUMBER() OVER (
            PARTITION BY CardID
            ORDER BY SAFE_CAST(_ingested_at AS TIMESTAMP) DESC
        ) AS row_num

    FROM {{ ref('stg_cards') }}

)

SELECT
    CardID,
    AccountID,
    CardType,
    Status,
    _source_file,
    _batch_id,
    _ingested_at
FROM ranked_cards
WHERE row_num = 1