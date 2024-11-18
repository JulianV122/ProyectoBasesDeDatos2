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
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
	raise notice 'Usuario creado con exito';
END;
$$;

CALL proyecto.crear_cliente('111000','carlos','calle12344','12341123','a@email','manizales','caldas');

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

CALL editar_cliente(1,'12345','Juanillo','siempreviva','00000','abc@email','pereira','risaralda');

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

CALL eliminar_cliente(2);

--CRUD Inventarios--
--Crear inventario--
CREATE OR REPLACE PROCEDURE proyecto.crear_inventario(p_fecha date, p_tipo_movimiento tipos_movimiento, p_observaciones varchar, p_id_producto int)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.inventarios (id,fecha,tipo_movimiento,observaciones,id_producto) VALUES (nextval('seq_inventarios'),p_fecha,p_tipo_movimiento,p_observaciones,p_id_producto);
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
	RAISE NOTICE 'Inventario creado exitosamente';
END;
$$;

CALL crear_inventario('2024-01-01','ENTRADA','Nuevo inventario',1);

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

CALL proyecto.editar_inventario(1,'2024-01-01','SALIDA','Inventario editado',1);

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

CALL proyecto.eliminar_inventario(1);

--CRUD Informes--
--Crear informe--
CREATE OR REPLACE PROCEDURE proyecto.crear_informe(p_tipo_informe varchar, p_fecha date, p_datos_json jsonb)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.informes (id,tipo_informe,fecha,datos_json) VALUES (nextval('seq_informes'),p_tipo_informe,p_fecha,p_datos_json);
	RAISE NOTICE 'Informe creado exitosamente';
END;
$$;

CALL proyecto.crear_informe('Factura','2024-01-01','{"cliente":"Paco","codigo":"123"}');

--Editar informe--
CREATE OR REPLACE PROCEDURE proyecto.editar_informe(p_id int,p_tipo_informe varchar, p_fecha date, p_datos_json jsonb)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE proyecto.informes SET tipo_informe = p_tipo_informe, fecha = p_fecha, datos_json = p_datos_json WHERE id = p_id;
	RAISE NOTICE 'El informe ha sido actualizado';
END;
$$;

CALL proyecto.editar_informe(1,'Factura','2024-02-02','{"cliente":"Carlos","codigo":"321"}');

--Eliminar informe--
CREATE OR REPLACE PROCEDURE proyecto.eliminar_informe(p_id int)
LANGUAGE plpgsql
AS $$
BEGIN 
	DELETE FROM proyecto.informes WHERE id = p_id;
	raise notice 'EL informe ha sido eliminado';
END;
$$;

CALL proyecto.eliminar_informe(1);

--CRUD Auditorias--
--Crear auditoria--
CREATE OR REPLACE PROCEDURE proyecto.crear_auditoria(p_fecha date, p_nombre_cliente varchar, p_cantidad int, p_nombre_producto varchar, p_total numeric)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.auditorias (id,fecha,nombre_cliente,cantidad,nombre_producto,total) VALUES (nextval('seq_auditorias'),p_fecha,p_nombre_cliente,p_cantidad,p_nombre_producto,p_total);
	RAISE NOTICE 'Auditoria creada exitosamente';
END;
$$;

CALL proyecto.crear_auditoria('2024-02-02','Juan',4,'Agua',4000);

--Editar auditoria--
CREATE OR REPLACE PROCEDURE proyecto.editar_auditoria(p_id int,p_fecha date, p_nombre_cliente varchar, p_cantidad int, p_nombre_producto varchar, p_total numeric)
LANGUAGE plpgsql
AS $$
BEGIN
	UPDATE proyecto.auditorias SET fecha = p_fecha, nombre_cliente = p_nombre_cliente, cantidad = p_cantidad, nombre_producto = p_nombre_producto, total = p_total WHERE id = p_id;
	RAISE NOTICE 'La auditoria ha sido actualizada';
END;
$$;

CALL proyecto.editar_auditoria(1,'2024-02-02','Juanillo',4,'Gaseosa',6000);

--Eliminar auditoria--
CREATE OR REPLACE PROCEDURE proyecto.eliminar_auditoria(p_id int)
LANGUAGE plpgsql
AS $$
BEGIN 
	DELETE FROM proyecto.auditorias WHERE id = p_id;
	raise notice 'La auditoria ha sido eliminada';
END;
$$;

CALL proyecto.eliminar_auditoria(1);