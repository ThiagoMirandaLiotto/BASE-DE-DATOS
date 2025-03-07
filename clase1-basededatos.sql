#1) Listar los nombres de los proveedores de la ciudad de La Plata.
select nombre from proveedor where ciudad = "La Plata";
#2) Eliminar los artículos que no están compuestos por ningún material.
delete from articulo where not exists
	(select material_codigo from compuesto_por where codigo = material_codigo);
#3) Mostrar códigos y descripciones de los artículos compuestos por al menos un material
#provisto por el proveedor “Lopez”.
select codigo, descripcion from articulo join compuesto_por on articulo_codigo = articulo.codigo 
	where material_codigo in
		(select material_codigo from provisto_por join proveedor on proveedor.codigo = proveedor_codigo
			where nombre like "%Lopez%");

#4) Hallar códigos y nombres de proveedores que proveen al menos un material que se usa
#en algún artículo cuyo precio es mayor que $10000.
select codigo, nombre from proveedor join provisto_por on codigo.proveedor = material_codigo join articulo on material_codigo = articulo.codigo where articulo.precio > "10000";

#5) Hallar el o los códigos de artículos de mayor precio.
select codigo from articulos;

#6) Mostrar el nombre del producto que tiene mayor stock, teniendo en cuenta todos los almacenes.
select * from articulo where codigo = 
	(select articulo_codigo from tiene group by articulo_codigo order by sum(stock) desc limit 1);
    
#7) Hallar los números de almacenes que tienen artículos que incluyen el material con
#código 2.
select almacen_codigo from tiene 
	where articulo_codigo in 
	(select articulo_codigo from compuesto_por where material_codigo = 2) group by almacen_codigo;
    
#8) Listar el nombre del artículo que está compuesto por más materiales.
select descripcion from articulo join compuesto_por on articulo_codigo = articulo.codigo
	group by articulo_codigo order by count(material_codigo) desc limit 1;
    
#9) Modificar el precio de los productos con stock menor a 20, aumentarlo un 20%.
update articulo join tiene on articulo.codigo = articulo_codigo set precio = precio*1.2 where stock < 20;

#10) Listar el promedio de la cantidad de materiales por el que está compuesto un artículo.
select avg(cant) from (select count(material_codigo) as cant from compuesto_por group by articulo_codigo) as cantm;

#11) Hallar para cada almacén el precio mínimo, máximo y promedio de los artículos que
#tiene.
#12) Listar para cada almacén el stock valorizado (valor de los productos teniendo en
#cuenta el precio y el stock).
#13) Listar el stock valorizado de cada producto (independiente del almacén) para todos
#los artículos cuya existencia supera 100 unidades.
#14) Hallar los artículos cuyo precio es superior a $5000 y que están compuestos por más de
#tres materiales.

#15) Listar los materiales que componen los artículos cuyo precio es superior al precio
#promedio de los artículos del almacén nro. Realizar las siguientes consultas utilizando la base de 
#datos “almacen”;
