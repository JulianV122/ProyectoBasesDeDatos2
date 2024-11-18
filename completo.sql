CREATE SEQUENCE proyecto.seq_categorias
    START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_impuestos
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_productos
	START WITH 1000
	INCREMENT BY 3;

CREATE SEQUENCE id_facturas
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE id_detalles_facturas
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE id_metodos_pago
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

CREATE TYPE proyecto.tipos_movimiento AS ENUM ('ENTRADA','SALIDA'); 

CREATE TYPE estado_factura AS ENUM ('PAGADA', 'PENDIENTE', 'EN PROCESO');

CREATE TYPE identificador_metodo_pago AS ENUM ('EFECTIVO', 'TC', 'TD');


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
	tipo_movimiento tipos_movimiento NOT NULL,
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
	identificador identificador_metodo_pago  NULL,
	CONSTRAINT metodos_pago_pk PRIMARY KEY (id)
);

CREATE TABLE proyecto.facturas (
	id serial NOT NULL,
	codigo varchar NOT NULL,
	fecha date NULL,
	subtotal double precision NULL,
	total_impuestos double precision NULL,
	total double precision NULL,
	estadoF estado_factura NULL,
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


-- Insertar datos de prueba
-- INSERT INTO proyecto.categorias (id, descripcion) VALUES (nextval('seq_categorias'), 'Descripción prueba');
-- INSERT INTO proyecto.impuestos (id, nombre, porcentaje) VALUES (nextval('seq_impuestos'), 'IMPOCONSUMO', 0.1);
-- INSERT INTO proyecto.productos (id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock) VALUES (nextval('seq_productos'), '0001', 'Producto 1', 'Descripción producto', 7900, 'KILOGRAMOS', 1, 1, 10);
-- INSERT INTO proyecto.clientes (id, numero_documento, nombre, direccion, telefono, email, ciudad, departamento) VALUES (nextval('seq_clientes'), '1234567890', 'Juan Perez', 'Calle 123', '1234567', 'juan@gmail.com', 'Bogota', 'Cundinamarca');
-- INSERT INTO proyecto.metodos_pago (id, descripcion, identificador) VALUES (nextval('id_metodos_pago'), 'Efectivo', 'EFECTIVO');
-- INSERT INTO proyecto.facturas (id, codigo, fecha, subtotal, total_impuestos, total, estadoF, id_cliente, id_metodo_pago) VALUES (nextval('id_facturas'), '0001', '2021-10-01', 10000, 1000, 11000, 'PAGADA', 1, 1);
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
-- INSERT INTO proyecto.facturas (id, codigo, fecha, subtotal, total_impuestos, total, estadoF, id_cliente, id_metodo_pago) VALUES (nextval('id_facturas'), '0002', '2021-10-02', 20000, 2000, 22000, 'PENDIENTE', 4, 4);
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
CREATE OR REPLACE PROCEDURE proyecto.crear_inventario(p_fecha date, p_tipo_movimiento tipos_movimiento, p_observaciones varchar, p_id_producto int)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.inventarios (id,fecha,tipo_movimiento,observaciones,id_producto) VALUES (nextval('proyecto.seq_inventarios'),p_fecha,p_tipo_movimiento,p_observaciones,p_id_producto);
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
	RAISE NOTICE 'Inventario creado exitosamente';
END;
$$;


--Editar inventario--
CREATE OR REPLACE PROCEDURE proyecto.editar_inventario(p_id int,p_fecha date, p_tipo_movimiento tipos_movimiento, p_observaciones varchar, p_id_producto int)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE proyecto.inventarios SET fecha= p_fecha, tipo_movimiento= p_tipo_movimiento, observaciones = p_observaciones, id_producto = p_id_producto WHERE id = p_id;
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
CREATE OR REPLACE PROCEDURE proyecto.crear_informe(p_tipo_informe varchar, p_fecha date, p_datos_json jsonb)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.informes (id,tipo_informe,fecha,datos_json) VALUES (nextval('proyecto.seq_informes'),p_tipo_informe,p_fecha,p_datos_json);
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
	RAISE NOTICE 'Informe creado exitosamente';
END;
$$;

--Editar informe--
CREATE OR REPLACE PROCEDURE proyecto.editar_informe(p_id int,p_tipo_informe varchar, p_fecha date, p_datos_json jsonb)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE proyecto.informes SET tipo_informe = p_tipo_informe, fecha = p_fecha, datos_json = p_datos_json WHERE id = p_id;
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
	INSERT INTO proyecto.auditorias (id,fecha,nombre_cliente,cantidad,nombre_producto,total) VALUES (nextval('proyecto.seq_auditorias'),p_fecha,p_nombre_cliente,p_cantidad,p_nombre_producto,p_total);
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
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


CREATE OR REPLACE FUNCTION proyecto.insertar_informe_top10()
RETURNS VOID
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
    INSERT INTO proyecto.informes (id,tipo_informe, fecha, datos_json)
    VALUES (nextval('seq_informes'),'Top 10 productos más vendidos', CURRENT_DATE, datos_json);

    -- Confirmar inserción (opcional para logging)
    RAISE NOTICE 'Informe Top 10 insertado con éxito en la fecha %', CURRENT_DATE;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE PROCEDURE proyecto.agregar_cliente_a_factura(p_factura_id INT, p_cliente_id INT) 
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.clientes WHERE id = cliente_id) THEN
        RAISE EXCEPTION 'El cliente con id % no existe.', cliente_id;
    END IF;

    UPDATE proyecto.facturas  SET id_cliente = cliente_id   WHERE id = factura_id;

    
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Verifique que el cliente y la factura existan.';
END
$$;
