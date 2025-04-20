# Challenge Engineer -  SQL

Este proyecto consiste en la creación de un esquema de base de datos para un sistema de compras online. El modelo de datos cubre las tablas principales para gestionar **clientes**, **productos**, **categorías** y **órdenes** de compra, siguiendo un flujo de compra simulado similar al de plataformas de comercio electrónico como Mercado Libre.

##  Archivos incluidos

| Archivo                        | Descripción |
|--------------------------------|-------------|
| `DER_Flujo_de_compras.jpg`     | Imagen con el diagrama entidad-relación (DER) completo. |
| `create_tables.sql`            | Script DDL para la creación de tablas, claves foráneas, índices y triggers. |
| `respuesta_negocio.sql`        | Consultas SQL para responder a las consignas del challenge. |


## Tablas del Modelo

### 1. **`customer`** (Dimensión de Cliente)
La tabla **`customer`** almacena la información de los clientes del sistema, incluyendo datos como:
- **`cus_id`**: Identificador único del cliente (clave primaria).
- **`cus_email`**: Correo electrónico del cliente.
- **`cus_nombre`**: Nombre del cliente.
- **`cus_apellido`**: Apellido del cliente.
- **`cus_genero`**: Género del cliente.
- **`cus_direccion`**: Dirección del cliente.
- **`cus_fecha_nac`**: Fecha de nacimiento del cliente.
- **`cus_telefono`**: Número telefónico del cliente.
- **`cus_fecha_alta`**: Fecha de alta en el sistema.
- **`cus_fecha_ult_mod`**: Fecha de la última modificación de los datos.
- **`cus_fecha_baja`**: Fecha de baja del cliente, si aplica.
- **`cus_status`**: Estado del cliente (`ACTIVO`, `INACTIVO`).

**Relaciones**:
- **`cus_id`** es la clave primaria y se utiliza en la tabla **`orders`** como clave foránea (**`or_cus_id`**).

---

### 2. **`item`** (Dimensión de Producto)
La tabla **`item`** almacena información sobre los productos disponibles para la venta:
- **`it_id`**: Identificador único del producto (clave primaria).
- **`it_cus_id`**: Identificador del vendedor (clave foránea que hace referencia a **`customer.cus_id`**).
- **`it_cat_id`**: Identificador de la categoría del producto (clave foránea que hace referencia a **`category.cat_id`**).
- **`it_descripcion`**: Descripción del producto.
- **`it_precio`**: Precio del producto.
- **`it_estado`**: Estado del producto (por ejemplo, `disponible`, `agotado`).
- **`it_estado_fecha_baja`**: Fecha en que el producto fue dado de baja.
- **`it_fecha_alta`**: Fecha de alta del producto en el sistema.
- **`it_fecha_ult_mod`**: Fecha de la última modificación del producto.
- **`it_fecha_baja`**: Fecha de baja del producto, si aplica.

**Relaciones**:
- **`it_cus_id`** se relaciona con **`customer.cus_id`**.
- **`it_cat_id`** se relaciona con **`category.cat_id`**.

---

### 3. **`category`** (Dimensión de Categoría)
La tabla **`category`** almacena información sobre las categorías de los productos:
- **`cat_id`**: Identificador único de la categoría (clave primaria).
- **`cat_descripcion`**: Descripción de la categoría.
- **`cat_path`**: Ruta de la categoría (por ejemplo, `Tecnología > Celulares y Teléfonos > Celulares`).
- **`cat_fecha_alta`**: Fecha de alta de la categoría.
- **`cat_fecha_ult_mod`**: Fecha de la última modificación de la categoría.
- **`cat_fecha_baja`**: Fecha en que la categoría fue dada de baja, si aplica.

**Relaciones**:
- **`cat_id`** se relaciona con **`item.it_cat_id`**.

---

### 4. **`orders`** (Tabla de Hechos)
La tabla **`orders`** almacena las transacciones de compra:
- **`or_id`**: Identificador único de la orden (clave primaria).
- **`or_it_id`**: Identificador del producto comprado (clave foránea que hace referencia a **`item.it_id`**).
- **`or_cus_id`**: Identificador del cliente comprador (clave foránea que hace referencia a **`customer.cus_id`**).
- **`or_fecha_transac`**: Fecha de la transacción de compra.
- **`or_it_precio`**: Precio del producto en el momento de la compra.
- **`or_estado`**: Estado de la orden (por ejemplo, `pendiente`, `completada`).
- **`or_fecha_alta`**: Fecha de alta de la orden.
- **`or_fecha_ult_mod`**: Fecha de la última modificación de la orden.
- **`or_fecha_baja`**: Fecha de baja de la orden, si aplica.
- **`or_cantidad`**: Cantidad de unidades del producto comprado en esa orden.

**Relaciones**:
- **`or_it_id`** se relaciona con **`item.it_id`**.
- **`or_cus_id`** se relaciona con **`customer.cus_id`**.

---

## Lógica de Compra

El flujo de compra en el sistema es el siguiente:
1. El cliente ingresa al sitio y busca un producto en una categoría específica (por ejemplo, `Tecnología > Celulares y Teléfonos > Celulares`).
2. Al seleccionar el producto, el cliente puede comprar varias unidades. El campo **`or_cantidad`** en la tabla **`orders`** refleja cuántas unidades del producto ha comprado el cliente.
3. La **orden** se genera insertando un registro en la tabla **`orders`** con el producto seleccionado, el precio, el cliente comprador, y la cantidad de unidades.

---

## Triggers

Se han definido varios **triggers** para gestionar las fechas automáticamente:
- **Fecha de alta**: Cuando un registro es insertado, si la fecha de alta no es proporcionada, se asigna la fecha y hora actuales.
- **Última modificación**: Cuando un registro es actualizado, se asigna la fecha y hora actuales a la **`fecha_ult_mod`**.
- **Estado de cliente**: Si se proporciona una **`cus_fecha_baja`** en la tabla **`customer`**, el **`cus_status`** se actualizará a **'INACTIVO'**.

---

## Secuencias

Se han definido las siguientes **secuencias** para asegurar la generación de identificadores únicos:
- **`seq_ith_id`**: Para generar los identificadores de los productos en el historial de cambios (**`item_hist`**).
- **`seq_mov_id`**: Para generar identificadores en los movimientos diarios (**`mov_diarios`**).

---

## Instrucciones de Uso

Para configurar y ejecutar este esquema en tu base de datos Oracle:

1. Crea todas las tablas y sus relaciones ejecutando los comandos SQL.
2. Asegúrate de crear las secuencias correspondientes para los identificadores.
3. Ejecuta los scripts de los triggers para manejar las fechas de alta, modificación y baja automáticamente.
4. Usa la tabla **`orders`** para registrar las compras realizadas por los clientes, reflejando la cantidad de productos comprados.

---

## Diagramas

El modelo de datos está representado visualmente en el diagrama de **Entidad-Relación (ER)** disponible en el proyecto.
https://drive.google.com/file/d/1yXtjO9quDROfhtWXEaYvyewIvKRkALDY/view?usp=sharing

---

## Licencia

Este proyecto está bajo la **Licencia MIT**.

