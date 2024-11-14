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
INSERT INTO proyecto.clientes (id,numero_documento,nombre,direccion,telefono,email,ciudad,departamento) VALUES (nextval('seq_clientes'),'1','pepe','calle123','12345678','pepe@gmail','manizales','caldas');
INSERT INTO proyecto.inventarios (id,fecha,tipo_movimiento,observaciones,id_producto) VALUES (nextval('seq_inventarios'),'2024-01-01','ENTRADA','abcdf','1');
INSERT INTO proyecto.informes (id,tipo_informe,fecha,datos_json) VALUES (nextval('seq_informes'),'Recibos','2025-01-01',
'{
	"cliente":"Paco",
	"codigo":"123"
}'
);
INSERT INTO proyecto.auditorias (id,fecha,nombre_cliente,cantidad,nombre_producto,total) VALUES (nextval('seq_auditorias'),'2024-02-02','Juan',4,'Agua',4000);


