{{ config(materialized='table') }}

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.City,
    c.Status AS CustomerStatus,

    COUNT(a.AccountID) AS TotalAccounts,

    COALESCE(SUM(a.Balance), 0) AS TotalBalance,

    COUNTIF(a.Status = 'Active') AS ActiveAccounts

FROM {{ ref('silver_customers') }} c

LEFT JOIN {{ ref('silver_accounts') }} a
    ON c.CustomerID = a.CustomerID

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName,
    c.City,
    c.Status
    