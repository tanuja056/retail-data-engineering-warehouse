# End-to-End Retail Data Engineering Warehouse

An end-to-end data engineering project built with **Databricks, PySpark, Delta Lake, and SQL**, using the UCI Online Retail II dataset.

The project demonstrates batch data ingestion, multi-layer data transformation, dimensional data modeling, Delta Lake MERGE operations, data quality validation, and business analytics.

## Architecture

```text
UCI Online Retail II Dataset
          |
          v
   Bronze Layer
   Raw transaction data
          |
          v
   Silver Layer
   Data cleaning and validation
   Duplicate removal
   Transaction classification
          |
          v
    Gold Layer
   Fact and dimension tables
   Invoice-level summary
          |
          v
   SQL Analytics
   Revenue trends
   Customer analysis
   Country performance
   Data reconciliation
```

## Technology Stack

- **Cloud Platform:** Databricks
- **Processing:** Apache Spark, PySpark
- **Storage Format:** Delta Lake
- **Query Language:** SQL
- **Programming Language:** Python
- **Data Modeling:** Star schema
- **Version Control:** Git, GitHub

## Dataset

Source: [UCI Online Retail II Dataset](https://archive.ics.uci.edu/dataset/502/online+retail+ii)

The dataset contains retail transactions from December 2009 through December 2011.

- Original records: 1,067,371
- Source files: Two CSV files
- Data includes invoices, products, quantities, prices, customers, dates, and countries.

## Data Engineering Pipeline

### 1. Bronze — Data Ingestion

- Loaded both source CSV files into Databricks Unity Catalog Volumes.
- Read the files using PySpark.
- Standardized column names.
- Added ingestion timestamps and source file metadata.
- Stored raw transaction records as a Delta table.

**Table:** `workspace.retail_warehouse.bronze_retail_transactions`

### 2. Silver — Data Transformation

- Standardized data types and timestamp fields.
- Removed duplicate transactions.
- Filtered invalid records.
- Classified returns and cancellations.
- Calculated transaction-level revenue.
- Added invoice year and month attributes.

**Table:** `workspace.retail_warehouse.silver_retail_transactions`

### 3. Gold — Data Warehouse

Designed analytical tables using a fact-and-dimension model.

| Table | Records |
|---|---:|
| dim_customer | 5,942 |
| dim_product | 5,304 |
| dim_date | 604 |
| fact_sales | 1,033,031 |
| gold_invoice_summary | 53,623 |

The invoice summary aggregates transaction lines by invoice for invoice-level analytics.

### 4. Incremental Processing and Delta MERGE

- Tested Delta Lake MERGE operations for updating existing invoice summaries and inserting new invoice records.
- Validated invoice-level business keys.
- Investigated overlapping invoices across the two source files.
- Rebuilt the final invoice summary from the complete Silver dataset to ensure accurate aggregation across both files.

**Note:** The MERGE update and insert behavior was tested successfully. The historical two-batch processing test exposed overlapping invoices, so the final summary was rebuilt using the complete Silver dataset. Fully automated incremental handling of overlapping invoices remains future work.

### 5. Data Quality Validation

Executed six validation checks:

- Silver and Gold tables are not empty.
- No duplicate invoice keys in the Gold summary.
- No null invoice keys.
- Silver and Gold revenue reconcile.
- Invoice counts reconcile.
- Final validation result: **6 of 6 checks passed.**

## Pipeline Results

| Metric | Result |
|---|---:|
| Bronze records | 1,067,371 |
| Silver records | 1,033,031 |
| Duplicate records removed | 34,335 |
| Invalid records removed | 5 |
| Gold fact records | 1,033,031 |
| Invoice summary records | 53,623 |
| Silver revenue | $19,014,209.82 |
| Gold revenue | $19,014,209.82 |
| Revenue difference | $0.00 |

## Business Analytics

SQL queries were developed to analyze:

1. Monthly revenue trends, units sold, and invoice counts.
2. Top 10 customers by revenue.
3. Country-level sales performance.
4. Silver-to-Gold revenue reconciliation.

### Selected Findings

- November 2011 recorded the highest monthly revenue: approximately $1.46 million.
- Customer 18102 generated approximately $570,380 in revenue.
- The United Kingdom generated approximately $16.14 million in revenue.
- Silver and Gold revenue reconciled with a difference of $0.00.

## Repository Structure

```text
retail-data-engineering-warehouse/
│
├── data/
│   ├── raw/
│   └── sample/
│
├── notebooks/
│   ├── 01_bronze_ingestion.py
│   ├── 02_silver_transformation.py
│   ├── 03_gold_warehouse.py
│   ├── 04_incremental_loading.py
│   └── 05_sql_analytics.py
│
├── sql/
│   └── analytical_queries.sql
│
├── src/
├── tests/
├── docs/
├── .gitignore
└── README.md
```

## Running the Project

1. Download the Online Retail II dataset from the UCI Machine Learning Repository.
2. Upload the two CSV files to a Databricks Unity Catalog Volume.
3. Create the `workspace.retail_warehouse` schema.
4. Run the notebooks in sequence:
   - Bronze ingestion
   - Silver transformation
   - Gold warehouse
   - Incremental loading
   - SQL analytics
5. Review the resulting Delta tables and analytical queries.

The notebooks were developed for Databricks with Unity Catalog and Serverless compute.

## Future Improvements

- Implement robust incremental processing for invoices spanning multiple source batches.
- Add automated pipeline orchestration.
- Add scheduled data quality checks.
- Implement logging and failure handling.
- Build a Power BI dashboard on top of the Gold warehouse.

## Author

**Tanuja Kokkiligadda**

M.S. Data Science | University of Memphis

[GitHub](https://github.com/tanuja056)