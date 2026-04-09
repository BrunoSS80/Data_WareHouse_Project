# 📊 Projeto de Data Warehouse

Bem-vindo ao repositório do **Data WareHouse Project**!  
Este projeto demonstra uma solução completa de dados, desde a construção de um Data Warehouse até a geração de insights.

Desenvolvido como projeto de portfólio, ele destaca boas práticas utilizadas na área de **Engenharia de Dados**.

---

## 🏗️ Arquitetura de Dados

A arquitetura deste projeto segue o modelo **Medallion Architecture**, dividido em três camadas:

- 🥉 **Bronze (Bruta)**  
  Armazena os dados brutos exatamente como vêm das fontes (arquivos CSV).

- 🥈 **Silver (Tratada)**  
  Responsável pela limpeza, padronização e transformação dos dados.

- 🥇 **Gold (Analítica)**  
  Contém dados prontos para análise, organizados em modelo dimensional (Star Schema).

---

## 📖 Visão Geral do Projeto

Este projeto contempla:

- 📌 **Arquitetura de Dados**  
  Construção de um Data Warehouse moderno com camadas Bronze, Silver e Gold.

- 🔄 **Pipelines ETL**  
  Extração, transformação e carga de dados a partir de múltiplas fontes.

- 🧩 **Modelagem de Dados**  
  Criação de tabelas fato e dimensão otimizadas para análise.

---

## 🛠️ Ferramentas Utilizadas

- SQLite3 
- Python  
- GitHub  
---

## ▶️ Como Executar o Projeto

Siga os passos abaixo para rodar o projeto em sua máquina:

### 📥 1. Clonar o repositório

Abra o terminal e execute:

```bash
git clone https://github.com/seu-usuario/data-warehouse-project.git
cd data-warehouse-project
```

---

### 🧰 2. Instalar extensão SQLite (VS Code)

Este projeto pode ser executado utilizando SQLite. Para isso:

1. Abra o VS Code  
2. Vá até a aba de extensões  
3. Procure por **SQLite**  
4. Instale uma extensão (ex: SQLite Viewer ou SQLite)

---

### 🗄️ 3. Criar/abrir o banco de dados

- Abra o banco `datawarehouse.db` utilizando a extensão instalada no VS Code

---

### ⚙️ 4. Executar os scripts

Execute os scripts na seguinte ordem:

1. **Bronze** → carga dos dados brutos  
   ```
   scripts/bronze/
   ```

2. **Silver** → limpeza e transformação  
   ```
   scripts/silver/
   ```

3. **Gold** → modelagem analítica  
   ```
   scripts/gold/
   ```

---

### 🧪 5. Rodar os testes

Após executar os scripts, rode os arquivos da pasta:

```
tests/
```

Esses testes garantem que:
- Os dados foram carregados corretamente  
- As transformações foram aplicadas  
- O modelo final está consistente  

---

## 🚀 Requisitos do Projeto

### 🏗️ Construção do Data Warehouse

#### 🎯 Objetivo
Desenvolver um Data Warehouse utilizando SQLite3 para consolidar dados de vendas e permitir análises estratégicas.

#### 📌 Especificações

- **Fontes de Dados**:  
  Dados provenientes de dois sistemas:
  - ERP  
  - CRM  
  (arquivos CSV)

- **Qualidade dos Dados**:  
  Limpeza e tratamento de inconsistências antes da análise.

- **Integração**:  
  Unificação dos dados em um modelo único e amigável para análise.

- **Escopo**:  
  Considerar apenas os dados mais recentes (sem histórico).

- **Documentação**:  
  Explicação clara do modelo de dados para usuários técnicos e de negócio.

---

## 🧑‍💻 Autor

Desenvolvido por **Bruno Severgnini da Silva**

📌 Conecte-se comigo:
- LinkedIn: https://www.linkedin.com/in/bruno-severgnini-9049b8258/  
- GitHub: https://github.com/BrunoSS80  
