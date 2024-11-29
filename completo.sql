CREATE SEQUENCE proyecto.seq_categorias
    START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_impuestos
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_productos
	START WITH 1000
	INCREMENT BY 3;

CREATE SEQUENCE proyecto.factura_ids
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.id_detalles_facturas
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.id_metodos_pago
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_clientes
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_inventarios
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_informes
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_auditorias
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_xml
	START WITH 1
	INCREMENT BY 1;

CREATE TYPE proyecto.tipos_movimiento AS ENUM ('ENTRADA','SALIDA'); 

CREATE TYPE proyecto.estado_factura AS ENUM ('PAGADA', 'PENDIENTE', 'EN PROCESO');

CREATE TYPE proyecto.identificador_metodo_pago AS ENUM ('EFECTIVO', 'TC', 'TD');


CREATE TABLE proyecto.categorias (
	id serial NOT NULL,
	descripcion varchar NULL,
	CONSTRAINT categorias_pk PRIMARY KEY (id)
);

CREATE TABLE proyecto.impuestos (
	id serial NOT NULL,
	nombre varchar NULL,
	porcentaje float4 NULL,
	CONSTRAINT impuestos_pk PRIMARY KEY (id)
);

CREATE TABLE proyecto.productos (
	id serial NOT NULL,
	codigo varchar NOT NULL,
	nombre varchar NOT NULL,
	descripcion varchar NULL,
	precio_venta float4 NOT NULL,
	medida varchar NULL,
	impuesto_id integer NULL,
	categoria_id integer NULL,
	stock integer NOT NULL DEFAULT 0,
	CONSTRAINT productos_pk PRIMARY KEY (id),
	CONSTRAINT productos_unique UNIQUE (codigo),
	CONSTRAINT productos_categorias_fk FOREIGN KEY (categoria_id) REFERENCES proyecto.categorias(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT productos_impuestos_fk FOREIGN KEY (impuesto_id) REFERENCES proyecto.impuestos(id) ON DELETE CASCADE ON UPDATE CASCADE
);


CREATE TABLE proyecto.clientes(
	id serial NOT NULL PRIMARY KEY,
	numero_documento varchar(11) NOT NULL,
	nombre varchar(30) NOT NULL,
	direccion varchar(80) NOT NULL,
	telefono varchar(20) NOT NULL,
	email varchar(40) NOT NULL,
	ciudad varchar(40) NOT NULL,
	departamento varchar(40) NOT NULL
);

CREATE TABLE proyecto.inventarios(
	id serial NOT NULL PRIMARY KEY,
	fecha date NOT NULL,
	tipo_movimiento proyecto.tipos_movimiento NOT NULL,
	observaciones varchar(80) NULL,
	id_producto integer NOT NULL,
	FOREIGN KEY (id_producto) REFERENCES proyecto.productos(id) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proyecto.informes(
	id serial NOT NULL PRIMARY KEY,
	tipo_informe varchar(40) NOT NULL,
	fecha date NOT NULL,
	datos_json jsonb NOT NULL 
);

CREATE TABLE proyecto.auditorias(
	id serial NOT NULL PRIMARY KEY,
	fecha date NOT NULL,
	nombre_cliente varchar(30) NOT NULL,
	cantidad int NOT NULL,
	nombre_producto varchar(20) NOT NULL,
	total numeric NOT NULL
);


CREATE TABLE proyecto.metodos_pago (
	id serial NOT NULL,
	descripcion varchar NULL,
	identificador proyecto.identificador_metodo_pago  NULL,
	CONSTRAINT metodos_pago_pk PRIMARY KEY (id)
);

CREATE TABLE proyecto.facturas (
	id serial NOT NULL,
	codigo varchar NOT NULL,
	fecha date NULL,
	subtotal double precision NULL,
	total_impuestos double precision NULL,
	total double precision NULL,
	estadoF proyecto.estado_factura NULL,
	id_cliente serial NOT NULL,
	id_metodo_pago serial NOT NULL,
	CONSTRAINT facturas_pk PRIMARY KEY (id),	
	CONSTRAINT facturas_metodos_pago_fk FOREIGN KEY (id_metodo_pago) REFERENCES proyecto.metodos_pago(id)  ON DELETE CASCADE ON UPDATE CASCADE,	
	CONSTRAINT facturas_clientes_fk FOREIGN KEY (id_cliente) REFERENCES proyecto.clientes(id)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proyecto.detalles_facturas (
	id serial NOT NULL,
	cantidad int NULL,
	valor_total double precision NULL,
	descuento float4 NULL,
	producto_id serial NOT NULL,
	factura_id serial NOT NULL,
	CONSTRAINT detalles_facturas_pk PRIMARY KEY (id),
	CONSTRAINT detalles_facturas_productos_fk FOREIGN KEY (producto_id) REFERENCES proyecto.productos(id)  ON DELETE CASCADE ON UPDATE CASCADE,	
	CONSTRAINT detalles_facturas_facturas_fk FOREIGN KEY (factura_id) REFERENCES proyecto.facturas(id)  ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE proyecto.xml_facturas (
	id serial NOT NULL,
	factura_id serial NOT NULL,
	descripcion xml NOT NULL,
	CONSTRAINT xml_facturas_pk PRIMARY KEY (id),
	CONSTRAINT xml_facturas_facturas_fk FOREIGN KEY (factura_id) REFERENCES proyecto.facturas(id) ON DELETE CASCADE ON UPDATE CASCADE
);



-- Insertar datos de prueba
-- INSERT	INTO proyecto.categorias (id, descripcion) VALUES (nextval('seq_categorias'), 'Descripción prueba');
-- INSERT INTO proyecto.impuestos (id, nombre, porcentaje) VALUES (nextval('seq_impuestos'), 'IMPOCONSUMO', 0.1);
-- INSERT INTO proyecto.productos (id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock) VALUES (nextval('seq_productos'), '0001', 'Producto 1', 'Descripción producto', 7900, 'KILOGRAMOS', 1, 1, 10);
-- INSERT INTO proyecto.clientes (id, numero_documento, nombre, direccion, telefono, email, ciudad, departamento) VALUES (nextval('seq_clientes'), '1234567890', 'Juan Perez', 'Calle 123', '1234567', 'juan@gmail.com', 'Bogota', 'Cundinamarca');
-- INSERT INTO proyecto.metodos_pago (id, descripcion, identificador) VALUES (nextval('id_metodos_pago'), 'Efectivo', 'EFECTIVO');
-- INSERT INTO proyecto.facturas (id, codigo, fecha, subtotal, total_impuestos, total, estadoF, id_cliente, id_metodo_pago) VALUES (nextval('factura_ids'), '0001', '2021-10-01', 10000, 1000, 11000, 'PAGADA', 1, 1);
-- INSERT INTO proyecto.detalles_facturas (id, cantidad, valor_total, descuento, producto_id, factura_id) VALUES (nextval('id_detalles_facturas'), 2, 20000, 0, 1000, 1);
-- INSERT INTO proyecto.inventarios (id, fecha, tipo_movimiento, observaciones, id_producto) VALUES (nextval('seq_inventarios'), '2021-10-01', 'ENTRADA', 'Ingreso de productos', 1000);
-- INSERT INTO proyecto.informes (id, tipo_informe, fecha, datos_json) VALUES (nextval('seq_informes'), 'Informe 1', '2021-10-01', '{"dato1": "valor1"}');
-- INSERT INTO proyecto.auditorias (id, fecha, nombre_cliente, cantidad, nombre_producto, total) VALUES (nextval('seq_auditorias'), '2021-10-01', 'Juan Perez', 2, 'Producto 1', 20000);

-- Insertar nuevamente DATOS DIFERENTES
-- INSERT INTO proyecto.categorias (id, descripcion) VALUES (nextval('seq_categorias'), 'Descripción prueba 2');
-- INSERT INTO proyecto.impuestos (id, nombre, porcentaje) VALUES (nextval('seq_impuestos'), 'IMPOCONSUMO 2', 0.2);
-- INSERT INTO proyecto.productos (id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock) VALUES (nextval('seq_productos'), '0002', 'Producto 2', 'Descripción producto 2', 7900, 'KILOGRAMOS', 1, 1, 20);
-- INSERT INTO proyecto.clientes (id, numero_documento, nombre, direccion, telefono, email, ciudad, departamento) VALUES (nextval('seq_clientes'), '1234567891', 'Pedro Perez', 'Calle 124', '1234568', 'pedro@gmail.com', 'Bogota', 'Cundinamarca');
-- INSERT INTO proyecto.metodos_pago (id, descripcion, identificador) VALUES (nextval('id_metodos_pago'), 'Tarjeta de crédito', 'TC');
-- INSERT INTO proyecto.facturas (id, codigo, fecha, subtotal, total_impuestos, total, estadoF, id_cliente, id_metodo_pago) VALUES (nextval('factura_ids'), '0002', '2021-10-02', 20000, 2000, 22000, 'PENDIENTE', 4, 4);
-- INSERT INTO proyecto.detalles_facturas (id, cantidad, valor_total, descuento, producto_id, factura_id) VALUES (nextval('id_detalles_facturas'), 3, 30000, 0, 1000, 6);
-- INSERT INTO proyecto.inventarios (id, fecha, tipo_movimiento, observaciones, id_producto) VALUES (nextval('seq_inventarios'), '2021-10-02', 'SALIDA', 'Salida de productos', 1000);
-- INSERT INTO proyecto.informes (id, tipo_informe, fecha, datos_json) VALUES (nextval('seq_informes'), 'Informe 2', '2021-10-02', '{"dato2": "valor2"}');
-- INSERT INTO proyecto.auditorias (id, fecha, nombre_cliente, cantidad, nombre_producto, total) VALUES (nextval('seq_auditorias'), '2021-10-02', 'Pedro Perez', 3, 'Producto 2', 30000);


CREATE OR REPLACE PROCEDURE proyecto.crear_producto(p_codigo VARCHAR, p_nombre VARCHAR, p_descripcion VARCHAR, p_precio FLOAT, p_medida VARCHAR, p_impuesto_id INTEGER, p_categoria_id INTEGER, p_stock INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO proyecto.productos (id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock) VALUES (nextval('proyecto.seq_productos'), p_codigo, p_nombre, p_descripcion, p_precio, p_medida, p_impuesto_id, p_categoria_id, p_stock);
	
	IF p_precio < 0 THEN
		RAISE EXCEPTION 'El precio de venta no puede ser negativo';
	END IF;

	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El código % ya existe', p_codigo;
		WHEN foreign_key_violation THEN
			RAISE EXCEPTION 'La categoría o el impuesto no existen';
END;
$$;

CREATE OR REPLACE PROCEDURE proyecto.modificar_producto(p_id INTEGER, p_codigo VARCHAR, p_nombre VARCHAR, p_descripcion VARCHAR, p_precio FLOAT, p_medida VARCHAR, p_impuesto_id INTEGER, p_categoria_id INTEGER, p_stock INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
	IF p_precio < 0 THEN
		RAISE EXCEPTION 'El precio de venta no puede ser negativo';
	END IF;

	UPDATE proyecto.productos
	SET codigo = p_codigo,
		nombre = p_nombre,
		descripcion = p_descripcion,
		precio_venta = p_precio,
		medida = p_medida,
		impuesto_id = p_impuesto_id,
		categoria_id = p_categoria_id,
		stock = p_stock
	WHERE id = p_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'El producto con id % no existe', p_id;
	END IF;

	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El código % ya existe', p_codigo;
		WHEN foreign_key_violation THEN
			RAISE EXCEPTION 'La categoría o el impuesto no existen';
END;
$$;

CREATE OR REPLACE PROCEDURE proyecto.eliminar_producto(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM proyecto.productos WHERE id = p_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'El producto con id % no existe', p_id;
	END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE proyecto.crear_categoria(p_descripcion VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.categorias (id, descripcion) VALUES (nextval('proyecto.seq_categorias'), p_descripcion);

	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'La categoría % ya existe', p_descripcion;
END;
$$;

CREATE OR REPLACE PROCEDURE proyecto.modificar_categoria(p_id INTEGER, p_descripcion VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE proyecto.categorias
	SET descripcion = p_descripcion
	WHERE id = p_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'La categoría con id % no existe', p_id;
	END IF;

	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'La categoría % ya existe', p_descripcion;
END;
$$;


CREATE OR REPLACE PROCEDURE proyecto.eliminar_categoria(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM proyecto.categorias WHERE id = p_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'La categoría con id % no existe', p_id;
	END IF;
END;
$$;

CREATE OR REPLACE PROCEDURE proyecto.crear_impuesto(p_nombre VARCHAR, p_porcentaje FLOAT)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.impuestos (id, nombre, porcentaje) VALUES (nextval('proyecto.seq_impuestos'), p_nombre, p_porcentaje);

	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El impuesto % ya existe', p_nombre;
END;
$$;

CREATE OR REPLACE PROCEDURE proyecto.modificar_impuesto(p_id INTEGER, p_nombre VARCHAR, p_porcentaje FLOAT)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE proyecto.impuestos
	SET nombre = p_nombre,
		porcentaje = p_porcentaje
	WHERE id = p_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'El impuesto con id % no existe', p_id;
	END IF;

	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El impuesto % ya existe', p_nombre;
END;
$$;

CREATE OR REPLACE PROCEDURE proyecto.eliminar_impuesto(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
	DELETE FROM proyecto.impuestos WHERE id = p_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'El impuesto con id % no existe', p_id;
	END IF;
END;
$$;

CREATE OR REPLACE FUNCTION proyecto.listar_productos()
RETURNS TABLE (v_id INTEGER, v_codigo VARCHAR, v_nombre VARCHAR, v_descripcion VARCHAR, v_precio FLOAT4, v_medida VARCHAR, v_impuesto_id INTEGER, v_categoria_id INTEGER, v_stock INTEGER)
AS $$
BEGIN
	RETURN QUERY SELECT id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock FROM proyecto.productos;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION proyecto.obtener_productos_por_categoria(p_categoria_id INTEGER)
RETURNS TABLE (v_id INTEGER, v_codigo VARCHAR, v_nombre VARCHAR, v_descripcion VARCHAR, v_precio FLOAT4, v_medida VARCHAR, v_impuesto_id INTEGER, v_categoria_id INTEGER, v_stock INTEGER)
AS $$
BEGIN
	RETURN QUERY SELECT id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock FROM proyecto.productos WHERE categoria_id = p_categoria_id;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION proyecto.obtener_producto_por_nombre(p_nombre VARCHAR)
RETURNS TABLE (v_id INTEGER, v_codigo VARCHAR, v_nombre VARCHAR, v_descripcion VARCHAR, v_precio FLOAT4, v_medida VARCHAR, v_impuesto_id INTEGER, v_categoria_id INTEGER, v_stock INTEGER)
AS $$
BEGIN
	RETURN QUERY SELECT id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock FROM proyecto.productos WHERE nombre = p_nombre;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION proyecto.obtener_producto_por_codigo(p_codigo VARCHAR)
RETURNS TABLE (v_id INTEGER, v_codigo VARCHAR, v_nombre VARCHAR, v_descripcion VARCHAR, v_precio FLOAT4, v_medida VARCHAR, v_impuesto_id INTEGER, v_categoria_id INTEGER, v_stock INTEGER)
AS $$
BEGIN
	RETURN QUERY SELECT id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock FROM proyecto.productos WHERE codigo = p_codigo;
END;
$$
LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION proyecto.agregar_stock_producto(p_id INTEGER, p_cantidad INTEGER)
RETURNS VARCHAR
AS $$
DECLARE
	v_stock_actual INTEGER;
BEGIN
	SELECT stock INTO v_stock_actual FROM proyecto.productos WHERE id = p_id;

	IF NOT FOUND THEN
		RAISE EXCEPTION 'El producto con id % no existe', p_id;
	END IF;
	
	UPDATE proyecto.productos SET stock = stock + p_cantidad WHERE id = p_id;

	RETURN 'Stock actualizado';
END;
$$
LANGUAGE plpgsql;

-- PARTE JULIÁN

--CRUD cliente--
--Crear cliente--
CREATE OR REPLACE PROCEDURE proyecto.crear_cliente(p_documento varchar, p_nombre varchar, p_direccion varchar, p_telefono varchar, p_email varchar, p_ciudad varchar, p_departamento varchar)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO proyecto.clientes (id,numero_documento,nombre,direccion,telefono,email,ciudad,departamento) VALUES (nextval('proyecto.seq_clientes'),p_documento,p_nombre,p_direccion,p_telefono,p_email,p_ciudad,p_departamento);
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
	raise notice 'Usuario creado con exito';
END;
$$;

--Editar cliente--
CREATE OR REPLACE PROCEDURE proyecto.editar_cliente(p_id int,p_documento varchar,p_nombre varchar,p_direccion varchar,p_telefono varchar,p_email varchar,p_ciudad varchar,p_departamento varchar)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE proyecto.clientes SET numero_documento = p_documento, nombre = p_nombre, direccion = p_direccion, telefono = p_telefono, email = p_email, ciudad = p_ciudad, departamento = p_departamento WHERE id = p_id;
   	 
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El cliente con ID % no existe', p_id;
    END IF;

	RAISE NOTICE 'El cliente con ID % ha sido actualizado', p_id;
END;
$$;

--Eliminar cliente--
CREATE OR REPLACE PROCEDURE proyecto.eliminar_cliente(p_id int)
LANGUAGE plpgsql
AS $$
BEGIN 
	DELETE FROM proyecto.clientes WHERE id = p_id;
	IF NOT FOUND THEN
        RAISE EXCEPTION 'El cliente con ID % no existe', p_id;
    END IF;
	raise notice 'EL cliente con ID % ha sido eliminado',p_id;
END;
$$;


--CRUD Inventarios--
--Crear inventario--
CREATE OR REPLACE PROCEDURE proyecto.crear_inventario(p_fecha date, p_tipo_movimiento varchar, p_observaciones varchar, p_id_producto int)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.inventarios (id,fecha,tipo_movimiento,observaciones,id_producto) VALUES (nextval('proyecto.seq_inventarios'),p_fecha, (p_tipo_movimiento:: proyecto.tipos_movimiento) ,p_observaciones,p_id_producto);
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
	RAISE NOTICE 'Inventario creado exitosamente';
END;
$$;


--Editar inventario--
CREATE OR REPLACE PROCEDURE proyecto.editar_inventario(p_id int,p_fecha date, p_tipo_movimiento varchar, p_observaciones varchar, p_id_producto int)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE proyecto.inventarios SET fecha= p_fecha, tipo_movimiento= (p_tipo_movimiento:: proyecto.tipos_movimiento), observaciones = p_observaciones, id_producto = p_id_producto WHERE id = p_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'El inventario con ID % no existe', p_id;
	END IF;
	RAISE NOTICE 'El inventario con ID % ha sido actualizado', p_id;
END;
$$;


--Eliminar inventario--
CREATE OR REPLACE PROCEDURE proyecto.eliminar_inventario(p_id int)
LANGUAGE plpgsql
AS $$
BEGIN 
	DELETE FROM proyecto.inventarios WHERE id = p_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'El inventario con ID % no existe', p_id;
	END IF;
	raise notice 'El inventario con ID % ha sido eliminado', p_id;
END;
$$;


--CRUD Informes--
--Crear informe--
CREATE OR REPLACE PROCEDURE proyecto.crear_informe(p_tipo_informe varchar, p_fecha date, p_datos_json varchar)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.informes (id,tipo_informe,fecha,datos_json) VALUES (nextval('proyecto.seq_informes'),p_tipo_informe,p_fecha,(p_datos_json::jsonb));
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
	RAISE NOTICE 'Informe creado exitosamente';
END;
$$;

--Editar informe--
CREATE OR REPLACE PROCEDURE proyecto.editar_informe(p_id int,p_tipo_informe varchar, p_fecha date, p_datos_json varchar)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE proyecto.informes SET tipo_informe = p_tipo_informe, fecha = p_fecha, datos_json = (p_datos_json::jsonb) WHERE id = p_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'El informe con ID % no existe', p_id;
	END IF;
	RAISE NOTICE 'El informe con ID % ha sido actualizado', p_id;
END;
$$;

--Eliminar informe--
CREATE OR REPLACE PROCEDURE proyecto.eliminar_informe(p_id int)
LANGUAGE plpgsql
AS $$
BEGIN 
	DELETE FROM proyecto.informes WHERE id = p_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'El informe con ID % no existe', p_id;
	END IF;
	raise notice 'El informe con ID % ha sido eliminado', p_id;
END;
$$;

--CRUD Auditorias--
--Crear auditoria--
CREATE OR REPLACE PROCEDURE proyecto.crear_auditoria(p_fecha date, p_nombre_cliente varchar, p_cantidad int, p_nombre_producto varchar, p_total numeric)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.auditorias (fecha,nombre_cliente,cantidad,nombre_producto,total) VALUES (p_fecha,p_nombre_cliente,p_cantidad,p_nombre_producto,p_total);
	RAISE NOTICE 'Auditoria creada exitosamente';
END;
$$;

--Editar auditoria--
CREATE OR REPLACE PROCEDURE proyecto.editar_auditoria(p_id int,p_fecha date, p_nombre_cliente varchar, p_cantidad int, p_nombre_producto varchar, p_total numeric)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE proyecto.auditorias SET fecha = p_fecha, nombre_cliente = p_nombre_cliente, cantidad = p_cantidad, nombre_producto = p_nombre_producto, total = p_total WHERE id = p_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'La auditoria con ID % no existe', p_id;
	END IF;
	RAISE NOTICE 'La auditoria con ID % ha sido actualizada', p_id;
END;
$$;

--Eliminar auditoria--
CREATE OR REPLACE PROCEDURE proyecto.eliminar_auditoria(p_id int)
LANGUAGE plpgsql
AS $$
BEGIN 
	DELETE FROM proyecto.auditorias WHERE id = p_id;
	IF NOT FOUND THEN
		RAISE EXCEPTION 'La auditoria con ID % no existe', p_id;
	END IF;
	raise notice 'La auditoria con ID % ha sido eliminada', p_id;
END;
$$;


--FUNCIONALIDAD 11--
--Informe 10 productos más vendidos--
CREATE OR REPLACE FUNCTION proyecto.informe_top10()
RETURNS TABLE(
    producto_id INT,
    codigo VARCHAR,
    nombre VARCHAR,
    total_vendido BIGINT,
    factura_id INT
) 
AS $$
BEGIN
    RETURN QUERY
    SELECT df.producto_id, p.codigo, p.nombre, SUM(df.cantidad) AS total_vendido, df.factura_id
    FROM proyecto.detalles_facturas df JOIN proyecto.productos p ON df.producto_id = p.id GROUP BY df.producto_id, p.codigo, p.nombre, df.factura_id 
	ORDER BY total_vendido DESC LIMIT 10;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE PROCEDURE proyecto.insertar_informe_top10()
LANGUAGE plpgsql
AS $$
DECLARE
    datos_json jsonb;
BEGIN
    SELECT jsonb_agg(
        jsonb_build_object(
            'producto_id', producto_id,
            'codigo', codigo,
            'nombre', nombre,
            'total_vendido', total_vendido,
            'factura_id', factura_id
        )
    )
    INTO datos_json
    FROM proyecto.informe_top10();

    -- Insertar el informe en la tabla 'proyecto.informes'
    INSERT INTO proyecto.informes (tipo_informe, fecha, datos_json)
    VALUES ('Top 10 productos más vendidos', CURRENT_DATE, datos_json);

    -- Confirmar inserción (opcional para logging)
    RAISE NOTICE 'Informe Top 10 insertado con éxito en la fecha %', CURRENT_DATE;
END;
$$;


-- FUNCIONALIDAD 12 --
--Informe de ventas en donde se vean la factura y los productos vendidos de un mes determinado, y los cálculos totales facturados del mes.--
CREATE OR REPLACE FUNCTION proyecto.informe_ventas_mensual(anio INT, mes INT)
RETURNS TABLE(
    factura_id INT,
    codigo_factura VARCHAR,
    fecha_factura DATE,
    producto_id INT,
    producto_nombre VARCHAR,
    cantidad_vendida INT,
    valor_total_producto DOUBLE PRECISION,
    subtotal_mensual DOUBLE PRECISION,
    impuestos_mensuales DOUBLE PRECISION,
    total_facturado DOUBLE PRECISION
)
AS $$
BEGIN
    RETURN QUERY
    WITH ventas_mensuales AS (
        SELECT 
            f.id AS factura_id,
            f.codigo AS codigo_factura,
            f.fecha AS fecha_factura,
            df.producto_id,
            p.nombre AS producto_nombre,
            df.cantidad AS cantidad_vendida,
            df.valor_total AS valor_total_producto
        FROM 
            proyecto.facturas f
        JOIN 
            proyecto.detalles_facturas df ON f.id = df.factura_id
        JOIN 
            proyecto.productos p ON df.producto_id = p.id
        WHERE 
            EXTRACT(YEAR FROM f.fecha) = anio AND
            EXTRACT(MONTH FROM f.fecha) = mes
    ),
    calculos_totales AS (
        SELECT 
            SUM(f.subtotal) AS subtotal_mensual,
            SUM(f.total_impuestos) AS impuestos_mensuales,
            SUM(f.total) AS total_facturado
        FROM 
            proyecto.facturas f
        WHERE 
            EXTRACT(YEAR FROM f.fecha) = anio AND
            EXTRACT(MONTH FROM f.fecha) = mes
    )
    SELECT 
        v.factura_id,
        v.codigo_factura,
        v.fecha_factura,
        v.producto_id,
        v.producto_nombre,
        v.cantidad_vendida,
        v.valor_total_producto,
        c.subtotal_mensual,
        c.impuestos_mensuales,
        c.total_facturado
    FROM 
        ventas_mensuales v, 
        calculos_totales c;
END;
$$ LANGUAGE plpgsql;

-- FUNCIONALIDAD 14 --
-- Cuando se agregue un producto a la factura, se debe hacer el registro en la tabla auditoria (TRIGGER) --
CREATE OR REPLACE FUNCTION proyecto.registrar_auditoria()
RETURNS TRIGGER AS $$
DECLARE
    nombre_producto varchar(20);
    nombre_cliente varchar(30);
    total numeric;
BEGIN
    SELECT nombre INTO nombre_producto FROM proyecto.productos WHERE id = NEW.producto_id;

	SELECT c.nombre INTO nombre_cliente FROM proyecto.clientes c JOIN proyecto.facturas f ON f.id_cliente = c.id WHERE f.id = NEW.factura_id;

    total := NEW.cantidad * (NEW.valor_total / NULLIF(NEW.cantidad, 0)); 

    INSERT INTO proyecto.auditorias (fecha, nombre_cliente, cantidad, nombre_producto, total) VALUES (CURRENT_DATE, nombre_cliente, NEW.cantidad, nombre_producto, total);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_registrar_auditoria
AFTER INSERT ON proyecto.detalles_facturas
FOR EACH ROW
EXECUTE FUNCTION proyecto.registrar_auditoria();

-- FUNCIONALIDAD 15 --
-- Búsqueda de los registros de auditoria por los atributos fecha, nombre del cliente y producto --
CREATE OR REPLACE FUNCTION proyecto.consultar_auditorias(p_fecha date, p_nombre_cliente varchar, p_nombre_producto varchar)
RETURNS TABLE(
	auditoria_id INT,
	auditoria_fecha DATE,
	auditoria_nombre_cliente VARCHAR,
	auditoria_cantidad INT,
	auditoria_nombre_producto VARCHAR,
	auditoria_total NUMERIC
)
AS $$
BEGIN
	RETURN QUERY
	SELECT id, fecha, nombre_cliente, cantidad, nombre_producto, total
	FROM proyecto.auditorias
	WHERE fecha = p_fecha AND nombre_cliente = p_nombre_cliente AND nombre_producto = p_nombre_producto;
END;
$$ LANGUAGE plpgsql;

-- Funcion validar id producto cuando se actualice el inventario
CREATE OR REPLACE FUNCTION proyecto.validar_inventario_actualizado()
RETURNS TRIGGER AS $$
DECLARE
    producto_existente BOOLEAN;
BEGIN
    -- Verificar si el id_producto es menor o igual a 0
    IF NEW.id_producto <= 0 THEN
        RAISE EXCEPTION 'El id_producto % no es válido. Debe ser mayor que 0.', NEW.id_producto;
    END IF;

    -- Verificar si el id_producto existe en la tabla productos
    SELECT EXISTS (SELECT 1 FROM proyecto.productos WHERE id = NEW.id_producto)
    INTO producto_existente;

    IF NOT producto_existente THEN
        RAISE EXCEPTION 'El id_producto % no existe en la tabla productos.', NEW.id_producto;
    END IF;

    -- Si pasa las validaciones, se permite la actualización
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_validar_inventario
AFTER UPDATE ON proyecto.inventarios
FOR EACH ROW
EXECUTE FUNCTION proyecto.validar_inventario_actualizado();

-- Función validar cantidad cuanndo se actualice la auditoria
CREATE OR REPLACE FUNCTION proyecto.validar_cantidad_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que la cantidad sea mayor a 0
    IF NEW.cantidad <= 0 THEN
        RAISE EXCEPTION 'La cantidad en la auditoría no puede ser menor o igual a 0. Valor proporcionado: %', NEW.cantidad;
    END IF;

    -- Si pasa la validación, continuar con la operación
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_validar_cantidad_auditoria
BEFORE UPDATE ON proyecto.auditorias
FOR EACH ROW
EXECUTE FUNCTION proyecto.validar_cantidad_auditoria();

-- Validar que el total de la auditoría sea mayor o igual a 0
CREATE OR REPLACE FUNCTION proyecto.validar_total_auditoria()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que el total sea mayor o igual a 0
    IF NEW.total < 0 THEN
        RAISE EXCEPTION 'El total de la auditoría no puede ser menor a 0. Valor proporcionado: %', NEW.total;
    END IF;

    -- Si pasa la validación, continuar con la operación
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_validar_total_auditoria
BEFORE UPDATE ON proyecto.auditorias
FOR EACH ROW
EXECUTE FUNCTION proyecto.validar_total_auditoria();

-- Función para validar el email del cliente antes de insertar o actualizar
CREATE OR REPLACE FUNCTION proyecto.validar_email_cliente()
RETURNS TRIGGER AS $$
BEGIN
    -- Validar que el email tenga un formato correcto
    IF NEW.email !~* '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$' THEN
        RAISE EXCEPTION 'El email % no tiene un formato válido.', NEW.email;
    END IF;

    -- Si pasa la validación, continuar con la operación
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger para validar el email del cliente antes de insertar
CREATE TRIGGER trg_validar_email_cliente_insert
BEFORE INSERT ON proyecto.clientes
FOR EACH ROW
EXECUTE FUNCTION proyecto.validar_email_cliente();

-- Trigger para validar el email del cliente antes de actualizar
CREATE TRIGGER trg_validar_email_cliente_update
BEFORE UPDATE ON proyecto.clientes
FOR EACH ROW
EXECUTE FUNCTION proyecto.validar_email_cliente();

-- MAJO ---------------------------------------------------------------------

--CRUD
--Método de pago
CREATE OR REPLACE PROCEDURE proyecto.crear_metodo_pago(p_descripcion VARCHAR, p_identificador VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO proyecto.metodos_pago (descripcion, identificador) 
    VALUES (p_descripcion, p_identificador::proyecto.identificador_metodo_pago);

    RAISE NOTICE 'Método de pago creado correctamente: %', p_descripcion;
    
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe un método de pago con ese identificador: %', p_identificador;
END;
$$;


CREATE OR REPLACE PROCEDURE proyecto.modificar_metodo_pago(p_id INTEGER, p_descripcion VARCHAR, p_identificador VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE proyecto.metodos_pago
    SET descripcion = p_descripcion,
        identificador = p_identificador::proyecto.identificador_metodo_pago
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El método de pago con ID % no existe', p_id;
    END IF;

    RAISE NOTICE 'Método de pago con ID % actualizado correctamente.', p_id;
    
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe un método de pago con ese identificador: %', p_identificador;
END;
$$;



CREATE OR REPLACE PROCEDURE proyecto.eliminar_metodo_pago(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM proyecto.metodos_pago WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El método de pago con ID % no existe', p_id;
    END IF;

    RAISE NOTICE 'Método de pago con ID % eliminado correctamente.', p_id;
END;
$$;

--Factura
CREATE OR REPLACE PROCEDURE proyecto.agregar_factura(
    p_codigo VARCHAR, 
    p_fecha DATE, 
    p_subtotal DOUBLE PRECISION, 
    p_total_impuestos DOUBLE PRECISION, 
    p_total DOUBLE PRECISION, 
    p_estadoF VARCHAR , 
    p_id_cliente INTEGER, 
    p_id_metodo_pago INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO proyecto.facturas (id,codigo, fecha, subtotal, total_impuestos, total, estadoF, id_cliente, id_metodo_pago) 
    VALUES (nextval('proyecto.factura_ids'),p_codigo, p_fecha, p_subtotal, p_total_impuestos, p_total, (p_estadoF::proyecto.estado_factura), p_id_cliente, p_id_metodo_pago);

    RAISE NOTICE 'Factura con código % creada correctamente.', p_codigo;
    
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'La categoría, cliente o método de pago no existen';
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe una factura con ese código: %', p_codigo;
END;
$$;


CREATE OR REPLACE PROCEDURE proyecto.modificar_factura(
    p_id INTEGER, 
    p_codigo VARCHAR, 
    p_fecha DATE, 
    p_subtotal DOUBLE PRECISION, 
    p_total_impuestos DOUBLE PRECISION, 
    p_total DOUBLE PRECISION, 
    p_estadoF VARCHAR, 
    p_id_cliente INTEGER, 
    p_id_metodo_pago INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE proyecto.facturas
    SET codigo = p_codigo,
        fecha = p_fecha,
        subtotal = p_subtotal,
        total_impuestos = p_total_impuestos,
        total = p_total,
        estadoF = p_estadoF::proyecto.estado_factura,
        id_cliente = p_id_cliente,
        id_metodo_pago = p_id_metodo_pago
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Factura % no encontrada.', p_id;
    END IF;

    RAISE NOTICE 'Factura % modificada correctamente.', p_id;
    
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'La categoría, cliente o método de pago no existen';
END;
$$;



CREATE OR REPLACE PROCEDURE proyecto.eliminar_factura(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM proyecto.facturas WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Factura % no encontrada.', p_id;
    END IF;

    RAISE NOTICE 'Factura   % eliminada correctamente.', p_id;
END;
$$;

--Detalles Factura
CREATE OR REPLACE PROCEDURE proyecto.crear_detalle_factura(
    p_cantidad INTEGER, 
    p_valor_total DOUBLE PRECISION, 
    p_descuento FLOAT, 
    p_producto_id INTEGER, 
    p_factura_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO proyecto.detalles_facturas (cantidad, valor_total, descuento, producto_id, factura_id) 
    VALUES (p_cantidad, p_valor_total, p_descuento, p_producto_id, p_factura_id);

    RAISE NOTICE 'Detalle de factura creado correctamente para la factura con ID %', p_factura_id;
    
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El producto o la factura no existen';
END;
$$;

CREATE OR REPLACE PROCEDURE proyecto.modificar_detalle_factura(
    p_id INTEGER, 
    p_cantidad INTEGER, 
    p_valor_total DOUBLE PRECISION, 
    p_descuento FLOAT, 
    p_producto_id INTEGER, 
    p_factura_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE proyecto.detalles_facturas
    SET cantidad = p_cantidad,
        valor_total = p_valor_total,
        descuento = p_descuento,
        producto_id = p_producto_id,
        factura_id = p_factura_id
    WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Detalle de factura  % no encontrado.', p_id;
    END IF;

    RAISE NOTICE 'Detalle de factura % modificado correctamente.', p_id;
    
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'El producto o la factura no existen';
END;
$$;



CREATE OR REPLACE PROCEDURE proyecto.eliminar_detalle_factura(p_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM proyecto.detalles_facturas WHERE id = p_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Detalle de factura  % no encontrado.', p_id;
    END IF;

    RAISE NOTICE 'Detalle de factura % eliminado correctamente.', p_id;
END;
$$;


--FUNCIONALIDADES

CREATE OR REPLACE FUNCTION proyecto.agregar_cliente_a_factura(p_factura_id INT, p_cliente_id INT)
RETURNS VARCHAR AS $$
DECLARE
    v_resultado VARCHAR;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.clientes WHERE id = p_cliente_id) THEN
        RAISE EXCEPTION 'El cliente con id % no existe.', p_cliente_id;
    END IF;

    UPDATE proyecto.facturas SET id_cliente = p_cliente_id WHERE id = p_factura_id;

    v_resultado := format('Cliente %s agregado a la factura %s.', p_cliente_id, p_factura_id);
    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'Verifique que el cliente y la factura existan.';
END;
$$ LANGUAGE plpgsql;


--Agregar productos al detalle de la factura
CREATE OR REPLACE FUNCTION proyecto.agregar_producto_a_detalle_factura(p_factura_id INTEGER, p_producto_id INTEGER, p_cantidad INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    v_precio_producto DOUBLE PRECISION;
    v_resultado VARCHAR;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.facturas WHERE id = p_factura_id) THEN
        RAISE EXCEPTION 'La factura con % no existe.', p_factura_id;
    END IF;

    SELECT precio_venta INTO v_precio_producto FROM proyecto.productos WHERE id = p_producto_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto con % no existe.', p_producto_id;
    END IF;

    INSERT INTO proyecto.detalles_facturas (cantidad, valor_total, descuento, producto_id, factura_id)
    VALUES (p_cantidad, p_cantidad * v_precio_producto, 0, p_producto_id, p_factura_id);

    v_resultado := format('Producto %s agregado a la factura %s con cantidad %s.', p_producto_id::text, p_factura_id::text, p_cantidad::text);
    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'Verifique que el producto y la factura existan.';
END;
$$ LANGUAGE plpgsql;



--Calcular impuestos de los productos
CREATE OR REPLACE FUNCTION proyecto.calcular_impuestos_factura(p_factura_id INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    v_cantidad INTEGER;
    v_precio_venta DOUBLE PRECISION;
    v_porcentaje_impuesto DOUBLE PRECISION;
    v_total_impuestos DOUBLE PRECISION := 0;
    v_subtotal DOUBLE PRECISION := 0;
    v_impuesto DOUBLE PRECISION;
    v_resultado VARCHAR;
    cur CURSOR FOR
        SELECT df.cantidad, p.precio_venta, i.porcentaje 
        FROM proyecto.detalles_facturas df
        JOIN proyecto.productos p ON df.producto_id = p.id
        JOIN proyecto.impuestos i ON p.impuesto_id = i.id
        WHERE df.factura_id = p_factura_id;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.facturas WHERE id = p_factura_id) THEN
        RAISE EXCEPTION 'La factura con % no existe.', p_factura_id;
    END IF;

    OPEN cur;
    LOOP
        FETCH cur INTO v_cantidad, v_precio_venta, v_porcentaje_impuesto;
        EXIT WHEN NOT FOUND;

        v_impuesto := v_cantidad * v_precio_venta * v_porcentaje_impuesto / 100;
        v_total_impuestos := v_total_impuestos + v_impuesto;
        v_subtotal := v_subtotal + (v_cantidad * v_precio_venta);
    END LOOP;
    CLOSE cur;

    UPDATE proyecto.facturas
    SET subtotal = v_subtotal, 
        total_impuestos = v_total_impuestos, 
        total = v_subtotal + v_total_impuestos
    WHERE id = p_factura_id;

    v_resultado := format('Impuestos calculados para la factura %s: Subtotal = %s, Total Impuestos = %s, Total = %s', p_factura_id, v_subtotal, v_total_impuestos, v_subtotal + v_total_impuestos);
    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'Factura inválida.';
END;
$$ LANGUAGE plpgsql;


--Implementar descuentos por producto o por el total de factura
CREATE OR REPLACE FUNCTION proyecto.aplicar_descuento_factura(p_factura_id INTEGER, p_tipo_descuento VARCHAR, p_valor_descuento DOUBLE PRECISION)
RETURNS VARCHAR AS $$
DECLARE
    v_subtotal DOUBLE PRECISION;
    v_resultado VARCHAR;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.facturas WHERE id = p_factura_id) THEN
        RAISE EXCEPTION 'La factura con % no existe.', p_factura_id;
    END IF;

    IF p_tipo_descuento = 'POR_PRODUCTO' THEN
        UPDATE proyecto.detalles_facturas SET descuento = descuento + p_valor_descuento WHERE factura_id = p_factura_id;
        v_resultado := format('Descuento de %s aplicado por producto a la factura %s.', p_valor_descuento, p_factura_id);
    ELSIF p_tipo_descuento = 'TOTAL' THEN
        UPDATE proyecto.facturas SET total = total - p_valor_descuento WHERE id = p_factura_id;
        v_resultado := format('Descuento total de %s aplicado a la factura %s.', p_valor_descuento, p_factura_id);
    ELSE
        v_resultado := 'Tipo de descuento no válido.';
    END IF;

    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'Factura no válida.';
END;
$$ LANGUAGE plpgsql;


--Agregar método de pago a una factura ya creada
CREATE OR REPLACE FUNCTION proyecto.agregar_metodo_pago_a_factura(p_factura_id INTEGER, p_metodo_pago_id INTEGER)
RETURNS VARCHAR AS $$
DECLARE
    v_resultado VARCHAR;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.facturas WHERE id = p_factura_id) THEN
        RAISE EXCEPTION 'La factura con % no existe.', p_factura_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM proyecto.metodos_pago WHERE id = p_metodo_pago_id) THEN
        RAISE EXCEPTION 'El método de pago con % no existe.', p_metodo_pago_id;
    END IF;

    UPDATE proyecto.facturas SET id_metodo_pago = p_metodo_pago_id WHERE id = p_factura_id;

    v_resultado := format('Método de pago %s agregado a la factura %s.', p_metodo_pago_id, p_factura_id);
    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'El método de pago no es válido.';
    WHEN unique_violation THEN
        RETURN 'La factura ya tiene este método de pago asignado.';
END;
$$ LANGUAGE plpgsql;


-- MARTIN -----------------------------------------------------------------
-- Crear la función que se ejecutará después de insertar en la tabla facturas
CREATE OR REPLACE FUNCTION proyecto.insertar_xml_facturas()
RETURNS TRIGGER AS $$
DECLARE
    v_descripcion TEXT;
BEGIN
    -- Construir la descripción en formato XML con la información requerida
    SELECT 
        '<factura>' ||
        '<factura_id>' || NEW.id || '</factura_id>' ||
        '<codigo_factura>' || NEW.codigo || '</codigo_factura>' ||
        '<fecha>' || NEW.fecha || '</fecha>' ||
        '<subtotal>' || NEW.subtotal || '</subtotal>' ||
        '<total_impuestos>' || NEW.total_impuestos || '</total_impuestos>' ||
        '<total>' || NEW.total || '</total>' ||
        '<cliente>' ||
        '<id_cliente>' || NEW.id_cliente || '</id_cliente>' ||
        '<nombre_cliente>' || c.nombre || '</nombre_cliente>' ||
        '<documento_cliente>' || c.numero_documento || '</documento_cliente>' ||
        '<direccion_cliente>' || c.direccion || '</direccion_cliente>' ||
        '</cliente>' ||
        '<estado>' || NEW.estadoF || '</estado>' ||
        '<id_metodo_pago>' || NEW.id_metodo_pago || '</id_metodo_pago>' ||
        '<descripcion_metodo_pago>' || mp.descripcion || '</descripcion_metodo_pago>' ||
        '<detalles_factura>' ||
        '</detalles_factura>' ||
        '</factura>'
    INTO v_descripcion
    FROM proyecto.clientes c
    JOIN proyecto.metodos_pago mp ON mp.id = NEW.id_metodo_pago
    WHERE c.id = NEW.id_cliente;

    -- Insertar el registro en la tabla xml_facturas
    INSERT INTO proyecto.xml_facturas (id, factura_id, descripcion)
    VALUES (nextval('proyecto.seq_xml'), NEW.id, v_descripcion::xml);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger que llamará a la función después de insertar en la tabla facturas
CREATE TRIGGER after_insert_facturas_trigger
AFTER INSERT ON proyecto.facturas
FOR EACH ROW
EXECUTE FUNCTION proyecto.insertar_xml_facturas();


-- Crear la función que se ejecutará después de insertar en la tabla detalles_factura
CREATE OR REPLACE FUNCTION proyecto.insertar_detalle_factura_xml()
RETURNS TRIGGER AS $$
DECLARE
    v_detalles_factura TEXT := '';
    v_descripcion TEXT;
    detalle TEXT;
    cur CURSOR FOR
        SELECT '<detalle>' ||
               '<nombre_producto>' || pr.nombre || '</nombre_producto>' ||
               '<id_producto>' || dp.producto_id || '</id_producto>' ||
               '<cantidad>' || dp.cantidad || '</cantidad>' ||
               '<valor_total>' || dp.valor_total || '</valor_total>' ||
               '<descuento>' || dp.descuento || '</descuento>' ||
               '</detalle>'
        FROM proyecto.detalles_facturas dp
        JOIN proyecto.productos pr ON dp.producto_id = pr.id
        WHERE dp.factura_id = NEW.factura_id;
BEGIN
    -- Crear el contenido para los detalles de la factura
    OPEN cur;
    LOOP
        FETCH cur INTO detalle;
        EXIT WHEN NOT FOUND;
        v_detalles_factura := v_detalles_factura || detalle;
    END LOOP;
    CLOSE cur;

    -- Obtener la descripción actual de xml_facturas
    SELECT descripcion INTO v_descripcion
    FROM proyecto.xml_facturas
    WHERE factura_id = NEW.factura_id;

    -- Si v_descripcion es nulo, inicializarla con una estructura XML mínima
    IF v_descripcion IS NULL THEN
        v_descripcion := '<factura><detalles_factura></detalles_factura></factura>';
    END IF;

    -- Modificar la descripción para incluir los nuevos detalles
    v_descripcion := regexp_replace(v_descripcion, '<detalles_factura>.*</detalles_factura>', '<detalles_factura>' || v_detalles_factura || '</detalles_factura>');

    -- Actualizar la tabla xml_facturas con la nueva descripción
    UPDATE proyecto.xml_facturas
    SET descripcion = v_descripcion::xml
    WHERE factura_id = NEW.factura_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Crear el trigger que llamará a la función después de insertar en la tabla detalles_factura
CREATE TRIGGER after_insert_detalle_factura_trigger
AFTER INSERT ON proyecto.detalles_facturas
FOR EACH ROW
EXECUTE FUNCTION proyecto.insertar_detalle_factura_xml();


CREATE OR REPLACE FUNCTION proyecto.actualizar_stock_producto()
RETURNS TRIGGER AS $$
DECLARE
    v_stock_actual INTEGER;
BEGIN
    SELECT stock INTO v_stock_actual FROM proyecto.productos WHERE id = NEW.producto_id;

    IF v_stock_actual < NEW.cantidad THEN
        RAISE EXCEPTION 'No hay suficientes productos en stock para el producto con id %', NEW.producto_id;
    END IF;

    UPDATE proyecto.productos
    SET stock = stock - NEW.cantidad
    WHERE id = NEW.producto_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_stock_producto
BEFORE INSERT ON proyecto.detalles_facturas
FOR EACH ROW
EXECUTE FUNCTION proyecto.actualizar_stock_producto();


CREATE OR REPLACE FUNCTION proyecto.actualizar_subtotal_factura_before()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE proyecto.facturas
    SET subtotal = subtotal + NEW.valor_total
    WHERE id = NEW.factura_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_subtotal_factura_before
BEFORE INSERT ON proyecto.detalles_facturas
FOR EACH ROW
EXECUTE FUNCTION proyecto.actualizar_subtotal_factura_before();


CREATE OR REPLACE FUNCTION proyecto.actualizar_total_impuestos_before()
RETURNS TRIGGER AS $$
DECLARE
    v_impuesto DOUBLE PRECISION;
BEGIN
    SELECT i.porcentaje INTO v_impuesto
    FROM proyecto.productos p
    JOIN proyecto.impuestos i ON p.impuesto_id = i.id
    WHERE p.id = NEW.producto_id;

    UPDATE proyecto.facturas
    SET total_impuestos = total_impuestos + (NEW.valor_total * v_impuesto / 100)
    WHERE id = NEW.factura_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_total_impuestos_before
BEFORE INSERT ON proyecto.detalles_facturas
FOR EACH ROW
EXECUTE FUNCTION proyecto.actualizar_total_impuestos_before();


CREATE OR REPLACE FUNCTION proyecto.actualizar_total_factura_before()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE proyecto.facturas
    SET total = subtotal + total_impuestos
    WHERE id = NEW.factura_id;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_actualizar_total_factura_before
BEFORE INSERT ON proyecto.detalles_facturas
FOR EACH ROW
EXECUTE FUNCTION proyecto.actualizar_total_factura_before();


CREATE OR REPLACE FUNCTION proyecto.obtener_datos_cliente_xml(p_factura_id INTEGER)
RETURNS TABLE (nombre_cliente VARCHAR, documento_cliente VARCHAR, direccion_cliente VARCHAR) AS $$
BEGIN
    RETURN QUERY
    SELECT
        unnest(xpath('/factura/cliente/nombre_cliente/text()', descripcion))::VARCHAR AS nombre_cliente,
        unnest(xpath('/factura/cliente/documento_cliente/text()', descripcion))::VARCHAR AS documento_cliente,
        unnest(xpath('/factura/cliente/direccion_cliente/text()', descripcion))::VARCHAR AS direccion_cliente
    FROM proyecto.xml_facturas
    WHERE factura_id = p_factura_id;
END;
$$ LANGUAGE plpgsql;

-- SELECT nombre_cliente FROM proyecto.obtener_datos_cliente_xml(1)

CREATE OR REPLACE FUNCTION proyecto.obtener_detalles_factura_xml(p_factura_id INTEGER)
RETURNS TABLE (nombre_producto VARCHAR, id_producto VARCHAR, cantidad VARCHAR, valor_total VARCHAR, descuento VARCHAR) AS $$
DECLARE
    cur CURSOR FOR
        SELECT unnest(xpath('/factura/detalles_factura/detalle/nombre_producto/text()', descripcion))::VARCHAR AS nombre_producto,
               unnest(xpath('/factura/detalles_factura/detalle/id_producto/text()', descripcion))::VARCHAR AS id_producto,
               unnest(xpath('/factura/detalles_factura/detalle/cantidad/text()', descripcion))::VARCHAR AS cantidad,
               unnest(xpath('/factura/detalles_factura/detalle/valor_total/text()', descripcion))::VARCHAR AS valor_total,
               unnest(xpath('/factura/detalles_factura/detalle/descuento/text()', descripcion))::VARCHAR AS descuento
        FROM proyecto.xml_facturas
        WHERE factura_id = p_factura_id;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO nombre_producto, id_producto, cantidad, valor_total, descuento;
        EXIT WHEN NOT FOUND;
        RETURN NEXT;
    END LOOP;
    CLOSE cur;
END;
$$ LANGUAGE plpgsql;

-- SELECT * FROM proyecto.obtener_detalles_factura_xml(1)

CREATE OR REPLACE FUNCTION proyecto.obtener_total_impuesto(p_factura_id INTEGER)
RETURNS DOUBLE PRECISION AS $$
DECLARE
    v_total_impuesto DOUBLE PRECISION;
BEGIN
    SELECT xpath('/factura/total_impuestos/text()', descripcion)::TEXT::DOUBLE PRECISION
    INTO v_total_impuesto
    FROM proyecto.xml_facturas
    WHERE factura_id = p_factura_id;

    RETURN v_total_impuesto;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION proyecto.obtener_total_descuento(p_factura_id INTEGER)
RETURNS FLOAT AS $$
DECLARE
    v_total_descuento FLOAT;
BEGIN
    SELECT SUM(descuento::FLOAT)
    INTO v_total_descuento
    FROM (
        SELECT unnest(xpath('/factura/detalles_factura/detalle/descuento/text()', descripcion::xml)::text[]) AS descuento
        FROM proyecto.xml_facturas
        WHERE factura_id = p_factura_id
    ) AS sub;

    RETURN v_total_descuento;
END;
$$ LANGUAGE plpgsql;
