{{ config(materialized='table') }}

SELECT
    b.BranchID,
    b.BranchName,

    COUNT(DISTINCT a.AccountID) AS TotalAccounts,

    COUNT(DISTINCT a.CustomerID) AS TotalCustomers,

    COALESCE(SUM(a.Balance), 0) AS TotalAccountBalance,

    COUNT(DISTINCT l.LoanID) AS TotalLoans,

    COALESCE(SUM(l.Principal), 0) AS TotalLoanPrincipal

FROM {{ ref('silver_branches') }} b

LEFT JOIN {{ ref('silver_accounts') }} a
    ON b.BranchID = a.BranchID

LEFT JOIN {{ ref('silver_loans') }} l
    ON b.BranchID = l.BranchID
    

GROUP BY
    b.BranchID,
    b.BranchName