{{ config(materialized='table') }}

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.City,

    COUNT(t.TransactionID) AS TotalTransactions,

    COALESCE(SUM(t.Amount), 0) AS TotalTransactionAmount,

    COALESCE(AVG(t.Amount), 0) AS AverageTransactionAmount,

    MAX(t.TransactionDate) AS LastTransactionDate

FROM {{ ref('silver_customers') }} c

LEFT JOIN {{ ref('silver_accounts') }} a
    ON c.CustomerID = a.CustomerID

LEFT JOIN {{ ref('silver_transactions') }} t
    ON a.AccountID = t.AccountID

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.City
    