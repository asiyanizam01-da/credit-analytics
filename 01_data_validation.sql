/* ===========================================================
	Credit Analytics Portfolio Monitoring Project
 	File: 01_data_validation.sql
 	Purpose: Data loading, integrity, and business rule checks 
 	Author: Asiya Nizam
 	Tool: PostgreSQL (pgAdmin)
    =========================================================== */

/*
NOTE:
Highlight and run each query individually for the best readability of outputs.
*/

/*	===========================================
	1. Initial Data Inspection
	===========================================	*/
	
SELECT	*
FROM cr_customers
LIMIT 10;

SELECT *
FROM loan_applications
LIMIT 10;

SELECT *
FROM loans
LIMIT 10;

SELECT *
FROM loan_performance
LIMIT 10;

/*	=============================================
	2. Row Count Check
	============================================= */

SELECT COUNT(*) AS customer_count
FROM cr_customers;

SELECT COUNT(*) AS application_count
FROM loan_applications;

SELECT COUNT(*) AS loan_count
FROM loans;

SELECT COUNT(*) AS performance_count
FROM loan_performance;

/*	==============================================
	3. Table Structure Validation
	============================================== */

SELECT
	table_name,
	column_name,
	data_type
FROM information_schema.columns
WHERE table_schema = 'public'
ORDER BY table_name, ordinal_position;

/*	==============================================
	4.	Primary Key Duplicate Checks
	============================================== */
	
-- Customers Table

SELECT
	customer_id,
	COUNT(*) AS duplicate_count
FROM cr_customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

-- Loans Applications Table

SELECT
	application_id,
	COUNT(*) AS duplicate_count
FROM loan_applications
GROUP BY application_id
HAVING COUNT(*) > 1;

-- Loans Table

SELECT
	loan_id,
	COUNT(*) AS duplicate_count
FROM loans
GROUP BY loan_id
HAVING COUNT(*) > 1;

-- Loan Performance

SELECT
	performance_id,
	COUNT(*) AS duplicate_count
FROM loan_performance
GROUP BY performance_id
HAVING COUNT(*) > 1;

/*	============================================
	5. Foreign Key Integrity Checks
	============================================ */

-- Applications Without Customer

SELECT COUNT(*) AS orphan_applications
FROM loan_applications AS a
LEFT JOIN cr_customers AS c
ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Loans Without Applications

SELECT COUNT(*) AS orphan_loan_application
FROM loans AS l
LEFT JOIN loan_applications AS a
ON l.application_id = a.application_id
WHERE a.application_id IS NULL;

-- Loans Without Customers

SELECT COUNT(*) AS orphan_loan_customers
FROM loans AS l
LEFT JOIN cr_customers AS c
ON l.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Performance Records Without Loans

SELECT COUNT(*) AS orphan_performance_records
FROM loan_performance AS p
LEFT JOIN loans AS l
ON p.loan_id = l.loan_id
WHERE l.loan_id IS NULL;

/*	=================================================
	6. Missing Value Checks
	================================================= */

-- Customers

SELECT 
	COUNT(*) FILTER(WHERE customer_id IS NULL) AS missing_customer_id,
	COUNT(*) FILTER(WHERE behavioral_score IS NULL) AS missing_behavioral_scores,
	COUNT(*) FILTER(WHERE avg_monthly_topup IS NULL) AS missing_top_up
FROM cr_customers;
	
-- Loan Applications

SELECT
	COUNT(*) FILTER(WHERE application_id IS NULL) AS missing_application_id,
	COUNT(*) FILTER(WHERE customer_id IS NULL) AS missing_customer_id,
	COUNT(*) FILTER(WHERE req_amount IS NULL) AS missing_amount
FROM loan_applications;

-- Loans

SELECT
	COUNT(*) FILTER(WHERE loan_id IS NULL) AS missing_loan_id,
	COUNT(*) FILTER(WHERE loan_amount IS NULL) AS missing_loan_amount,
	COUNT(*) FILTER(WHERE outstanding_balance IS NULL) AS missing_balance
FROM loans;

-- Loans Performance

SELECT
	COUNT(*) FILTER(WHERE performance_id IS NULL) AS missing_performance_id,
	COUNT(*) FILTER(WHERE days_past_due IS NULL) AS missing_dpd
FROM loan_performance;

/*	====================================================
	7. Business Rule Validation
	==================================================== */

-- Approved Application Should Create Loan Record

SELECT
	COUNT(*) AS approved_without_loan
FROM loan_applications AS a 
LEFT JOIN loans AS l
ON a.application_id = l.application_id
WHERE a.decision = 'Approved'
AND l.loan_id IS NULL;

-- Declined Applications Should Not Create Loans

SELECT
	COUNT(*) AS declined_with_loan
FROM loan_applications AS a
INNER JOIN loans AS l
ON a.application_id = l.application_id
WHERE a.decision = 'Declined';

-- Loan Amount Should Match Requested Amount

SELECT 
	COUNT(*) AS amount_mismatch
FROM loans AS l
LEFT JOIN loan_applications AS a
ON l.application_id = a.application_id
WHERE l.loan_amount <> a.req_amount;

-- Outstanding Balance Should Not Exceed Loan Amount

SELECT
	COUNT(*) AS invalid_balance
FROM loans
WHERE outstanding_balance > loan_amount;

/*	===============================================
	8. Exploratory Data Distribution
	=============================================== */

-- Product Distribution

SELECT	product,
		COUNT(*) AS count
FROM loan_applications
GROUP BY product
ORDER BY count DESC;

-- Decision Distribution

SELECT	decision,
		COUNT(*) AS count
FROM loan_applications
GROUP BY decision
ORDER BY count DESC;

-- Loan Status Distribution

SELECT	loan_status,
		COUNT(*) AS count
FROM loans 
GROUP BY loan_status
ORDER BY count DESC;

-- Delinquency Bucket Distribution

SELECT
	delinquency_bucket,
	COUNT(*) AS count
FROM loan_performance
GROUP BY delinquency_bucket
ORDER BY count DESC;

-- Default Flag Consistency

SELECT COUNT(*) AS inconsistent_defaults
FROM loan_performance
WHERE (days_past_due > 90 AND default_flag = FALSE)
 OR (days_past_due <= 90 AND default_flag = TRUE);

-- DPD Validation

SELECT COUNT(*) AS negative_dpd
FROM loan_performance
WHERE days_past_due < 0;

-- Outstanding Balance in Monthly Snapshots

SELECT COUNT(*) AS negative_balance
FROM loan_performance
WHERE outstanding_balance < 0;

/* ==========================================================
   End of Data Validation Checks
   ========================================================== */












