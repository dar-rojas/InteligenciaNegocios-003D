CREATE DATABASE DWAlbarran
USE DWAlbarran
GO

--Elimina todas las tablas
DROP TABLE FACT_VENTA;
DROP TABLE DTiempo;
DROP TABLE DUbicacion;
DROP TABLE DProducto;
DROP TABLE DCliente;
DROP TABLE DEmpleado;

--Creacion de tablas
CREATE TABLE DTiempo(
idTiempo int NOT NULL PRIMARY KEY IDENTITY(1,1),
dia int NOT NULL,
mes int NOT NULL,
anio int NOT NULL
);

CREATE TABLE DUbicacion(
idUbicacion int NOT NULL PRIMARY KEY IDENTITY(1,1),
nomComuna NVARCHAR(255) NOT NULL,
nomSucursal NVARCHAR(255) NOT NULL
);

CREATE TABLE DProducto(
idProducto int NOT NULL PRIMARY KEY IDENTITY(1,1),
nomProducto NVARCHAR(255) NOT NULL,
catProducto NVARCHAR(255) NOT NULL,
cantidad int NOT NULL,
precio int NOT NULL,
descuento float NOT NULL
);

CREATE TABLE DCliente(
	idCliente int NOT NULL PRIMARY KEY IDENTITY(1,1),
	[nombre_completo] [nvarchar](255) NOT NULL,
	[sexo] [char](1) NOT NULL,
	[fecha_nacimiento] [datetime] NULL,
	[estado_civil] [nvarchar](255) NULL
	);

CREATE TABLE DEmpleado(
	idEmpleado int NOT NULL PRIMARY KEY IDENTITY(1,1),
	[nombre_completo] [nvarchar](255) NOT NULL,
	[fecha_contrato] [datetime] NOT NULL,
	[sueldo_base] [int] NOT NULL,
	[cargo] [nvarchar](255) NOT NULL
);

CREATE TABLE FACT_VENTA(
--ids tablas dimencionales
idTiempo int,
idUbicacion int,
idProducto int,
idCliente int,
idEmpleado int,
-- Dimensiones
total_venta INT, -- valor total venta
promedio_valor_ventas_dia int,
max_valor_ventas_dia int,
min_valor_ventas_dia INT,
promedio_valor_ventas_mes int,
max_valor_ventas_mes int,
min_valor_ventas_mes INT,
promedio_valor_ventas_anio int,
max_valor_ventas_anio int,
min_valor_ventas_anio INT,
FOREIGN KEY (idTiempo) REFERENCES DTiempo(idTiempo),
FOREIGN KEY (idUbicacion) REFERENCES DUbicacion(idUbicacion),
FOREIGN KEY (idProducto) REFERENCES DProducto(idProducto),
FOREIGN KEY (idCliente) REFERENCES DCliente(idCliente),
FOREIGN KEY (idEmpleado) REFERENCES DEmpleado(idEmpleado)
);