# Data Catalog para a Gold Layer

## Visão Geral
A camada gold é a representação dos dados no nivel de negocio, estruturado para suportar buscas analiticas e relatórios. Ela consiste em **tabelas de dimensão** e **tabeças de fato** para metricas especificas do negócio.

---

### 1. **gold_dim_customers**
- **Propósito:** Armazena detalhes do cliente enriquecidos com dados demográficos e geográficos.
- **Colunas:**

| Column Name      | Data Type     | Description                                                                                   |
|------------------|---------------|-----------------------------------------------------------------------------------------------|
| customer_key     | INT           | Chave substituta identificando exclusivamente cada registro de cliente na tabela de dimensão. |
| customer_id      | INT           | Identificador numérico único atribuído a cada cliente.                                        |
| customer_number  | VARCHAR(50)   | Identificador alfanumérico que representa o cliente, usado para rastreamento e referência.    |
| first_name       | VARCHAR(50)   | O primeiro nome do cliente, conforme registrado no sistema.                                   |
| last_name        | VARCHAR(50)   | O sobrenome do cliente, conforme registrado no sistema.                                       |
| country          | VARCHAR(50)   | O país de residência do cliente (por exemplo, 'Austrália').                                   |
| marital_status   | VARCHAR(50)   | O estado civil do cliente (por exemplo, 'Casado', 'Solteiro').                                |
| gender           | VARCHAR(50)   | O gênero do cliente (por exemplo, 'Masculino', 'Feminino', 'n/a').                            |
| birthdate        | VARCHAR(15)   | A data de nascimento do cliente, formatada como AAAA-MM-DD (por exemplo, 1971-10-06).         |
| create_date      | VARCHAR(15)   | A data em que o registro do cliente foi criado no sistema                                     |

---

### 2. **gold_dim_products**
- **Propósito:** Fornece informações sobre os produtos e seus atributos.
- **Colunas:**

| Column Name         | Data Type     | Description                                                                                   |
|---------------------|---------------|-----------------------------------------------------------------------------------------------|
| product_key         | INT           | Chave substituta identificando de forma única cada registro de produto na tabela de dimensão. |
| product_id          | INT           | Um identificador único atribuído ao produto para rastreamento e referências internas.         |
| product_number      | VARCHAR(50)   | Identificador alfanumérico que representa o cliente, usado para rastreamento e referência.    |
| product_name        | VARCHAR(50)   | Nome descritivo do produto, incluindo detalhes principais como tipo, cor e tamanho.           |
| category_id         | VARCHAR(50)   | Um identificador único para a categoria do produto, vinculando à sua classificação.           |
| category            | VARCHAR(50)   | A classificação mais ampla do produto (por exemplo, Bicicletas, Componentes)                  |
| subcategory         | VARCHAR(50)   | Uma classificação mais detalhada do produto dentro da categoria, como o tipo de produto.      |
| maintenance_required| VARCHAR(50)   | Indica se o produto requer manutenção (por exemplo, 'Sim', 'Não').                            |
| cost                | INT           | O custo ou preço base do produto.                                                             |
| product_line        | VARCHAR(50)   | A linha ou série específica à qual o produto pertence (por exemplo, Estrada, Montanha).       |
| start_date          | VARCHAR(15)   | A data em que o produto se tornou disponível para venda ou uso.                               | 

---

### 3. **gold_fact_sales**
- **Propósito:** Armazena dados de vendas transacionais para fins analíticos.
- **Colunas:**

| Column Name     | Data Type     | Description                                                                                   |
|-----------------|---------------|-----------------------------------------------------------------------------------------------|
| order_number    | NVARCHAR(50)  | Um identificador alfanumérico único para cada pedido de venda (por exemplo, 'SO54496').       |
| product_key     | INT           | Chave substituta vinculando o pedido à tabela de dimensão do produto.                         |
| customer_key    | INT           | Chave substituta vinculando o pedido à tabela de dimensão do cliente.                         |
| order_date      | VARCHAR(15)   | A data que o pedido foi feito.                                                                |
| shipping_date   | VARCHAR(15)   | A data que o pedido foi enviado para o cliente.                                               |
| due_date        | VARCHAR(15)   | A data que o pagamento do pedido fo feito.                                                    |
| sales_amount    | INT           | O valor monetário total da venda para o item da linha (por exemplo, 25).                      |
| quantity        | INT           | O número de unidades do produto solicitado para o item da linha (por exemplo, 1).             |
| price           | INT           | O preço por unidade do produto para o item da linha (por exemplo, 25).                        |
