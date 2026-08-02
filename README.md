# Credit Analytics Portfolio Monitoring

An end-to-end Credit Analytics project demonstrating portfolio monitoring for a digital lending business using **PostgreSQL**, **SQL**, and **Microsoft Power BI**.

The project simulates a fintech lender providing **ACS (Airtime Credit Service)**, **Nano Loans**, and **Buy Now Pay Later (BNPL)** products to thin-file borrowers using alternative behavioural data. It covers the complete analytics workflow from database design and data validation to credit portfolio analysis and interactive dashboard reporting.

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
│   └── credit_analytics_report.pbix
│
├── screenshots/
│   ├── executive_overview.png
│   ├── portfolio_monitoring.png
│   ├── delinquency_analysis.png
│   ├── roll_rate_analysis.png
│   └── loss_metrics.png
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
| --------------------- | ----------------------------------------------- |
| **cr_customers**      | Customer information and behavioural attributes |
| **loan_applications** | Loan applications and underwriting decisions    |
| **loans**             | Approved loans and portfolio information        |
| **loan_performance**  | Monthly repayment performance for each loan     |

### Dataset Size

| Table                       | Approximate Records |
| --------------------------- | ------------------: |
| Customers                   |               5,000 |
| Loan Applications           |              10,000 |
| Loans                       |         6,500–7,000 |
| Monthly Performance Records |       60,000–80,000 |

The dataset covers **January 2025 – December 2025** and includes multiple countries, lending products, behavioural score distributions, realistic repayment behaviour, and a small number of intentional data quality issues for validation exercises.

---

## Database Design

The project follows a relational database design.

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
* Table structure validation
* Primary key uniqueness checks
* Foreign key integrity checks
* Missing value detection
* Business rule validation
* Portfolio distribution checks
* Data quality validation

### 3. Credit Portfolio Analysis

Developed SQL queries to analyse:

* Underwriting performance
* Approval and decline rates
* Portfolio composition
* Outstanding balances
* Delinquency rates
* Delinquency bucket distribution
* Roll rate transitions
* Default rates
* Portfolio losses
* Underwriting policy exceptions

### 4. Power BI Dashboard

Built an interactive dashboard consisting of five report pages:

1. Executive Overview
2. Portfolio Monitoring
3. Delinquency Analysis
4. Roll Rate Analysis
5. Loss Metrics

---

## SQL Techniques Used

| Technique              | Purpose                                               |
| ---------------------- | ----------------------------------------------------- |
| INNER JOIN / LEFT JOIN | Table relationships and integrity checks              |
| Self Join              | Roll rate analysis between reporting months           |
| CASE                   | Business rule validation and conditional calculations |
| FILTER                 | Conditional aggregation                               |
| Window Functions       | Percentage calculations                               |
| GROUP BY               | Portfolio summaries                                   |
| Aggregate Functions    | KPIs and portfolio metrics                            |
| INTERVAL               | Month-to-month loan migration analysis                |

---

## Key Credit Metrics

The project calculates and visualises:

* Approval Rate
* Active Loans
* Outstanding Balance
* Average Loan Amount
* Delinquency Rate
* Delinquency Bucket Distribution
* Roll Rates
* Default Rate
* Loss Amount
* Policy Exceptions

---

## How to Run

1. Create a PostgreSQL database.
2. Create the required tables.
3. Import the four CSV files into PostgreSQL.
4. Run `01_data_validation.sql` to verify data integrity.
5. Run `02_credit_analysis_queries.sql` to perform portfolio analysis.
6. Open the Power BI report (`credit_analytics_portfolio.pbix`) to explore the dashboard.

---

## Dashboard


---

## Future Enhancements

Potential extensions include:

* Probability of Default (PD) modelling
* Vintage analysis
* Cohort analysis
* Collection performance reporting
* Interactive drill-through pages
* Automated database refresh using Power BI

---

## Disclaimer

This project uses a **synthetic dataset** created solely for educational and portfolio purposes. It does not contain any real customer information or confidential financial data.

---

## Author

**Asiya Nizam**

Data Analyst

GitHub: https://github.com/asiyanizam01-da
