/*
===============================================================================
Data Quality Checks: Gold Layer
===============================================================================
Purpose:
    This script validates the final gold-layer views used for reporting and
    analytics in the DataWarehouse project.

    The checks in this script focus on:
    - uniqueness of surrogate keys in dimension views
    - consistency between fact and dimension relationships
    - identifying missing links that could affect reporting accuracy

Usage:
    Run this script after the gold-layer views have been created or refreshed.

Notes:
    Most validation queries are expected to return no rows when the gold layer
    is functioning correctly.
===============================================================================
*/

USE DataWarehouse;
GO

PRINT '========================================================';
PRINT 'Running Gold Layer Quality Checks';
PRINT '========================================================';

PRINT '--------------------------------------------------------';
PRINT 'Checking gold.dim_customers';
PRINT '--------------------------------------------------------';

-- Check for duplicate customer surrogate keys
-- Expected result: no rows
SELECT
    customer_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;

PRINT '--------------------------------------------------------';
PRINT 'Checking gold.dim_products';
PRINT '--------------------------------------------------------';

-- Check for duplicate product surrogate keys
-- Expected result: no rows
SELECT
    product_key,
    COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

PRINT '--------------------------------------------------------';
PRINT 'Checking gold.fact_sales relationships';
PRINT '--------------------------------------------------------';

-- Check whether all fact records connect to valid dimension records
-- Expected result: no rows
SELECT
    *
FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products p
    ON p.product_key = f.product_key
WHERE c.customer_key IS NULL
   OR p.product_key IS NULL;

PRINT '========================================================';
PRINT 'Gold Layer Quality Checks Complete';
PRINT '========================================================';
