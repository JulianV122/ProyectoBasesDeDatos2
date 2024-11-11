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
	descripcion varchar NULL,
	precio_venta float4 NOT NULL,
	medida varchar NULL,
	impuesto_id integer NULL,
	categoria_id integer NULL,
	CONSTRAINT productos_pk PRIMARY KEY (id),
	CONSTRAINT productos_unique UNIQUE (codigo),
	CONSTRAINT productos_categorias_fk FOREIGN KEY (categoria_id) REFERENCES proyecto.categorias(id) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT productos_impuestos_fk FOREIGN KEY (impuesto_id) REFERENCES proyecto.impuestos(id) ON DELETE CASCADE ON UPDATE CASCADE
);



INSERT INTO proyecto.categorias (id, descripcion) VALUES (nextval('seq_categorias'), 'Descripción prueba')
INSERT INTO proyecto.impuestos (id, nombre, porcentaje) VALUES (nextval('seq_impuestos'), 'IMPOCONSUMO', 0.1)
INSERT INTO proyecto.productos (id, codigo, descripcion, precio_venta, medida, impuesto_id, categoria_id) VALUES (nextval('seq_productos'), '0001', 'Descripción producto', 7900, 'KILOGRAMOS', 1, 1)


