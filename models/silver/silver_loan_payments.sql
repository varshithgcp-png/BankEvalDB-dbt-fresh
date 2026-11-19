{{ config(materialized='table') }}

WITH ranked_loan_payments AS (

    SELECT
        PaymentID,
        LoanID,

        SAFE_CAST(DueDate AS DATE) AS DueDate,
        SAFE_CAST(PaidDate AS DATE) AS PaidDate,
        SAFE_CAST(Amount AS NUMERIC) AS Amount,

        Status,
        _source_file,
        _batch_id,
        SAFE_CAST(_ingested_at AS TIMESTAMP) AS _ingested_at,

        ROW_NUMBER() OVER (
            PARTITION BY PaymentID
            ORDER BY SAFE_CAST(_ingested_at AS TIMESTAMP) DESC
        ) AS row_num

    FROM {{ ref('stg_loan_payments') }}

)

SELECT
    PaymentID,
    LoanID,
    DueDate,
    PaidDate,
    Amount,
    Status,
    _source_file,
    _batch_id,
    _ingested_at
FROM ranked_loan_payments
WHERE row_num = 1