{{ config(materialized='table') }}

SELECT
    l.LoanID,
    l.CustomerID,
    l.BranchID,
    l.Principal,
    l.Status AS LoanStatus,

    COUNT(lp.PaymentID) AS TotalPayments,

    COALESCE(SUM(lp.Amount), 0) AS TotalPaymentAmount,

    COUNTIF(lp.Status = 'Paid') AS PaidPayments,

    COUNTIF(lp.Status != 'Paid') AS PendingPayments,

    MAX(lp.PaidDate) AS LastPaidDate

FROM {{ ref('silver_loans') }} l

LEFT JOIN {{ ref('silver_loan_payments') }} lp
    ON l.LoanID = lp.LoanID

GROUP BY
    l.LoanID,
    l.CustomerID,
    l.BranchID,
    l.Principal,
    l.Status
    