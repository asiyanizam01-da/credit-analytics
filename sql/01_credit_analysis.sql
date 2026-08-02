/* ===========================================================
   1. UNDERWRITING / APPLICATION ANALYSIS
   =========================================================== */

-- Overall Approval & Decline Rate

SELECT
    decision,
    COUNT(*) AS application_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM loan_applications
GROUP BY decision
ORDER BY application_count DESC;

-- Approval Rate by Product

SELECT
    product,
    COUNT(*) AS total_applications,

    SUM(
        CASE
            WHEN decision = 'Approved' THEN 1
            ELSE 0
        END
    ) AS approved_applications,

    ROUND(
        SUM(
            CASE
                WHEN decision = 'Approved' THEN 1
                ELSE 0
            END
        ) * 100.0 /
        COUNT(*),
        2
    ) AS approval_rate
FROM loan_applications
GROUP BY product
ORDER BY approval_rate DESC;

/* ===========================================================
   2. PORTFOLIO MONITORING
   =========================================================== */

-- Portfolio Summary KPIs

SELECT
    COUNT(*) AS total_loans,

    COUNT(*) FILTER (
        WHERE loan_status = 'Active'
    ) AS active_loans,

    ROUND(SUM(outstanding_balance),2) AS total_outstanding_balance,

    ROUND(AVG(loan_amount),2) AS average_loan_amount
FROM loans;

-- Portfolio Distribution by Country and Product

SELECT
    c.country,
    l.product,

    COUNT(l.loan_id) AS loan_count,

    ROUND(SUM(l.outstanding_balance),2) AS outstanding_balance
FROM loans l

INNER JOIN cr_customers c
ON l.customer_id = c.customer_id

GROUP BY
    c.country,
    l.product

ORDER BY
    c.country,
    outstanding_balance DESC;

/* ===========================================================
   3. DELINQUENCY ANALYSIS
   =========================================================== */

-- Delinquency Rate

SELECT
    COUNT(*) AS total_records,

    COUNT(*) FILTER (
        WHERE days_past_due > 0
    ) AS delinquent_records,

    ROUND(
        COUNT(*) FILTER (
            WHERE days_past_due > 0
        ) * 100.0 /
        COUNT(*),
        2
    ) AS delinquency_rate
FROM loan_performance;

-- Delinquency Bucket Distribution

SELECT
    delinquency_bucket,

    COUNT(*) AS performance_records,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage
FROM loan_performance

GROUP BY delinquency_bucket

ORDER BY
CASE delinquency_bucket
    WHEN 'Current' THEN 1
    WHEN '1-30' THEN 2
    WHEN '31-60' THEN 3
    WHEN '61-90' THEN 4
    WHEN '90+' THEN 5
END;

/* ===========================================================
   4. ROLL RATE ANALYSIS
   =========================================================== */

-- Month-to-Month Delinquency Roll Rate

SELECT
    current_month.delinquency_bucket AS from_bucket,
    next_month.delinquency_bucket AS to_bucket,

    COUNT(*) AS loan_count

FROM loan_performance current_month

INNER JOIN loan_performance next_month
ON current_month.loan_id = next_month.loan_id
AND next_month.report_month =
    current_month.report_month + INTERVAL '1 month'

GROUP BY
    current_month.delinquency_bucket,
    next_month.delinquency_bucket

ORDER BY
CASE current_month.delinquency_bucket
    WHEN 'Current' THEN 1
    WHEN '1-30' THEN 2
    WHEN '31-60' THEN 3
    WHEN '61-90' THEN 4
    WHEN '90+' THEN 5
END,

CASE next_month.delinquency_bucket
    WHEN 'Current' THEN 1
    WHEN '1-30' THEN 2
    WHEN '31-60' THEN 3
    WHEN '61-90' THEN 4
    WHEN '90+' THEN 5
END;

/* ===========================================================
   5. LOSS METRICS
   =========================================================== */

-- Default Rate

SELECT
    COUNT(*) AS total_loans,

    COUNT(*) FILTER (
        WHERE loan_status = 'Defaulted'
    ) AS defaulted_loans,

    ROUND(
        COUNT(*) FILTER (
            WHERE loan_status = 'Defaulted'
        ) * 100.0 /
        COUNT(*),
        2
    ) AS default_rate
FROM loans;

-- Loss Metrics by Product

SELECT
    product,

    COUNT(*) FILTER (
        WHERE loan_status = 'Defaulted'
    ) AS defaulted_loans,

    ROUND(
        SUM(
            CASE
                WHEN loan_status = 'Defaulted'
                THEN outstanding_balance
                ELSE 0
            END
        ),
        2
    ) AS loss_amount

FROM loans

GROUP BY product

ORDER BY loss_amount DESC;

/* ===========================================================
   6. POLICY MONITORING
   =========================================================== */

-- Underwriting Policy Exceptions

SELECT
    COUNT(*) AS policy_exceptions
FROM loan_applications
WHERE
    (behv_score_at_decision >= 550 AND decision = 'Declined')
    OR
    (behv_score_at_decision < 550 AND decision = 'Approved');




	