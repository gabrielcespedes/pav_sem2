CREATE TABLE clientes (
id SERIAL PRIMARY KEY, -- Identificador único del cliente
nombre VARCHAR(100) NOT NULL,
correo VARCHAR(100) UNIQUE NOT NULL, -- El correo debe ser único
telefono VARCHAR(20),
activo BOOLEAN DEFAULT TRUE -- Indica si el cliente está activo
);

CREATE TABLE facturas (
id SERIAL PRIMARY KEY, -- Identificador único de la factura
cliente_id INTEGER REFERENCES clientes(id) ON DELETE CASCADE, -- Relación con clientes
monto NUMERIC(10,2) NOT NULL, -- Monto de la factura con 2 decimales
fecha DATE NOT NULL DEFAULT CURRENT_DATE, -- Fecha de la factura
estado VARCHAR(20) CHECK (estado IN ('Pendiente', 'Pagado', 'Cancelado')) -- Estado de la factura
);

select * from clientes;

select * from facturas;

INSERT INTO clientes (nombre, correo, telefono, activo) VALUES
('Javier Herrera', 'javier@mail.com', '123456789', TRUE),
('María López', 'maria@mail.com', '987654321', TRUE),
('Pedro Sánchez', 'pedro@mail.com', '456789123', TRUE),
('Ana Torres', 'ana@mail.com', '789123456', TRUE),
('Luis Ramírez', 'luis@mail.com', '321654987', TRUE),
('Javier Gómez', 'javiergomez@mail.com', '741852963', TRUE),
('Beatriz Herrera', 'beatriz@mail.com', '963258741', FALSE),
('Diego Fernández', 'diego@mail.com', '159357486', TRUE),
('Carmen Rodríguez', 'carmen@mail.com', '852963741', TRUE),
('Esteban Castillo', 'esteban@mail.com', '369852147', TRUE);

INSERT INTO facturas (cliente_id, monto, fecha, estado) VALUES
(1, 500.00, '2024-01-10', 'Pagado'),
(1, 300.50, '2024-02-15', 'Pendiente'),
(2, 750.25, '2024-01-22', 'Pagado'),
(3, 1200.00, '2024-03-05', 'Cancelado'),
(4, 980.90, '2024-02-10', 'Pendiente'),
(5, 450.75, '2024-04-12', 'Pagado'),
(6, 670.00, '2024-01-30', 'Pagado'),
(7, 1100.00, '2024-03-18', 'Pendiente'),
(8, 250.40, '2024-02-25', 'Cancelado'),
(9, 500.00, '2024-01-10', 'Pagado'),
(10, 300.50, '2024-02-15', 'Pendiente'),
(1, 650.80, '2024-03-20', 'Pagado'),
(2, 850.90, '2024-02-05', 'Pendiente'),
(3, 999.99, '2024-04-02', 'Pagado'),
(4, 2000.00, '2024-03-25', 'Pagado'),
(5, 700.50, '2024-01-14', 'Pendiente'),
(6, 900.75, '2024-02-28', 'Cancelado'),
(7, 1300.25, '2024-03-07', 'Pagado'),
(8, 400.60, '2024-04-10', 'Pendiente'),
(9, 555.55, '2024-02-20', 'Pagado');

--JOINS

select clientes.nombre, facturas.id as id_factura, facturas.monto, 
facturas.fecha, facturas.estado
from clientes
join facturas
on clientes.id = facturas.cliente_id;

select c.nombre, f.id as id_factura, f.monto, f.fecha, f.estado
from clientes c
join facturas f
on c.id = f.cliente_id
order by c.nombre;

--VIEWS
create view clientes_facturas as
select c.nombre, f.id as id_factura, f.monto, f.fecha, f.estado
from clientes c
join facturas f
on c.id = f.cliente_id
order by c.nombre;

select * from clientes_facturas;

--SUBCONSULTAS
--Obtener los clientes que tienen al menos una factura con monto superior a 1000

select c.nombre, c.monto
from clientes_facturas c
where monto > 1000;

select nombre
from clientes
where id in (
    select cliente_id
    from facturas
    where monto > 1000
);

