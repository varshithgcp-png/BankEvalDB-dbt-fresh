{{ config(materialized='table') }}

WITH ranked_loans AS (

    SELECT
        LoanID,
        CustomerID,
        BranchID,

        SAFE_CAST(Principal AS NUMERIC) AS Principal,

        Status,
        _source_file,
        _batch_id,

        SAFE_CAST(_ingested_at AS TIMESTAMP) AS _ingested_at,

        ROW_NUMBER() OVER (
            PARTITION BY LoanID
            ORDER BY SAFE_CAST(_ingested_at AS TIMESTAMP) DESC
        ) AS row_num

    FROM {{ ref('stg_loans') }}

)

SELECT
    LoanID,
    CustomerID,
    BranchID,
    Principal,
    Status,
    _source_file,
    _batch_id,
    _ingested_at
FROM ranked_loans
WHERE row_num = 1