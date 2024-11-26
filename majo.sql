--ENTIDADES
CREATE TYPE estado_factura AS ENUM ('PAGADA', 'PENDIENTE', 'EN PROCESO');


CREATE TYPE identificador_metodo_pago AS ENUM ('EFECTIVO', 'TC', 'TD');

CREATE SEQUENCE id_facturas
	START WITH 1
	INCREMENT BY 1;

CREATE SEQUENCE id_detalles_facturas
	START WITH 1
	INCREMENT BY 1;


CREATE SEQUENCE id_metodos_pago
	START WITH 1
	INCREMENT BY 1;
	

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

--INSERT
INSERT INTO proyecto.metodos_pago (id, descripcion, identificador) VALUES (nextval('id_metodos_pago'), 'Pago en efectivo', 'EFECTIVO')
INSERT INTO proyecto.metodos_pago (id, descripcion, identificador) VALUES (nextval('id_metodos_pago'), 'Pago con tarjeta de crédito', 'TC')
INSERT INTO proyecto.metodos_pago (id, descripcion, identificador) VALUES (nextval('id_metodos_pago'), 'Pago con tarjeta de débito', 'TD')

INSERT INTO proyecto.facturas (id, codigo, fecha, subtotal, total_impuestos, total, estadoF, id_cliente, id_metodo_pago) VALUES (nextval('id_facturas'), 'FAC001', '2024-11-17', 1000.00, 190.00, 1190.00, 'PAGADA', 1, 1)
INSERT INTO proyecto.facturas (id, codigo, fecha, subtotal, total_impuestos, total, estadoF, id_cliente, id_metodo_pago) VALUES (nextval('id_facturas'), 'FAC002', '2024-11-18', 2000.00, 380.00, 2380.00, 'PENDIENTE', 2, 2)
INSERT INTO proyecto.facturas (id, codigo, fecha, subtotal, total_impuestos, total, estadoF, id_cliente, id_metodo_pago) VALUES (nextval('id_facturas'), 'FAC003', '2024-11-19', 1500.00, 285.00, 1785.00, 'EN PROCESO', 3, 3)

INSERT INTO proyecto.detalles_facturas (id, cantidad, valor_total, descuento, producto_id, factura_id) VALUES (nextval('id_detalles_facturas'), 2, 200.00, 5.00, 1, 1)
INSERT INTO proyecto.detalles_facturas (id, cantidad, valor_total, descuento, producto_id, factura_id) VALUES (nextval('id_detalles_facturas'), 1, 1000.00, 10.00, 2, 2),
INSERT INTO proyecto.detalles_facturas (id, cantidad, valor_total, descuento, producto_id, factura_id) VALUES  (nextval('id_detalles_facturas'), 3, 450.00, 15.00, 3, 3);

--CRUD
--Método de pago
CREATE OR REPLACE PROCEDURE proyecto.crear_metodo_pago(p_descripcion VARCHAR, p_identificador identificador_metodo_pago)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO proyecto.metodos_pago (descripcion, identificador) 
    VALUES (p_descripcion, p_identificador);

    RAISE NOTICE 'Método de pago creado correctamente: %', p_descripcion;
    
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe un método de pago con ese identificador: %', p_identificador;
END;
$$;

CALL proyecto.crear_metodo_pago('Pago con tarjeta', 1);

CREATE OR REPLACE PROCEDURE proyecto.modificar_metodo_pago(p_id INTEGER, p_descripcion VARCHAR, p_identificador identificador_metodo_pago)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE proyecto.metodos_pago
    SET descripcion = p_descripcion,
        identificador = p_identificador
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

CALL proyecto.modificar_metodo_pago(1, 'Pago con tarjeta actualizado', 1);


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

CALL proyecto.eliminar_metodo_pago(1);