--Obtener datos de cliente(s) y factura para la de mayor monto 
select nombre, monto
from clientes_facturas
where monto = (
    select max(monto)
    from clientes_facturas
);

--Obtener los datos de cada cliente junto
--con su factura de mayor monto
--referencias
select nombre, id_factura, monto
from clientes_facturas
where monto = (
    select max(otros_clientes_facturas.monto)
    from clientes_facturas as otros_clientes_facturas
    where otros_clientes_facturas.nombre = clientes_facturas.nombre
);

--Obtener los datos de cada cliente junto
--con su factura de menor monto

select nombre,  id_factura, monto
from clientes_facturas
where monto = (
    select min(otros_clientes_facturas.monto)
    from clientes_facturas as otros_clientes_facturas
    where otros_clientes_facturas.nombre = clientes_facturas.nombre
);

--AGRUPACIONES
--Monto total facturado por cada cliente

select nombre, sum(monto) as total_facturado
from clientes_facturas
group by nombre
order by nombre;

--Mostrar sólo clientes que hayan facturado más de 1500 en total


select nombre,  sum(monto) as total_facturado
from clientes_facturas
group by  nombre
having sum(monto) > 1500
order by nombre;

--OTRA FORMA:
create view facturado_cliente as
select nombre, sum(monto) as total_facturado
from clientes_facturas
group by nombre
order by nombre;

select * from facturado_cliente;

select * from facturado_cliente
where total_facturado > 1500;

--Obtener datos cliente(s) con el máximo de total en facturas

select * from facturado_cliente;

select * from facturado_cliente
where total_facturado = (
    select max(total_facturado)
    from facturado_cliente
);

select * from clientes_facturas;

select nombre, sum(monto) as max_total_facturado
from clientes_facturas
group by nombre
having sum(monto) = (
    select max(totales_facturados)
    from (
        select sum(monto) as totales_facturados
        from clientes_facturas
        group by nombre
    )
);

--OPTIMIZACIÓN EN BASES DE DATOS

--ÍNDICES
--Crear índice en la columna correo de la tabla clientes

create index idx_cliente_correo on clientes(correo);

explain ANALYZE
select * from clientes
where correo = 'beatriz@mail.com';


--PARTICIONAMIENTO DE TABLAS
--Ejemplo: dividir la tabla facturas en particiones por año
create table facturas_2024 partition of facturas
for values from ('2024-01-01') to ('20224-12-31');


ALTER TABLE facturas RENAME TO facturas_old;

CREATE TABLE facturas (
    id SERIAL,
    cliente_id INTEGER REFERENCES clientes(id) ON DELETE CASCADE,
    monto NUMERIC(10,2) NOT NULL,
    fecha DATE NOT NULL,
    estado VARCHAR(20) CHECK (estado IN ('Pendiente', 'Pagado', 'Cancelado')),
    primary key (id, fecha)
) PARTITION BY RANGE (fecha);

--creación de particiones
select * from facturas_old;

CREATE TABLE facturas_2024_01 PARTITION OF facturas
FOR VALUES FROM ('2024-01-01') TO ('2024-02-01');

CREATE TABLE facturas_2024_02 PARTITION OF facturas
FOR VALUES FROM ('2024-02-01') TO ('2024-03-01');

CREATE TABLE facturas_2024_03 PARTITION OF facturas
FOR VALUES FROM ('2024-03-01') TO ('2024-04-01');

CREATE TABLE facturas_2024_04 PARTITION OF facturas
FOR VALUES FROM ('2024-04-01') TO ('2024-05-01');

CREATE TABLE facturas_default PARTITION OF facturas DEFAULT;

--migración

INSERT INTO facturas (id, cliente_id, monto, fecha, estado)
SELECT id, cliente_id, monto, fecha, estado FROM facturas_old;

select * from facturas_2024_03;

-- prueba de inserción automática
INSERT INTO facturas (cliente_id, monto, fecha, estado)
VALUES (1, 250.50, '2024-03-15', 'Pagado');

-- verificación de en qué partición quedó guardado
SELECT tableoid::regclass, * FROM facturas WHERE fecha = '2024-03-15';

