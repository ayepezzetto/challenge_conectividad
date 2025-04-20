-- Creacion de esquema - MeLi

-- 1- Creo todas las tablas con PK e indices 

--------------------------------------------
-- CUSTOMER (Dimensión de Cliente)

CREATE TABLE customer (
  cus_id number NOT NULL PRIMARY KEY, -- PK
  cus_email varchar2(50) NOT NULL,
  cus_nombre varchar2(50),
  cus_apellido varchar2(50),
  cus_genero varchar2(1),
  cus_direccion varchar2(100),
  cus_fecha_nac Date,
  cus_telefono number,
  cus_fecha_alta Date,
  cus_fecha_ult_mod Date,
  cus_fecha_baja Date, -- Fecha de baja
  cus_status varchar2(10) DEFAULT 'ACTIVO' -- Campo para identificar estado del cliente
);

-- Indices
CREATE INDEX idx_cus_email ON customer (cus_email);

--------------------------------------------
-- ITEM (Dimensión de Producto)

CREATE TABLE Item (
  it_id number NOT NULL PRIMARY KEY, -- PK
  it_cus_id number NOT NULL, -- FK (referencia a Customer)
  it_cat_id number NOT NULL, -- FK (referencia a Category)
  it_descripcion Clob,
  it_precio number(8,2),
  it_estado varchar2(25),
  it_estado_fecha_baja Date,
  it_fecha_alta Date,
  it_fecha_ult_mod Date,
  it_fecha_baja Date
);

-- Indices
CREATE INDEX idx_it_cus_id ON Item (it_cus_id);
CREATE INDEX idx_it_cat_id ON Item (it_cat_id);

--------------------------------------------
-- CATEGORY (Dimensión de Categoría)

CREATE TABLE CATEGORY (
  cat_id number NOT NULL PRIMARY KEY, -- PK
  cat_descripcion varchar2(100),
  cat_path varchar2(100),
  cat_fecha_alta Date,
  cat_fecha_ult_mod Date,
  cat_fecha_baja Date
);

-- Indices
CREATE INDEX idx_cat_path ON CATEGORY (cat_path);

--------------------------------------------
-- ORDER (Tabla de Hechos) 
CREATE TABLE orders (
  or_id number NOT NULL PRIMARY KEY, -- PK
  or_it_id number NOT NULL, -- FK (referencia a Item)
  or_cus_id number NOT NULL, -- FK (referencia a Customer)
  or_fecha_transac Date,
  or_it_precio number(8,2),
  or_estado varchar2(25),
  or_fecha_alta Date,
  or_fecha_ult_mod Date,
  or_fecha_baja Date,
  or_cantidad number DEFAULT 1 -- Campo para reflejar la cantidad de productos comprados
);

-- Indices
CREATE INDEX idx_or_it_id ON orders (or_it_id); 
CREATE INDEX idx_or_cus_id ON orders (or_cus_id);

--------------------------------------------
-- 2- Agrego FK referenciales en tablas

-- Item
ALTER TABLE Item ADD CONSTRAINT fk_it_cus FOREIGN KEY (it_cus_id) REFERENCES customer (cus_id);
ALTER TABLE Item ADD CONSTRAINT fk_it_cat FOREIGN KEY (it_cat_id) REFERENCES CATEGORY (cat_id);

-- Orders
ALTER TABLE orders ADD CONSTRAINT fk_or_it FOREIGN KEY (or_it_id) REFERENCES Item (it_id);
ALTER TABLE orders ADD CONSTRAINT fk_or_cus FOREIGN KEY (or_cus_id) REFERENCES customer (cus_id);

--------------------------------------------
-- 3- Creo Triggers Fecha Alta, Ult Mod y Fecha de Baja en Customer

-- Customer
CREATE OR REPLACE TRIGGER tgg_audit_cus
   BEFORE INSERT OR UPDATE ON customer FOR EACH ROW
DECLARE
   V_FECHA  DATE := sysdate;
