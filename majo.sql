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
	CONSTRAINT facturas_pk PRIMARY KEY (id)	
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
	CONSTRAINT detalles_facturas_pk PRIMARY KEY (id)
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


--FUNCIONALIDADES
--Agregar cliente a factura:
CREATE OR REPLACE PROCEDURE agregar_cliente_a_factura(p_factura_id INT, p_cliente_id INT) 
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

--Agregar productos al detalle de la factura
CREATE OR REPLACE PROCEDURE proyecto.agregar_producto_a_detalle_factura(p_factura_id INTEGER, p_producto_id INTEGER, p_cantidad INTEGER) 
LANGUAGE plpgsql
AS $$
DECLARE
    v_precio_producto DOUBLE PRECISION;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.facturas WHERE id = p_factura_id) THEN
        RAISE EXCEPTION 'La factura con  % no existe.', p_factura_id;
    END IF;

    SELECT precio_venta INTO v_precio_producto FROM proyecto.productos WHERE id = p_producto_id;
    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto con  % no existe.', producto_id;
    END IF;

    INSERT INTO proyecto.detalles_facturas (id, cantidad, valor_total, descuento, producto_id, factura_id) VALUES ( nextval('id_detalles_facturas'), p_cantidad,p_cantidad * precio_producto, 0,p_producto_id,p_factura_id );
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE ' Verifique que el producto y la factura existan.';
        WHEN data_exception THEN
            RAISE NOTICE 'Cantidad o precio inválido.';
END
$$;



--Calcular impuestos de los productos
CREATE OR REPLACE PROCEDURE proyecto.calcular_impuestos_factura(p_factura_id INTEGER) 
LANGUAGE plpgsql
AS $$
DECLARE
    v_cantidad INTEGER;
    v_precio_venta DOUBLE PRECISION;
    v_porcentaje_impuesto DOUBLE PRECISION;
    v_total_impuestos DOUBLE PRECISION := 0;
    v_subtotal DOUBLE PRECISION := 0;
    v_impuesto DOUBLE PRECISION;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.facturas WHERE id = p_factura_id) THEN
        RAISE EXCEPTION 'La factura con % no existe.', p_factura_id;
    END IF;

    FOR v_cantidad, v_precio_venta, v_porcentaje_impuesto IN 
        SELECT df.cantidad, p.precio_venta, i.porcentaje 
        FROM proyecto.detalles_facturas df
        JOIN proyecto.productos p ON df.producto_id = p.id
        JOIN proyecto.impuestos i ON p.impuesto_id = i.id
        WHERE df.factura_id = p_factura_id
    LOOP
        v_impuesto := v_cantidad * v_precio_venta * v_porcentaje_impuesto / 100;
        v_total_impuestos := v_total_impuestos + v_impuesto;

        v_subtotal := v_subtotal + (v_cantidad * v_precio_venta);
    END LOOP;

    UPDATE proyecto.facturas
    SET subtotal = v_subtotal, 
        total_impuestos = v_total_impuestos, 
        total = v_subtotal + v_total_impuestos
    WHERE id = p_factura_id;

    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Factura inválida.';
END
$$;


--Implementar descuentos por producto o por el total de factura
CREATE OR REPLACE PROCEDURE proyecto.aplicar_descuento_factura(p_factura_id INTEGER, p_tipo_descuento VARCHAR, p_valor_descuento DOUBLE PRECISION) 
LANGUAGE plpgsql
AS $$
DECLARE
    v_subtotal DOUBLE PRECISION;
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.facturas WHERE id = p_factura_id) THEN
        RAISE EXCEPTION 'La factura con  % no existe.', p_factura_id;
    END IF;

    IF p_tipo_descuento = 'POR_PRODUCTO' THEN
        UPDATE proyecto.detalles_facturas SET descuento = descuento + p_valor_descuento WHERE factura_id = p_factura_id;
    ELSIF p_tipo_descuento = 'TOTAL' THEN
        UPDATE proyecto.facturas SET descuento_total = descuento_total + p_valor_descuento, total = total - p_valor_descuento  WHERE id = p_factura_id;
    END IF;

    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE NOTICE 'Factura no válida.';
END
$$;

--Agregar método de pago a una factura ya creada
CREATE OR REPLACE PROCEDURE proyecto.agregar_metodo_pago_a_factura(p_factura_id INTEGER,  p_metodo_pago_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM proyecto.facturas WHERE id = p_factura_id) THEN
        RAISE EXCEPTION 'La factura con  % no existe.', p_factura_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM proyecto.metodos_pago WHERE id = p_metodo_pago_id) THEN
        RAISE EXCEPTION 'El método de pago con  % no existe.', p_metodo_pago_id;
    END IF;

    UPDATE proyecto.facturas SET id_metodo_pago = p_metodo_pago_id WHERE id = p_factura_id;

    RAISE NOTICE 'Método de pago  % agregado a la factura  %.', p_metodo_pago_id, p_factura_id;

EXCEPTION
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'El método de pago no es válido.';
    WHEN unique_violation THEN
        RAISE NOTICE 'La factura ya tiene este método de pago asignado.';
END;
$$;

