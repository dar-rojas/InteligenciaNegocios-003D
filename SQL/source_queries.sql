/*
	Consultas para extraer datos que se insertarán en el modelo estrella
*/
use Albarran;

--DTiempo
select 
	YEAR(fecha) as anio,
	MONTH(fecha) as mes,
	DAY(fecha) as dia
from ventas;

--DUbicacion
select 
	s.sucursal as nomSucursal,
	c.comuna as nomComuna
from ventas v
	join sucursales s on v.sucursal_id = s.sucursal_id
	join comunas c on c.comuna_id = s.sucursal_id;

--DProducto
select 
	p.nombre as nomProducto,
	c.categoria as catProducto,
	dv.cantidad as cantidad,
	p.precio as precio,
	dv.descuento as descuento
from ventas v
	join detalle_ventas dv on v.venta_id = dv.venta_id
	join productos p on dv.producto_id = p.producto_id
	join categorias c on p.categoria_id = c.categoria_id;

--DCliente
select 
	c.nombre + ' '  + c.appaterno + ' ' + c.apmaterno as nombre_completo,
	c.sexo as sexo,
	c.fecha_nacimiento as fecha_nacimiento,
	c.estado_civil as estado_civil
from ventas v join clientes c on v.cliente_id = c.cliente_id;

--DEmpleado
select 
	e.nombre + ' '  + e.appaterno + ' ' + e.apmaterno as nombre_completo,
	e.fecha_contrato as fecha_contrato,
	e.sueldo_base as sueldo_base,
	c.nombre as cargo
from ventas v
	join empleados e on v.vendedor_id = e.empleado_id
	join cargos c on c.cargo_id = e.cargo_id;

--VENTAS_FACT
use DWAlbarran;
declare 
@promedio_valor_ventas int,
@max_valor_ventas int,
@min_valor_ventas int

select @promedio_valor_ventas = AVG(precio*cantidad), 
	@max_valor_ventas = max(precio*cantidad), 
	@min_valor_ventas = min(precio*cantidad) 
from FACT_VENTA v join DProducto p on v.idProducto = p.idProducto;

select precio * cantidad as total_venta,
	@promedio_valor_ventas as promedio_valor_ventas,
	@max_valor_ventas as max_valor_ventas,
	@min_valor_ventas as min_valor_ventas
from FACT_VENTA v join DProducto p on v.idProducto = p.idProducto;