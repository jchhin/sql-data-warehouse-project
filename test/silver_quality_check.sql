/*
===============================================================================
Data Quality Checks: Silver Layer
===============================================================================
Purpose:
    This script runs validation checks against the silver layer to confirm that
    transformed data is clean, consistent, and ready for downstream use.

    The checks in this script focus on:
    - duplicate or missing business keys
    - leading and trailing spaces in text fields
    - standardized categorical values
    - invalid or inconsistent dates
    - mismatches across related numeric fields

Usage:
    Run this script after loading the silver layer.

Notes:
    Most validation queries are expected to return no rows when the data is
    clean. Queries that return distinct values are intended for review of
    standardization and consistency.
===============================================================================
*/

USE DataWarehouse;
GO

PRINT '========================================================';
PRINT 'Running Silver Layer Quality Checks';
PRINT '========================================================';

PRINT '--------------------------------------------------------';
PRINT 'Checking silver.crm_cust_info';
PRINT '--------------------------------------------------------';

-- Check for duplicate or missing customer IDs
-- Expected result: no rows
SELECT
    cst_id,
    COUNT(*) AS record_count
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Check for unwanted spaces in customer keys
-- Expected result: no rows
SELECT
    cst_key
FROM silver.crm_cust_info
WHERE cst_key <> TRIM(cst_key);

-- Review standardized marital status values
SELECT DISTINCT
    cst_marital_status
FROM silver.crm_cust_info
ORDER BY cst_marital_status;

PRINT '--------------------------------------------------------';
PRINT 'Checking silver.crm_prd_info';
PRINT '--------------------------------------------------------';

-- Check for duplicate or missing product IDs
-- Expected result: no rows
SELECT
    prd_id,
    COUNT(*) AS record_count
FROM silver.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces in product names
-- Expected result: no rows
SELECT
    prd_nm
FROM silver.crm_prd_info
WHERE prd_nm <> TRIM(prd_nm);

-- Check for null or negative product cost values
-- Expected result: no rows
SELECT
    prd_cost
FROM silver.crm_prd_info
WHERE prd_cost IS NULL
   OR prd_cost < 0;

-- Review standardized product line values
SELECT DISTINCT
    prd_line
FROM silver.crm_prd_info
ORDER BY prd_line;

-- Check for invalid product date ranges
-- Expected result: no rows
SELECT
    *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

PRINT '--------------------------------------------------------';
PRINT 'Checking silver.crm_sales_details';
PRINT '--------------------------------------------------------';

-- Check for invalid source due dates in the bronze layer
-- Expected result: no rows
SELECT
    NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0
   OR LEN(sls_due_dt) <> 8
   OR sls_due_dt > 20500101
   OR sls_due_dt < 19000101;

-- Check for invalid sales date ordering
-- Expected result: no rows
SELECT
    *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;

-- Check whether sales values align with quantity × price
-- Expected result: no rows
SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales <> sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

PRINT '--------------------------------------------------------';
PRINT 'Checking silver.erp_cust_az12';
PRINT '--------------------------------------------------------';

-- Check for unrealistic or future birthdates
-- Expected result: no rows
SELECT DISTINCT
    bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE()
ORDER BY bdate;

-- Review standardized gender values
SELECT DISTINCT
    gen
FROM silver.erp_cust_az12
ORDER BY gen;

PRINT '--------------------------------------------------------';
PRINT 'Checking silver.erp_loc_a101';
PRINT '--------------------------------------------------------';

-- Review standardized country values
SELECT DISTINCT
    cntry
FROM silver.erp_loc_a101
ORDER BY cntry;

PRINT '--------------------------------------------------------';
PRINT 'Checking silver.erp_px_cat_g1v2';
PRINT '--------------------------------------------------------';

-- Check for unwanted spaces in category-related fields
-- Expected result: no rows
SELECT
    *
FROM silver.erp_px_cat_g1v2
WHERE cat <> TRIM(cat)
   OR subcat <> TRIM(subcat)
   OR maintenance <> TRIM(maintenance);

-- Review standardized maintenance values
SELECT DISTINCT
    maintenance
FROM silver.erp_px_cat_g1v2
ORDER BY maintenance;

PRINT '========================================================';
PRINT 'Silver Layer Quality Checks Complete';
PRINT '========================================================';
