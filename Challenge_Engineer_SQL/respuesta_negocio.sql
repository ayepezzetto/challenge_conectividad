/*1.Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas 
realizadas en enero 2020 sea superior a 1500.
Solución: Para este problema, necesitamos combinar las tablas customer y orders para filtrar a los 
clientes cuyo cumpleaños sea hoy, y cuyas ventas en enero de 2020 superen los 1500.*/

SELECT 
    c.cus_id, 
    c.cus_nombre, 
    c.cus_apellido,
    c.cus_email 
    COUNT(o.or_id) AS cantidad_ventas
FROM customer c
JOIN orders o ON c.cus_id = o.or_cus_id
WHERE EXTRACT(MONTH FROM c.cus_fecha_nac) = EXTRACT(MONTH FROM SYSDATE) -- Mes actual
AND EXTRACT(DAY FROM c.cus_fecha_nac) = EXTRACT(DAY FROM SYSDATE) -- Día actual
AND o.or_fecha_transac BETWEEN TO_DATE('2020-01-01', 'YYYY-MM-DD') 
                            AND TO_DATE('2020-01-31', 'YYYY-MM-DD') -- Enero 2020
GROUP BY c.cus_id, c.cus_nombre, c.cus_apellido,c.cus_email
HAVING COUNT(o.or_id) > 1500;

/*2. Top 5 usuarios que más vendieron en la categoría "Celulares" por mes en 2020.*/

SELECT 
    EXTRACT(MONTH FROM o.or_fecha_transac) AS mes,
    EXTRACT(YEAR FROM o.or_fecha_transac) AS anio,
    c.cus_nombre,
    c.cus_apellido,
    COUNT(o.or_id) AS cantidad_ventas,
    SUM(o.or_it_precio * o.or_cantidad) AS monto_total
FROM orders o
JOIN item i ON o.or_it_id = i.it_id
JOIN customer c ON o.or_cus_id = c.cus_id
WHERE i.it_cat_id = (SELECT cat_id FROM category WHERE cat_descripcion = 'Celulares') 
AND o.or_fecha_transac BETWEEN TO_DATE('2020-01-01', 'YYYY-MM-DD') 
                            AND TO_DATE('2020-12-31', 'YYYY-MM-DD') -- Todo el año 2020
GROUP BY EXTRACT(MONTH FROM o.or_fecha_transac), EXTRACT(YEAR FROM o.or_fecha_transac), c.cus_id, c.cus_nombre, c.cus_apellido
ORDER BY mes, anio, monto_total DESC
FETCH FIRST 5 ROWS ONLY;

/*Poblar una nueva tabla con el precio y estado de los ítems a fin del día.*/

-- Creación de la nueva tabla
CREATE TABLE item_status_end_of_day (
  ithd_id number NOT NULL PRIMARY KEY,
  ithd_it_id number NOT NULL,  -- FK que referencia al ítem
  ithd_precio number(8,2),
  ithd_estado varchar2(25),
  ithd_fecha_registro Date DEFAULT SYSDATE  -- Fecha y hora de registro
);

-- Procedimiento para poblar la tabla al final del día
CREATE OR REPLACE PROCEDURE populate_item_status_end_of_day AS
BEGIN
  -- Insertar los últimos estados y precios de los ítems
  INSERT INTO item_status_end_of_day (ithd_id, ithd_it_id, ithd_precio, ithd_estado)
  SELECT 
    item_status_seq.NEXTVAL,  -- Secuencia para ID incremental
    i.it_id, 
    i.it_precio, 
    i.it_estado
  FROM 
    item i
  WHERE 
    NOT EXISTS (
      SELECT 1 
      FROM item_status_end_of_day ithd 
      WHERE ithd.ithd_it_id = i.it_id
      AND ithd.ithd_fecha_registro = TRUNC(SYSDATE)  -- Verifica si ya se ha registrado ese ítem hoy
    );
    
  COMMIT;
END;
