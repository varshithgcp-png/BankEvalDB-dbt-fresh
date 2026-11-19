{{ config(materialized='table') }}

WITH ranked_accounts AS (

    SELECT
        AccountID,
        CustomerID,
        AccountTypeID,
        BranchID,
        SortCode,
        Currency,

        SAFE_CAST(OpenDate AS DATE) AS OpenDate,
        SAFE_CAST(CloseDate AS DATE) AS CloseDate,
        SAFE_CAST(Balance AS NUMERIC) AS Balance,

        Status,

        SAFE_CAST(UpdatedAt AS TIMESTAMP) AS UpdatedAt,

        _source_file,
        _batch_id,
        SAFE_CAST(_ingested_at AS TIMESTAMP) AS _ingested_at,

        ROW_NUMBER() OVER (
            PARTITION BY AccountID
            ORDER BY
                SAFE_CAST(UpdatedAt AS TIMESTAMP) DESC,
                SAFE_CAST(_ingested_at AS TIMESTAMP) DESC
        ) AS row_num

    FROM {{ ref('stg_accounts') }}

)

SELECT
    AccountID,
    CustomerID,
    AccountTypeID,
    BranchID,
    SortCode,
    Currency,
    OpenDate,
    CloseDate,
    Balance,
    Status,
    UpdatedAt,
    _source_file,
    _batch_id,
    _ingested_at
FROM ranked_accounts
WHERE row_num = 1
