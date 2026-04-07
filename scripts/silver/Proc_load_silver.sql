/*
    ==================================================
        ADICIONANDO REGISTROS DE BRONZE -> SILVER
    ==================================================

        Esta query extrai os dados das tabelas bronze e tranfere para a camada silver.
        Todas as tabelas recebem uma transformação nos seus dados, garantindo a confiabilidade
    e segurança dos dados, facilitando analises futuras
*/

--Deletando dados existentes em: silver_crm_cust_info
DELETE FROM silver_crm_cust_info;
--Inserindo dados em: silver_crm_cust_info
INSERT INTO silver_crm_cust_info(
    cst_id,
    cst_key,
    cst_firstname,
    cst_lastname,
    cst_marital_status,
    cst_gndr, 
    cst_create_date
)
SELECT
cst_id,
cst_key,
TRIM(cst_firstname) AS cst_firstname,
TRIM(cst_lastname) AS cst_lastname,
CASE
    WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
    WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
    ELSE 'n/a'
END AS cst_marital_status,
CASE
    WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
    WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
    ELSE 'n/a'
END AS cst_gndr,
cst_create_date 
FROM(
    SELECT *, 
    ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date) AS flag_date
    FROM bronze_crm_cust_info
) t WHERE flag_date = 1;

--Deletando dados existentes em: silver_crm_prd_info
DELETE FROM silver_crm_prd_info;
--Inserindo dados em: silver_crm_prd_info
INSERT INTO silver_crm_prd_info(
    prd_id,
    cat_id,
    prd_key,
    prd_nm,
    prd_cost,
    prd_line,
    prd_start_dt,
    prd_end_dt
)
SELECT
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
SUBSTRING(prd_key, 7, LENGTH(prd_key)) AS prd_key,
prd_nm,
CASE
    WHEN prd_cost IS NULL OR prd_cost = '' THEN 0
    ELSE prd_cost
END AS prd_cost,
CASE UPPER(TRIM(prd_line))
    WHEN 'M' THEN 'Mountain'
    WHEN 'R' THEN 'Road'
    WHEN 'S' THEN 'Other Sales'
    WHEN 'T' THEN 'Touring'
    ELSE 'n/A'
END AS prd_line,
prd_start_dt,
DATE(LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt), '-1 DAY') AS prd_end_dt
from bronze_crm_prd_info;

--Deletando dados existentes em: silver_crm_sales_details
DELETE FROM silver_crm_sales_details;
--Inserindo dados em: silver_crm_sales_details
INSERT INTO silver_crm_sales_details(
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity, 
    sls_price
)
SELECT
sls_ord_num,
sls_prd_key,
sls_cust_id,
CASE
    WHEN sls_order_dt <= 0 or LENGTH(sls_order_dt) != 8 THEN NULL
    ELSE DATE(SUBSTRING(sls_order_dt, 1, 4)||'-'||SUBSTRING(sls_order_dt, 5, 2)||'-'||SUBSTRING(sls_order_dt, 7, 2))
END AS sls_order_dt,
CASE
    WHEN sls_ship_dt <= 0 or LENGTH(sls_ship_dt) != 8 THEN NULL
    ELSE DATE(SUBSTRING(sls_ship_dt, 1, 4)||'-'||SUBSTRING(sls_ship_dt, 5, 2)||'-'||SUBSTRING(sls_ship_dt, 7, 2))
END AS sls_ship_dt,
CASE
    WHEN sls_due_dt <= 0 or LENGTH(sls_due_dt) != 8 THEN NULL
    ELSE DATE(SUBSTRING(sls_due_dt, 1, 4)||'-'||SUBSTRING(sls_due_dt, 5, 2)||'-'||SUBSTRING(sls_due_dt, 7, 2))
END AS sls_due_dt,
CASE 
    WHEN sls_sales IS NULL 
    OR sls_sales = '' 
    OR sls_sales <= 0
    OR sls_sales != sls_quantity * ABS(sls_price)
        THEN 
            CASE 
                WHEN sls_quantity > 0 AND (sls_price IS NOT NULL AND sls_price != '')
                THEN sls_quantity * ABS(sls_price)
                ELSE sls_sales
            END
    ELSE sls_sales
END AS sls_sales,
sls_quantity,
CASE
    WHEN sls_price IS NULL OR sls_price = '' OR sls_price <= 0 
    THEN sls_sales/nullif(sls_quantity,0)
    ELSE sls_price
END AS sls_price
FROM bronze_crm_sales_details;

--Deletando dados existentes em: silver_erp_cust_az12
DELETE FROM silver_erp_cust_az12;
--Inserindo dados em: silver_erp_cust_az12
INSERT INTO silver_erp_cust_az12(cid, bdate, gen)
SELECT
CASE
    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LENGTH(cid))
    ELSE cid
END AS cid,
CASE
    WHEN bdate > CURRENT_DATE THEN NULL
    ELSE bdate
END AS bdate,
CASE
    WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
    WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
    ELSE 'n/a'
END AS gen
from bronze_erp_cust_az12;

--Deletando dados existentes em: silver_erp_loc_a101
DELETE FROM silver_erp_loc_a101;
--Inserindo dados em: silver_erp_loc_a101
INSERT INTO silver_erp_loc_a101(
    cid,
    cntry
)
SELECT 
REPLACE(cid, '-', '') AS cid,
CASE
    WHEN TRIM(cntry) = 'DE' THEN 'Germany'
    WHEN TRIM(cntry) IN ('US', 'USA') THEN 'United States'
    WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
    else TRIM(cntry)
END AS cntry
FROM bronze_erp_loc_a101;

--Deletando dados existentes em: silver_erp_px_cat_g1v2
DELETE FROM silver_erp_px_cat_g1v2;
--Inserindo dados em: silver_erp_px_cat_g1v2
INSERT INTO silver_erp_px_cat_g1v2(
    id,
    cat,
    subcat,
    maintenance
)
SELECT 
id,
cat,
subcat,
maintenance
FROM bronze_erp_px_cat_g1v2;