--Factura
CREATE OR REPLACE PROCEDURE proyecto.agregar_factura(
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
    INSERT INTO proyecto.facturas (codigo, fecha, subtotal, total_impuestos, total, estadoF, id_cliente, id_metodo_pago) 
    VALUES (p_codigo, p_fecha, p_subtotal, p_total_impuestos, p_total, p_estadoF, p_id_cliente, p_id_metodo_pago);

    RAISE NOTICE 'Factura con código % creada correctamente.', p_codigo;
    
EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'La categoría, cliente o método de pago no existen';
    WHEN unique_violation THEN
        RAISE EXCEPTION 'Ya existe una factura con ese código: %', p_codigo;
END;
$$;

CALL proyecto.agregar_factura('FAC001', '2024-11-24', 1000.0, 200.0, 1200.0, 'PENDIENTE', 1, 1);


CREATE OR REPLACE PROCEDURE proyecto.modificar_factura(
    p_id INTEGER, 
    p_codigo VARCHAR, 
    p_fecha DATE, 
    p_subtotal DOUBLE PRECISION, 
    p_total_impuestos DOUBLE PRECISION, 
    p_total DOUBLE PRECISION, 
    p_estadoF estado_factura, 
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
        estadoF = p_estadoF,
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

CALL proyecto.modificar_factura(1, 'FAC001', '2024-11-25', 1100.0, 220.0, 1320.0, 'PAGADO', 2, 2);

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

CALL proyecto.eliminar_factura(1);

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

CALL proyecto.crear_detalle_factura(2, 240.0, 10.0, 3, 1);


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

CALL proyecto.modificar_detalle_factura(1, 2, 240.0, 15.0, 3, 1);


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

CALL proyecto.eliminar_detalle_factura(1);


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

    v_resultado := format('Cliente % agregado a la factura %.', p_cliente_id, p_factura_id);
    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'Verifique que el cliente y la factura existan.';
END;
$$ LANGUAGE plpgsql;

SELECT proyecto.agregar_cliente_a_factura(1, 1);


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

    INSERT INTO proyecto.detalles_facturas (id, cantidad, valor_total, descuento, producto_id, factura_id)
    VALUES (nextval('id_detalles_facturas'), p_cantidad, p_cantidad * v_precio_producto, 0, p_producto_id, p_factura_id);

    v_resultado := format('Producto % agregado a la factura % con cantidad %.', p_producto_id, p_factura_id, p_cantidad);
    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'Verifique que el producto y la factura existan.';
    WHEN data_exception THEN
        RETURN 'Cantidad o precio inválido.';
END;
$$ LANGUAGE plpgsql;

SELECT proyecto.agregar_producto_a_detalle_factura(1, 2, 3);

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

    v_resultado := format('Impuestos calculados para la factura %: Subtotal = %, Total Impuestos = %, Total = %', p_factura_id, v_subtotal, v_total_impuestos, v_subtotal + v_total_impuestos);
    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'Factura inválida.';
END;
$$ LANGUAGE plpgsql;

SELECT proyecto.calcular_impuestos_factura(1);


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
        UPDATE proyecto.detalles_facturas SET descuento = descuento + p_valor_descuento WHERE id_factura = p_factura_id;
        v_resultado := format('Descuento de % aplicado por producto a la factura %.', p_valor_descuento, p_factura_id);
    ELSIF p_tipo_descuento = 'TOTAL' THEN
        UPDATE proyecto.facturas SET descuento_total = descuento_total + p_valor_descuento, total = total - p_valor_descuento WHERE id = p_factura_id;
        v_resultado := format('Descuento total de % aplicado a la factura %.', p_valor_descuento, p_factura_id);
    ELSE
        v_resultado := 'Tipo de descuento no válido.';
    END IF;

    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'Factura no válida.';
END;
$$ LANGUAGE plpgsql;

SELECT proyecto.aplicar_descuento_factura(1, 'POR_PRODUCTO', 50.0);

SELECT proyecto.aplicar_descuento_factura(1, 'TOTAL', 100.0);


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

    v_resultado := format('Método de pago % agregado a la factura %.', p_metodo_pago_id, p_factura_id);
    RETURN v_resultado;

EXCEPTION
    WHEN foreign_key_violation THEN
        RETURN 'El método de pago no es válido.';
    WHEN unique_violation THEN
        RETURN 'La factura ya tiene este método de pago asignado.';
END;
$$ LANGUAGE plpgsql;

SELECT proyecto.agregar_metodo_pago_a_factura(1, 1);
