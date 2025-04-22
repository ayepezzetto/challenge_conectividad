# Dashboard de Internet en Argentina
Tablero: (https://public.tableau.com/views/InternetenArgentina_17450770735180/Usuariossuscripciones?:language=es-ES&:sid=&:redirect=auth&:display_count=n&:origin=viz_share_link)

## Descripción del Proyecto:
Este **Dashboard** proporciona una visualización del **uso de Internet** y la **suscripción a banda ancha** en **Argentina** a lo largo del tiempo (desde 2006 hasta 2024). Los gráficos muestran la **evolución del acceso a Internet** por provincia y las tecnologías utilizadas (ADSL, Cablemodem, Fibra Óptica), así como las **mejoras en la velocidad de Internet** por provincia en los últimos años.

## Fuentes de Datos:
- **World Bank**: Para las métricas de **acceso a Internet** y **penetración** de banda ancha.
(https://data.worldbank.org/indicator/IT.NET.USER.ZS?locations=AR) 
(https://data.worldbank.org/indicator/IT.NET.BBND.P2?locations=AR)
- **Enacom (Ente Nacional de Comunicaciones)**: Para los datos sobre las **tecnologías** y **velocidades promedio** de acceso a Internet en las diferentes provincias.
(https://indicadores.enacom.gob.ar/datos-abiertos-servicios)


## Tecnologías Usadas:
- **Tableau**: Herramienta principal utilizada para la creación de las visualizaciones interactivas y el dashboard.
- **Python**: Para limpiar y procesar los datos antes de cargarlos en Tableau.

## Instrucciones de Uso:
1. **Interactividad**:
   - Utiliza los filtros para seleccionar diferentes **provincias** y **años**.
   - Los gráficos mostrarán información específica para las selecciones hechas.

2. **Filtros**:
   - El filtro de **Tecnología** permite seleccionar entre **ADSL**, **Cablemodem** y **Fibra Óptica**, mostrando cómo han evolucionado estas tecnologías en diferentes años.
   - El filtro de **Año** permite visualizar los datos de un rango de tiempo específico, desde 2006 hasta 2024.

3. **Visualizaciones**:
   - Gráfico de barras: Muestra el **porcentaje de usuarios con acceso a Internet** por provincia.
   - Gráfico de líneas: Compara la **evolución de suscripciones a banda ancha** y el **uso de Internet** a lo largo del tiempo.
   - Mapa: Proporciona la distribución geográfica de los **Promedio de acceso** y **velocidades promedio** de Internet.

## Conclusiones:
- **Crecimiento del acceso a Internet**: El gráfico de barras muestra un **aumento significativo** en el acceso a Internet en Argentina, con un **crecimiento más pronunciado** a partir de 2016.
- **Tecnologías predominantes**: La **fibra óptica** ha mostrado un crecimiento acelerado desde 2020, superando a tecnologías más antiguas como **ADSL** y **Cablemodem**.
- **Desigualdad provincial**: Aunque hay un avance general, algunas provincias siguen teniendo una infraestructura de **baja velocidad** comparado con otras, lo que refleja disparidades en el acceso a Internet de alta calidad.

## Requerimientos:
- **Tableau Public**: Necesario para interactuar con las visualizaciones.
- **Datos de Enacom y World Bank**: Si se desea reproducir el análisis o personalizarlo, se disponibiliza las bases de datos mencionadas, almacenadas luego de su preprocesamiento con Armando_base,ipynb, en la carpeta **Bases**.

## Licencia:
Este proyecto está **disponible bajo la licencia MIT**. Puedes usar, modificar y distribuir el código y las visualizaciones con los debidos créditos.

