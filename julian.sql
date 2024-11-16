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

--CRUD clientes--

--Crear cliente--
CREATE OR REPLACE PROCEDURE proyecto.crear_cliente(p_documento varchar, p_nombre varchar, p_direccion varchar, p_telefono varchar, p_email varchar, p_ciudad varchar, p_departamento varchar)
LANGUAGE plpgsql
AS $$
BEGIN 
	INSERT INTO proyecto.clientes (id,numero_documento,nombre,direccion,telefono,email,ciudad,departamento) VALUES (nextval('seq_clientes'),p_documento,p_nombre,p_direccion,p_telefono,p_email,p_ciudad,p_departamento);
	raise notice 'Cliente creado con exito';
	
END;
$$;

CALL proyecto.crear_cliente('111','carlos','calle12344','12341123','a@email','manizales','caldas');

--Editar cliente--
CREATE OR REPLACE PROCEDURE proyecto.editar_cliente(p_id int,p_documento varchar, p_nombre varchar, p_direccion varchar, p_telefono varchar, p_email varchar, p_ciudad varchar, p_departamento varchar)
LANGUAGE plpgsql
AS $$
BEGIN 
	UPDATE  proyecto.clientes SET numero_documento = p_documento, nombre = p_nombre, direccion = p_direccion, telefono = p_telefono, email = p_email, ciudad = p_ciudad, departamento = p_departamento WHERE id = p_id;
	RAISE NOTICE 'El cliente ha sido actualizado';
END;
$$;

CALL proyecto.editar_cliente(1,'12345','Juanillo','siempreviva','00000','abc@email','pereira','risaralda');

--Eliminar cliente--
CREATE OR REPLACE PROCEDURE proyecto.eliminar_cliente(p_id int)
LANGUAGE plpgsql
AS $$
BEGIN 
	DELETE FROM proyecto.clientes WHERE id = p_id;
	raise notice 'EL cliente ha sido eliminado';
END;
$$;

CALL proyecto.eliminar_cliente(2);