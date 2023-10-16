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
	UPPER(SUBSTRING(c.nombre + ' '  + c.appaterno + ' ' + c.apmaterno, 1, 255)) as nombre_completo,
	c.sexo as sexo,
	c.fecha_nacimiento as fecha_nacimiento,
	c.estado_civil as estado_civil
from ventas v join clientes c on v.cliente_id = c.cliente_id;

--DEmpleado
select 
	UPPER(SUBSTRING(e.nombre + ' '  + e.appaterno + ' ' + e.apmaterno, 1, 255)) as nombre_completo,
	e.fecha_contrato as fecha_contrato,
	e.sueldo_base as sueldo_base,
	c.nombre as cargo
from ventas v
	join empleados e on v.vendedor_id = e.empleado_id
	join cargos c on c.cargo_id = e.cargo_id;

--VENTAS_FACT
use DWAlbarran;
select 
	idProducto,
	precio * cantidad as total,
	kdia.max_valor_ventas as max_valor_ventas_dia,
	kdia.min_valor_ventas as min_valor_ventas_dia,
	kdia.promedio_valor_ventas as promedio_valor_ventas_dia,
	kmes.max_valor_ventas as max_valor_ventas_mes,
	kmes.min_valor_ventas as min_valor_ventas_mes,
	kmes.promedio_valor_ventas as promedio_valor_ventas_mes,
	kanio.max_valor_ventas as max_valor_ventas_anio,
	kanio.min_valor_ventas as min_valor_ventas_anio,
	kanio.promedio_valor_ventas as promedio_valor_ventas_anio
from
	DProducto p join DTiempo t on p.idProducto = t.idTiempo
	join (
		select
			t.dia as dia,
			t.mes as mes,
			t.anio as anio,
			AVG(precio*cantidad) as promedio_valor_ventas, 
			max(precio*cantidad) as max_valor_ventas, 
			min(precio*cantidad) as min_valor_ventas
		from DProducto p join DTiempo t on p.idProducto = t.idTiempo
		group by t.dia, t.mes, t.anio
	)kdia on t.anio = kdia.anio and t.mes = kdia.mes and t.dia = kdia.dia
	join (
		select
			t.mes as mes,
			t.anio as anio,
			AVG(precio*cantidad) as promedio_valor_ventas, 
			max(precio*cantidad) as max_valor_ventas, 
			min(precio*cantidad) as min_valor_ventas
		from DProducto p join DTiempo t on p.idProducto = t.idTiempo
		group by t.mes, t.anio
	) kmes on t.anio = kmes.anio and kmes.mes = t.mes
	join (
		select
			t.anio as anio,
			AVG(precio*cantidad) as promedio_valor_ventas, 
			max(precio*cantidad) as max_valor_ventas, 
			min(precio*cantidad) as min_valor_ventas
		from DProducto p join DTiempo t on p.idProducto = t.idTiempo
		group by t.anio
	) kanio on t.anio = kanio.anio;
