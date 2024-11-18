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




