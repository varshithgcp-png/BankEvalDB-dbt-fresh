{{ config(materialized='table') }}

SELECT
    c.CustomerID,
    c.FirstName,
    c.LastName,

    COUNT(cd.CardID) AS TotalCards,

    COUNTIF(cd.Status = 'Active') AS ActiveCards,

    COUNTIF(cd.Status != 'Active') AS InactiveCards,

    COUNTIF(cd.CardType = 'Debit') AS DebitCards,

    COUNTIF(cd.CardType = 'Credit') AS CreditCards

FROM {{ ref('silver_customers') }} c

LEFT JOIN {{ ref('silver_accounts') }} a
    ON c.CustomerID = a.CustomerID

LEFT JOIN {{ ref('silver_cards') }} cd
    ON a.AccountID = cd.AccountID

GROUP BY
    c.CustomerID,
    c.FirstName,
    c.LastName
    