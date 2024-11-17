CREATE SEQUENCE proyecto.seq_categorias
START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_impuestos
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE proyecto.seq_productos
	START WITH 1000
	INCREMENT BY 3;

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

INSERT INTO proyecto.categorias (id, descripcion) VALUES (nextval('seq_categorias'), 'Descripción prueba');
INSERT INTO proyecto.impuestos (id, nombre, porcentaje) VALUES (nextval('seq_impuestos'), 'IMPOCONSUMO', 0.1);
INSERT INTO proyecto.productos (id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock) VALUES (nextval('seq_productos'), '0001', 'Producto 1', 'Descripción producto', 7900, 'KILOGRAMOS', 1, 1, 10);

CREATE OR REPLACE PROCEDURE proyecto.crear_producto(p_codigo VARCHAR, p_nombre VARCHAR, p_descripcion VARCHAR, p_precio FLOAT, p_medida VARCHAR, p_impuesto_id INTEGER, p_categoria_id INTEGER, p_stock INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO proyecto.productos (id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock) VALUES (nextval('seq_productos'), p_codigo, p_nombre, p_descripcion, p_precio, p_medida, p_impuesto_id, p_categoria_id, p_stock);
	
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

CALL proyecto.crear_producto('0003', 'Producto 2', 'Descripción producto 2', 7900, 'KILOGRAMOS', 2, 2, 20);

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

CALL proyecto.modificar_producto(4, '0002', 'Producto 3', 'Descripción producto 3', 8500, 'LITROS', 1, 1, 30);

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

CALL proyecto.eliminar_producto(4);

CREATE OR REPLACE PROCEDURE proyecto.crear_categoria(p_descripcion VARCHAR)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.categorias (id, descripcion) VALUES (nextval('seq_categorias'), p_descripcion);

	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'La categoría % ya existe', p_descripcion;
END;
$$;

CALL proyecto.crear_categoria('Nueva categoría 2');

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

CALL proyecto.modificar_categoria(1, 'Categoría actualizada');

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

CALL proyecto.eliminar_categoria(1);

CREATE OR REPLACE PROCEDURE proyecto.crear_impuesto(p_nombre VARCHAR, p_porcentaje FLOAT)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.impuestos (id, nombre, porcentaje) VALUES (nextval('seq_impuestos'), p_nombre, p_porcentaje);

	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El impuesto % ya existe', p_nombre;
END;
$$;

CALL proyecto.crear_impuesto('IVA', 0.19);

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

CALL proyecto.modificar_impuesto(1, 'IVA actualizado', 0.21);

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

CALL proyecto.eliminar_impuesto(1);

CREATE OR REPLACE FUNCTION proyecto.listar_productos()
RETURNS TABLE (v_id INTEGER, v_codigo VARCHAR, v_nombre VARCHAR, v_descripcion VARCHAR, v_precio FLOAT4, v_medida VARCHAR, v_impuesto_id INTEGER, v_categoria_id INTEGER, v_stock INTEGER)
AS $$
BEGIN
	RETURN QUERY SELECT id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock FROM proyecto.productos;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM proyecto.listar_productos();

CREATE OR REPLACE FUNCTION proyecto.obtener_productos_por_categoria(p_categoria_id INTEGER)
RETURNS TABLE (v_id INTEGER, v_codigo VARCHAR, v_nombre VARCHAR, v_descripcion VARCHAR, v_precio FLOAT4, v_medida VARCHAR, v_impuesto_id INTEGER, v_categoria_id INTEGER, v_stock INTEGER)
AS $$
BEGIN
	RETURN QUERY SELECT id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock FROM proyecto.productos WHERE categoria_id = p_categoria_id;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM proyecto.obtener_productos_por_categoria(2);

CREATE OR REPLACE FUNCTION proyecto.obtener_producto_por_nombre(p_nombre VARCHAR)
RETURNS TABLE (v_id INTEGER, v_codigo VARCHAR, v_nombre VARCHAR, v_descripcion VARCHAR, v_precio FLOAT4, v_medida VARCHAR, v_impuesto_id INTEGER, v_categoria_id INTEGER, v_stock INTEGER)
AS $$
BEGIN
	RETURN QUERY SELECT id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock FROM proyecto.productos WHERE nombre = p_nombre;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM proyecto.obtener_producto_por_nombre('Producto 2');

CREATE OR REPLACE FUNCTION proyecto.obtener_producto_por_codigo(p_codigo VARCHAR)
RETURNS TABLE (v_id INTEGER, v_codigo VARCHAR, v_nombre VARCHAR, v_descripcion VARCHAR, v_precio FLOAT4, v_medida VARCHAR, v_impuesto_id INTEGER, v_categoria_id INTEGER, v_stock INTEGER)
AS $$
BEGIN
	RETURN QUERY SELECT id, codigo, nombre, descripcion, precio_venta, medida, impuesto_id, categoria_id, stock FROM proyecto.productos WHERE codigo = p_codigo;
END;
$$
LANGUAGE plpgsql;

SELECT * FROM proyecto.obtener_producto_por_codigo('0003');

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

SELECT proyecto.agregar_stock_producto(1, 10);