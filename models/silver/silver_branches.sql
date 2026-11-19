{{ config(materialized='table') }}

WITH ranked_branches AS (

    SELECT
        BranchID,
        BranchName,
        SortCodePrefix,
        _source_file,
        _batch_id,
        SAFE_CAST(_ingested_at AS TIMESTAMP) AS _ingested_at,

        ROW_NUMBER() OVER (
            PARTITION BY BranchID
            ORDER BY SAFE_CAST(_ingested_at AS TIMESTAMP) DESC
        ) AS row_num

    FROM {{ ref('stg_branches') }}

)

SELECT
    BranchID,
    BranchName,
    SortCodePrefix,
    _source_file,
    _batch_id,
    _ingested_at
FROM ranked_branches
WHERE row_num = 1