BEGIN
   IF INSERTING THEN
      IF :NEW.cus_fecha_alta IS NULL THEN
         :NEW.cus_fecha_alta := V_FECHA;
      END IF;
   ELSIF UPDATING THEN
      IF :NEW.cus_fecha_ult_mod IS NULL THEN
         :NEW.cus_fecha_ult_mod := V_FECHA;
      END IF;
      
      -- Si la fecha de baja es proporcionada, actualizar el estado a 'INACTIVO'
      IF :NEW.cus_fecha_baja IS NOT NULL AND :NEW.cus_status IS NULL THEN
         :NEW.cus_status := 'INACTIVO';
      END IF;
   END IF;
END;

-- Item
CREATE OR REPLACE TRIGGER tgg_audit_it
   BEFORE INSERT OR UPDATE ON Item FOR EACH ROW
DECLARE
   V_FECHA  DATE := sysdate;
BEGIN
   IF INSERTING THEN
      IF :NEW.it_fecha_alta IS NULL THEN
         :NEW.it_fecha_alta := V_FECHA;
      END IF;
   ELSIF UPDATING THEN
      IF :NEW.it_fecha_ult_mod IS NULL THEN
         :NEW.it_fecha_ult_mod := V_FECHA;
      END IF;
   END IF;
END;

-- Category
CREATE OR REPLACE TRIGGER tgg_audit_cat
   BEFORE INSERT OR UPDATE ON CATEGORY FOR EACH ROW
DECLARE
   V_FECHA  DATE := sysdate;
BEGIN
   IF INSERTING THEN
      IF :NEW.cat_fecha_alta IS NULL THEN
         :NEW.cat_fecha_alta := V_FECHA;
      END IF;
   ELSIF UPDATING THEN
      IF :NEW.cat_fecha_ult_mod IS NULL THEN
         :NEW.cat_fecha_ult_mod := V_FECHA;
      END IF;
   END IF;
END;

-- Order
CREATE OR REPLACE TRIGGER tgg_audit_or
   BEFORE INSERT OR UPDATE ON orders FOR EACH ROW
DECLARE
   V_FECHA  DATE := sysdate;
BEGIN
   IF INSERTING THEN
      IF :NEW.or_fecha_alta IS NULL THEN
         :NEW.or_fecha_alta := V_FECHA;
      END IF;
   ELSIF UPDATING THEN
      IF :NEW.or_fecha_ult_mod IS NULL THEN
         :NEW.or_fecha_ult_mod := V_FECHA;
      END IF;
   END IF;
END;

--------------------------------------------
-- 4- Creo Seq para ID en ITEMS_HIST y MOV_DIARIOS

CREATE SEQUENCE seq_ith_id
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  INCREMENT BY 1
  NOCYCLE
  CACHE 20
  NOORDER;

CREATE SEQUENCE seq_mov_id
  START WITH 1
  MAXVALUE 9999999999999999999999999999
  MINVALUE 1
  INCREMENT BY 1
  NOCYCLE
  CACHE 20
  NOORDER;

--------------------------------------------
-- 5- Trigger en ITEMS que carga ITEMS_HIST - Automáticamente con cada insert o update en Items

CREATE OR REPLACE TRIGGER tgg_it_ith
   BEFORE INSERT OR UPDATE ON Item FOR EACH ROW
DECLARE
   v_ith_id number := seq_ith_id.NEXTVAL;
BEGIN
    INSERT INTO 
            item_hist (ith_id,
                       ith_it_id,
                       ith_precio,
                       ith_estado,
                       ith_novedad)
    VALUES (v_ith_id, -- Id con secuencia
            :NEW.it_id, -- Id de item
            :NEW.it_precio, -- Precio actualizado
            :NEW.it_estado, -- Estado actualizado
            NULL -- Novedad Nula
            );
END;

--------------------------------------------

-- Bajar todo el esquema
/* 
drop table customer CASCADE CONSTRAINTS purge;
drop table item CASCADE CONSTRAINTS purge;
drop table category CASCADE CONSTRAINTS purge;
drop table orders CASCADE CONSTRAINTS purge;
drop table item_hist CASCADE CONSTRAINTS purge;
drop table mov_diarios CASCADE CONSTRAINTS purge;

DROP SEQUENCE seq_ith_id;
DROP SEQUENCE seq_mov_id;
*/

