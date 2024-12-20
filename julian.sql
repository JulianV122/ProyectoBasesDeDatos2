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

CALL crear_inventario('2024-01-01','ENTRADA','Nuevo inventario',1000);

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
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
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
	IF NOT FOUND THEN
		RAISE EXCEPTION 'El informe con ID % no existe', p_id;
	END IF;
	RAISE NOTICE 'El informe con ID % ha sido actualizado', p_id;
END;
$$;

CALL proyecto.editar_informe(1,'Factura','2024-02-02','{"cliente":"Carlos","codigo":"321"}');

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

CALL proyecto.eliminar_informe(1);

--CRUD Auditorias--
--Crear auditoria--
CREATE OR REPLACE PROCEDURE proyecto.crear_auditoria(p_fecha date, p_nombre_cliente varchar, p_cantidad int, p_nombre_producto varchar, p_total numeric)
LANGUAGE plpgsql
AS $$
BEGIN
	INSERT INTO proyecto.auditorias (id,fecha,nombre_cliente,cantidad,nombre_producto,total) VALUES (nextval('seq_auditorias'),p_fecha,p_nombre_cliente,p_cantidad,p_nombre_producto,p_total);
	EXCEPTION
		WHEN unique_violation THEN
			RAISE EXCEPTION 'El id % ya existe y no se puede repetir', p_id;
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
	IF NOT FOUND THEN
		RAISE EXCEPTION 'La auditoria con ID % no existe', p_id;
	END IF;
	RAISE NOTICE 'La auditoria con ID % ha sido actualizada', p_id;
END;
$$;

CALL proyecto.editar_auditoria(1,'2024-02-02','Juanillo',4,'Gaseosa',6000);

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

CALL proyecto.eliminar_auditoria(1);

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

SELECT proyecto.insertar_informe_top10();

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

SELECT * FROM proyecto.informe_ventas_mensual(2024, 11);

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

    INSERT INTO proyecto.auditorias (id,fecha, nombre_cliente, cantidad, nombre_producto, total) VALUES (nextval('seq_auditorias'),CURRENT_DATE, nombre_cliente, NEW.cantidad, nombre_producto, total);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger
CREATE TRIGGER trg_registrar_auditoria
AFTER INSERT ON proyecto.detalles_facturas
FOR EACH ROW
EXECUTE FUNCTION proyecto.registrar_auditoria();


INSERT INTO proyecto.detalles_facturas (id, cantidad, valor_total, descuento, producto_id, factura_id) VALUES (nextval('id_detalles_facturas'), 2, 20000, 0, 1003, 4);


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

SELECT * FROM proyecto.consultar_auditorias('2024-02-02', 'Juan', 'Agua');

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