import sqlite3
import csv
import os
import sys
import time

"""
    ==================================================
        ADICIONANDO REGISTROS DE SOURCE -> BRONZE
    ==================================================

        Este script extrai informações dos arquivos CSV armazenados nos datasets 
    enviando para as tabelas da camada bronze.
        O script lê o CSV, tranforma todos os registros separados por virgula em  
    arrays com os dados, armazena nas respectivas tabelas informadas na chamada 
    da função. 
"""

def importar_csv_para_tabela(caminho_csv, caminho_db, nome_tabela):
    inicio = time.time()
    # Verifica se o arquivo CSV existe
    if not os.path.isfile(caminho_csv):
        print(f"Erro: Arquivo CSV '{caminho_csv}' não encontrado.")
        return

    try:
        # Conecta ao banco SQLite
        conn = sqlite3.connect(caminho_db)
        cursor = conn.cursor()

        # Truncate tabela
        cursor.execute(f"""
            DELETE FROM {nome_tabela}
        """)
        print("Deletando registros.")
        print("---------------------")

        # Lê o CSV
        with open(caminho_csv, newline='', encoding='utf-8') as csvfile:
            leitor = csv.reader(csvfile)
            colunas = next(leitor)  # Cabeçalho do CSV

            # Monta a query de inserção
            placeholders = ", ".join(["?"] * len(colunas))
            colunas_sql = ", ".join([f'"{col}"' for col in colunas])
            sql_insert = f'INSERT INTO "{nome_tabela}" ({colunas_sql}) VALUES ({placeholders})'

            # Insere todos os registros de uma vez
            cursor.executemany(sql_insert, leitor)
         
        conn.commit()
        print(f"Foram inseridos {cursor.rowcount} registros na tabela '{nome_tabela}'.")
        print("---------------------")
    
    except sqlite3.Error as e:
        print(f"Erro no banco de dados: {e}")
    except csv.Error as e:
        print(f"Erro ao ler o CSV: {e}")
    finally:
        conn.close()
        fim = time.time()
        duração = fim-inicio
        print(f"Levaram {duração:.2f} segundos para implementar todos registros.")
        print("---------------------")

# Uso via terminal
if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Uso via terminal: python importar_csv_existente.py <arquivo.csv> <banco.db> <nome_tabela>")
        print("--------------------")
    else:
        importar_csv_para_tabela(sys.argv[1], sys.argv[2], sys.argv[3])

cam_db = 'datasets/WareHouse.db'

importar_csv_para_tabela('datasets/source_crm/cust_info.csv', cam_db, 'bronze_crm_cust_info')
importar_csv_para_tabela('datasets/source_crm/prd_info.csv', cam_db, 'bronze_crm_prd_info')
importar_csv_para_tabela('datasets/source_crm/sales_details.csv', cam_db, 'bronze_crm_sales_details')
importar_csv_para_tabela('datasets/source_erp/CUST_AZ12.csv', cam_db, 'bronze_erp_cust_az12')
importar_csv_para_tabela('datasets/source_erp/LOC_A101.csv', cam_db, 'bronze_erp_loc_a101')
importar_csv_para_tabela('datasets/source_erp/PX_CAT_G1V2.csv', cam_db, 'bronze_erp_px_cat_g1v2')