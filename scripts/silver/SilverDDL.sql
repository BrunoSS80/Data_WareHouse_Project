/*
    =============================================
        CRIANDO TABELAS DA CAMADA SILVER
    =============================================

        Script para criação de tabelas da camada silver.
        Seguindo o Schema das tabelas bronze, criamos a 
    tabela silver com todos os novos campos necessários
    para a limpeza dos dados.
*/

DROP TABLE IF EXISTS silver_crm_cust_info;
CREATE TABLE silver_crm_cust_info(
    cst_id INT,
    cst_key VARCHAR(50),
    cst_firstname VARCHAR(50),
    cst_lastname VARCHAR(50),
    cst_marital_status VARCHAR(50),
    cst_gndr VARCHAR(50),
    cst_create_date VARCHAR(15),
    dwh_create_date VARCHAR(15) DEFAULT CURRENT_DATE
);

DROP TABLE IF EXISTS silver_crm_prd_info;
CREATE TABLE silver_crm_prd_info(
    prd_id INT,
    cat_id VARCHAR(50),
    prd_key VARCHAR(50),
    prd_nm VARCHAR(50),
    prd_cost INT,
    prd_line VARCHAR(50),
    prd_start_dt VARCHAR(15),
    prd_end_dt VARCHAR(15),
    dwh_create_date VARCHAR(15) DEFAULT CURRENT_DATE
);

DROP TABLE IF EXISTS silver_crm_sales_details;
CREATE TABLE silver_crm_sales_details (
    sls_ord_num VARCHAR(50),
    sls_prd_key VARCHAR(50),
    sls_cust_id INT,
    sls_order_dt VARCHAR(15),
    sls_ship_dt VARCHAR(15),
    sls_due_dt VARCHAR(15),
    sls_sales INT,
    sls_quantity INT, 
    sls_price INT,
    dwh_create_date VARCHAR(15) DEFAULT CURRENT_DATE
);

DROP TABLE IF EXISTS silver_erp_cust_az12;
CREATE TABLE silver_erp_cust_az12(
    cid VARCHAR(50),
    bdate VARCHAR(15),
    gen VARCHAR(50),
    dwh_create_date VARCHAR(15) DEFAULT CURRENT_DATE
);

DROP TABLE IF EXISTS silver_erp_loc_a101;
CREATE TABLE silver_erp_loc_a101(
    cid VARCHAR(50),
    cntry VARCHAR(50),
    dwh_create_date VARCHAR(15) DEFAULT CURRENT_DATE
);

DROP TABLE IF EXISTS silver_erp_px_cat_g1v2;
CREATE TABLE silver_erp_px_cat_g1v2(
    id VARCHAR(50),
    cat VARCHAR(50),
    subcat VARCHAR(50),
    maintenance VARCHAR(50),
    dwh_create_date VARCHAR(15) DEFAULT CURRENT_DATE
);