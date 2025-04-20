import requests
import csv
from datetime import datetime
import os
import sqlite3

# URL de la API pública
API_URL = "https://economia.awesomeapi.com.br/last/USD-BRL,EUR-BRL,BTC-BRL,BRL-ARS"

# Función para obtener los datos de la API
def obtener_datos_api():
    response = requests.get(API_URL)
    if response.status_code == 200:
        return response.json()
    else:
        print("Error al obtener los datos de la API.")
        return None

# Función para normalizar los datos
def normalizar_datos(datos):
    normalizados = []
    for clave, valor in datos.items():
        moneda_base = valor['code']
        moneda_destino = valor['codein']
        valor_compra = valor['bid']
        valor_venta = valor['ask']
        fecha_hora = datetime.utcnow().strftime('%Y-%m-%d %H:%M:%S')
        normalizados.append([moneda_base, moneda_destino, valor_compra, valor_venta, fecha_hora])
    return normalizados

# Función para guardar los datos en formato CSV
def guardar_csv(datos_normalizados, nombre_archivo='datos_monedas.csv'):
    # Verificar si la carpeta 'output_csv' existe, si no la crea
    if not os.path.exists('output_csv'):
        os.makedirs('output_csv')

    # Guardar el archivo CSV dentro de la carpeta 'output_csv'
    ruta_archivo = os.path.join('output_csv', nombre_archivo)
    
    with open(ruta_archivo, mode='w', newline='', encoding='utf-8') as archivo:
        writer = csv.writer(archivo)
        writer.writerow(['moneda_base', 'moneda_destino', 'valor_compra', 'valor_venta', 'fecha_hora'])
        writer.writerows(datos_normalizados)

# Función para guardar los datos en SQLite
def guardar_en_base_de_datos(datos_normalizados):
    conexion = sqlite3.connect('datos_monedas.db')
    cursor = conexion.cursor()
    
    # Crear tabla si no existe
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS monedas (
            moneda_base TEXT,
            moneda_destino TEXT,
            valor_compra REAL,
            valor_venta REAL,
            fecha_hora TEXT
        )
    ''')

    # Insertar los datos
    cursor.executemany('''
        INSERT INTO monedas (moneda_base, moneda_destino, valor_compra, valor_venta, fecha_hora)
        VALUES (?, ?, ?, ?, ?)
    ''', datos_normalizados)

    conexion.commit()
    conexion.close()

# Función principal
def main():
    datos_api = obtener_datos_api()
    if datos_api:
        datos_normalizados = normalizar_datos(datos_api)
        
        # Guardar en CSV
        guardar_csv(datos_normalizados)
        print("Datos guardados en output_csv/datos_monedas.csv.")
        
        # Guardar en SQLite
        guardar_en_base_de_datos(datos_normalizados)
        print("Datos guardados en la base de datos SQLite.")

if __name__ == "__main__":
    main()
