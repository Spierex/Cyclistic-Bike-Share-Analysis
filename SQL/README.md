# SQL Workflow

The Cyclistic project uses PostgreSQL for data preparation and analysis.

## Execution order

Run the scripts in this order:

1. `01_data_cleaning.sql`
2. `02_feature_engineering.sql`
3. `03_analysis.sql`

The scripts are separated by purpose so that the repository shows the progression from raw imported data to an analysis-ready reporting layer.

## What each script demonstrates

### 01 — Data Cleaning
- Missing-value handling
- Deduplication with `ROW_NUMBER()`
- Timestamp conversion
- Interval and duration calculations
- Outlier/data-quality filtering
- Station-name standardisation

### 02 — Feature Engineering
- Hour extraction
- Month extraction
- Day-of-week extraction
- Creation of the `cyclistic_analysis` reporting view restricted to 2024+

### 03 — Analysis
- Rider-type comparisons
- Ride-duration analysis
- Time-of-day and monthly analysis
- Rideable-type analysis
- Station analysis
- Casual-share calculations
- Journey analysis
- Station-name quality checks
- Preparation of station coordinates for Power BI mapping

## Important note

The exact SQL predicates used for two documented geographic-cleaning steps were not preserved in the project records. Those predicates have deliberately not been reconstructed or invented. The cleaning log records that 41 implausible-coordinate records and 7 additional suspicious-longitude records were removed.
