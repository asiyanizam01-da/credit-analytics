# Credit Analytics Portfolio Monitoring

An end-to-end Credit Analytics project demonstrating portfolio monitoring for a digital lending business using **PostgreSQL**, **SQL**, and **Microsoft Power BI**.

The project simulates a fintech lender ("ABC Cred") providing **ACS (Airtime Credit Service)**, **Nano Loans**, and **Buy Now Pay Later (BNPL)** products to thin-file borrowers using alternative behavioural data. It covers the complete analytics workflow from database design and data validation to credit portfolio analysis and interactive dashboard reporting.

---

## Tools & Technologies

* **PostgreSQL** — Relational database
* **pgAdmin 4** — Database administration and SQL execution
* **SQL** — Data validation and credit analytics
* **Microsoft Power BI** — Dashboard development and data visualisation

---

## Project Structure

```text
credit-analytics/

├── data/
│   ├── customers.csv
│   ├── loan_applications.csv
│   ├── loans.csv
│   └── loan_performance.csv
│
├── sql/
│   ├── 01_data_validation.sql
│   └── 02_credit_analysis.sql
│
├── powerbi/
│   └── credit_analytics_portfolio.pbix
│   └── credit_analytics_portfolio.pdf
│
└── README.md
```

---

## Business Scenario

A digital lending company provides instant credit through Mobile Network Operators (MNOs) across multiple countries. Since many customers are **thin-file borrowers**, traditional bureau scores are unavailable. Lending decisions rely on alternative behavioural indicators such as:

* Customer tenure
* Airtime top-up behaviour
* Top-up frequency
* Internal behavioural score

The objective is to monitor portfolio performance, identify credit risk trends, and support lending decisions through data-driven reporting.

---

## Dataset

**Source:** Synthetic dataset generated specifically for this project based on realistic digital lending business rules.

The PostgreSQL database consists of four related tables.

| Table                 | Description                                     |
| --------------------- | ------------------------------------------------ |
| **customers**          | Customer information and behavioural attributes |
| **loan_applications** | Loan applications and underwriting decisions    |
| **loans**             | Approved loans and portfolio information        |
| **loan_performance**  | Monthly repayment performance for each loan     |

### Dataset Size

| Table                       | Records |
| ---------------------------- | ------: |
| Customers                    |   5,000 |
| Loan Applications             |  10,000 |
| Loans                         |   6,920 |
| Monthly Performance Records   |  56,662 |

The dataset covers **January 2025 – December 2025** across five countries (Nigeria, Kenya, Ghana, Uganda, Pakistan) and three products (ACS, Nano, BNPL), with behavioural score distributions and repayment behaviour calibrated to be realistic and internally consistent.

---

## Database Design

```text
Customers
    │
    │ CustomerID
    ▼
Loan Applications
    │
    │ ApplicationID
    ▼
Loans
    │
    │ LoanID
    ▼
Loan Performance
```

Database relationships:

* One customer can submit multiple loan applications.
* One application produces zero or one approved loan.
* Every approved loan originates from one application.
* Every loan contains multiple monthly performance records.

---

## Project Workflow

### 1. Database Setup

* Created PostgreSQL database
* Designed relational tables with primary and foreign keys
* Imported four CSV datasets into PostgreSQL
* Verified successful data import and relationships

### 2. Data Validation

Performed SQL validation before analysis, including:

* Row count verification
* Primary key uniqueness checks
* Foreign key integrity checks
* Missing value detection
* Business rule validation
* Duplicate record checks

### 3. Credit Portfolio Analysis

Developed SQL queries to analyse:

* Underwriting performance (approval and decline rates, decline reasons)
* Portfolio composition and outstanding balances
* Delinquency rates and DPD bucket distribution
* Roll rate transitions between delinquency buckets (month-over-month, via self-join)
* Default rates and loss amounts
* Underwriting policy exceptions

### 4. Power BI Dashboard

