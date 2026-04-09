/*
    =============================================
        CRIANDO TABELAS DA CAMADA GOLD
    =============================================

    Este script cria as View da camada Gold para o DataWareHouse.
    A camada Gold representa as tabelas dimensão e fato finais, utilizando Star Schema. 

    Cada visualização realiza transformações e combina dados da camada Silver 
    para produzir um conjunto de dados limpo, enriquecido e pronto para negócios.
*/


CREATE VIEW gold_dim_customer AS
SELECT ROW_NUMBER() OVER (
        ORDER BY cst_id
    ) AS customer_key,
    ci.cst_id AS customer_id,
    ci.cst_key AS customer_number,
    ci.cst_firstname AS first_name,
    ci.cst_lastname AS last_name,
    la.cntry AS country,
    CASE
        WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr
        ELSE COALESCE(cb.gen, 'n/a')
    END AS gender,
    ci.cst_marital_status AS marital_status,
    cb.bdate AS birthdate,
    ci.cst_create_date AS create_date
FROM silver_crm_cust_info ci
    LEFT JOIN silver_erp_cust_az12 cb 
    ON ci.cst_key = cb.cid
    LEFT JOIN silver_erp_loc_a101 la 
    ON ci.cst_key = la.cid;


CREATE VIEW gold_dim_products AS
SELECT ROW_NUMBER() OVER (ORDER BY pn.prd_start_dt,pn.prd_key) AS product_key,
    pn.prd_id AS product_id,
    pn.prd_key AS product_number,
    pn.prd_nm AS product_name,
    pn.cat_id AS category_id,
    pc.cat AS category,
    pc.subcat AS subcategory,
    pc.maintenance,
    pn.prd_cost AS cost,
    pn.prd_line AS product_line,
    pn.prd_start_dt AS start_date
FROM silver_crm_prd_info pn
    LEFT JOIN silver_erp_px_cat_g1v2 pc 
    ON pc.id = pn.cat_id
WHERE pn.prd_end_dt IS NULL;

CREATE VIEW gold_fact_sales AS
SELECT sd.sls_ord_num AS order_number,
    pr.product_key,
    cu.customer_key,
    sd.sls_order_dt AS order_date,
    sd.sls_ship_dt AS shipping_date,
    sd.sls_due_dt AS due_date,
    sd.sls_sales AS sales_amount,
    sd.sls_quantity AS quantity,
    sd.sls_price AS price
FROM silver_crm_sales_details sd
    LEFT JOIN gold_dim_products pr 
    ON sd.sls_prd_key = pr.product_number
    LEFT JOIN gold_dim_customer cu 
    ON sd.sls_cust_id = cu.customer_id;
