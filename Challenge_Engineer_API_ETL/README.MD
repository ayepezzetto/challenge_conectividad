# Desafío Técnico: Obtención y Almacenamiento de Cotizaciones de Monedas

## Objetivo
Desarrollar una aplicación que consuma los datos financieros de una API pública, realice la normalización de la información y almacene los datos para consultas futuras.

## Descripción del Proyecto
Este proyecto obtiene las cotizaciones de monedas extranjeras (USD/BRL, EUR/BRL, BTC/BRL) desde la API pública [AwesomeAPI](https://docs.awesomeapi.com.br/api-de-moedas), las normaliza y las almacena en un archivo `.csv` y en una base de datos SQLite.

## Requisitos
- Python 3.x
- Bibliotecas de Python:
  - `requests`
  - `csv`
  - `sqlite3`
  - `datetime`

## Cómo Ejecutar el Script

1. Clona este repositorio o descarga el script `extraccion_monedas.py`.
2. Asegúrate de tener Python 3 instalado.
3. Instala las dependencias necesarias:
   ```bash
   pip install -r requirements.txt

## Estructura del proyecto

```
Challenge_Engineer_API_ETL/
├── extraccion_monedas.py  # Lógica de extracción, normalización y guardado
├── requirements.txt       # Dependencias del proyecto
├── output/                # Carpeta donde se guardan los archivos generados
│   └── datos_monedas.csv  # Datos normalizados en formato CSV
└── README.md              # Documentación