Built an interactive dashboard consisting of four report pages:

1. **Executive Overview**
2. **Underwriting & Applications**
3. **Delinquency Analysis**
4. **Loss Metrics**

> Roll rate analysis was calculated in SQL but not included as a separate dashboard page in this version.

---

## Dashboard Overview

**Executive Overview** — Portfolio-level KPIs (total loans, approval rate, active loans, outstanding balance, delinquency rate, default rate), outstanding balance trend across 2025, and breakdowns by product and country. Includes slicers for Product, Country, and Loan Status.

**Underwriting & Applications** — Application volume, approval rate, and policy exceptions, with breakdowns by decision outcome, decline reason, product, country, and behavioural score band.

**Delinquency Analysis** — Delinquent loan count, delinquency rate trend across 2025, and DPD bucket distribution, broken down by product and country.

**Loss Metrics** — Defaulted loan count, default rate, and total loss amount, broken down by product, country, and loan status.

---

## SQL Techniques Used

| Technique              | Purpose                                               |
| ---------------------- | ----------------------------------------------- |
| INNER JOIN / LEFT JOIN | Table relationships and integrity checks              |
| Self Join / Window Functions (LAG) | Roll rate analysis between reporting months     |
| CASE                   | Business rule validation and conditional calculations |
| FILTER                 | Conditional aggregation                               |
| GROUP BY               | Portfolio summaries                                   |
| Aggregate Functions    | KPIs and portfolio metrics                            |
| INTERVAL               | Month-to-month loan migration comparisons             |

---

## Key Credit Metrics

* Approval Rate
* Active Loans
* Outstanding Balance
* Average Loan Amount
* Delinquency Rate
* Delinquency Bucket Distribution
* Roll Rates (SQL only)
* Default Rate
* Loss Amount
* Policy Exceptions

---

## Insights

* **BNPL drives portfolio value despite lower volume.** BNPL makes up only ~15% of applications but carries the largest share of outstanding balance (~145K), well above Nano (~110K) and ACS (~15K) — a direct result of BNPL's much larger ticket size per loan. ACS, by contrast, is the highest-volume product but contributes the least balance and the least loss, consistent with its small, short-tenor design.
* **Nigeria and Kenya dominate portfolio concentration.** These two markets account for over half of total outstanding balance (88K and 63K respectively) and the highest delinquent loan counts — expected, since they also have the largest application and customer volumes, not necessarily higher risk per loan.
* **Behavioural score is doing its job in underwriting.** "Low Behavioural Score" is by a clear margin the leading decline reason, ahead of fraud flags, policy rule failures, and incomplete data — confirming the alternative credit score is the primary lever driving approval decisions in a thin-file lending model.
* **Loss is concentrated by loan size, not by market risk.** BNPL contributes the largest total loss amount despite ACS/Nano having more defaulted loans in absolute count — losses scale with exposure per loan, not just default frequency, which is an important distinction for prioritising risk mitigation.
* **Loan status mix is broadly healthy.** Active/Closed/Defaulted splits at roughly 57% / 31% / 13% — a portfolio composition where the large majority of loans are performing or have been fully repaid.

---

## How to Run

1. Create a PostgreSQL database.
2. Create the required tables.
3. Import the four CSV files into PostgreSQL.
4. Run `01_data_validation.sql` to verify data integrity.
5. Run `02_credit_analysis.sql` to perform portfolio analysis.
6. Open the Power BI report (`credit_analytics_report.pbix`) to explore the dashboard.

---

## Future Enhancements

* Roll rate dashboard page (currently SQL-only)
* Probability of Default (PD) modelling
* Vintage / cohort analysis
* Collection performance reporting
* Interactive drill-through pages

---

## Disclaimer

This project uses a **synthetic dataset** created solely for educational and portfolio purposes. It does not contain any real customer information or confidential financial data.

---

## Author

**Asiya Nizam**
Data Analyst
GitHub: https://github.com/asiyanizam01-da
