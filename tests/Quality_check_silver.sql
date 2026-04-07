/*
    ==================================================
                    QUALITY CHECK
    ==================================================
Proposta do script:
        Este script tem como objectivo verificar a consistência, acuracidade
    e padronização dentro da camada silver. Incluindo checks para:
    - Chaves nulas ou com duplicidade.
    - Espaços indesejados entre strings.
    - Padronização de dados e consistência.
    - Consistência de dados entre diferentes tabelas, para futuras ligações.

Notas para uso:
    - Execute essas query somente após fazer toda a iniciação e inclusão
    de dados na tabela silver.
*/

-- ====================================================================
-- Checking 'silver_crm_cust_info'
-- ====================================================================
-- Checando por chaves nulas ou duplicadas

SELECT 
    cst_id,
    COUNT(*) 
FROM silver_crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- Checando por espaços nas strings.

SELECT 
    cst_key 
FROM silver_crm_cust_info
WHERE cst_key != TRIM(cst_key);

-- Padronização e consistencia dos dados
SELECT DISTINCT 
    cst_marital_status 
FROM silver_crm_cust_info;

-- ====================================================================
-- Checking 'silver_crm_prd_info'
-- ====================================================================
-- Checando por chaves nulas ou duplicadas

SELECT 
    prd_id,
    COUNT(*) 
FROM silver_crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Checando por espaços nas strings.

SELECT 
    prd_nm 
FROM silver_crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Checando valores nulos ou negativos.

SELECT 
    prd_cost 
FROM silver_crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Padronização de dados e consistência

SELECT DISTINCT 
    prd_line 
FROM silver_crm_prd_info;

-- Checando ordem de datas invalidas (Start Date > End Date)

SELECT 
    * 
FROM silver_crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- ====================================================================
-- Checking 'silver_crm_sales_details'
-- ====================================================================
-- Checando por datas invalidas

SELECT 
    NULLIF(sls_due_dt, 0) AS sls_due_dt 
FROM bronze_crm_sales_details
WHERE sls_due_dt <= 0 
    OR LENGTH(sls_due_dt) != 8 
    OR sls_due_dt > 20500101 
    OR sls_due_dt < 19000101;

-- Checando ordem de datas invalidas (Order Date > Shipping/Due Dates)

SELECT 
    * 
FROM silver_crm_sales_details
WHERE sls_order_dt > sls_ship_dt 
   OR sls_order_dt > sls_due_dt;

-- Checando consistencia de dados: Sales = Quantity * Price

SELECT DISTINCT 
    sls_sales,
    sls_quantity,
    sls_price 
FROM silver_crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

-- ====================================================================
-- Checking 'silver_erp_cust_az12'
-- ====================================================================
-- Identificando datas fora do limite

SELECT DISTINCT 
    bdate 
FROM silver_erp_cust_az12
WHERE bdate < '1924-01-01' 
   OR bdate > GETDATE();

-- Padronização e consistencia de dados

SELECT DISTINCT 
    gen 
FROM silver_erp_cust_az12;

-- ====================================================================
-- Checking 'silver_erp_loc_a101'
-- ====================================================================
-- Padronização e consistencia de dados

SELECT DISTINCT 
    cntry 
FROM silver_erp_loc_a101
ORDER BY cntry;

-- ====================================================================
-- Checking 'silver_erp_px_cat_g1v2'
-- ====================================================================
-- Checando por espaços indesejados

SELECT 
    * 
FROM silver_erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat) 
   OR maintenance != TRIM(maintenance);

-- Padronização e consistencia de dados
SELECT DISTINCT 
    maintenance 
FROM silver_erp_px_cat_g1v2;