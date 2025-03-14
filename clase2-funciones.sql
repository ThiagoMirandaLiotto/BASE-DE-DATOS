#1) Crear una función que devuelva la cantidad de órdenes con determinado estado en el
#rango de dos fechas (orderDate). La función recibe por parámetro las fechas desde, hasta el estado.
delimiter //
create function cant_orden (fecha1 date, fecha2 date, estado varchar(45)) returns int deterministic
begin
	declare cant_ordenes int;
    select count(*) into cant_ordenes from orders where status = estado and orderDate between fecha1 and fecha2;
return cant_ordenes;
end//
delimiter ;

#2) Crear una función que reciba por parámetro dos fechas de envío (shippedDate) desde,
#hasta y devuelve la cantidad de órdenes entregadas.
delimiter //
create function cant_orden_entregados (fecha1 date, fecha2 date) returns int deterministic
begin
	declare cant_ordenes int;
    select count(*) into cant_ordenes from orders where status = "shipped" and orderDate between fecha1 and fecha2;
return cant_ordenes;
end//
delimiter ;

#3) Crear una función que reciba un número de cliente y devuelva la ciudad a la que
#corresponde el empleado que lo atiende.
delimiter //
create function funcion3 (numero_cliente int) returns text deterministic
begin
	declare ciudad text;
    select offices.city into ciudad from customers join employees on employees_number = customers_number join offices on officeCode = employees_number where customerNumber = numero_cliente;
return ciudad;
end//
delimiter ;

#4) Crear una función que reciba una productline y devuelva la cantidad de productos
#existentes en esa línea de producto.
delimiter //
create function funcion4 (categoria text) returns int deterministic
begin
	declare cantidad int;
    select count(*) into cantidad from products where productLine = categoria;
return cantidad;
end//
delimiter ;

#5) Crear una función que reciba un officeCode y devuelva la cantidad de clientes que tiene la
#oficina.
delimiter //
create function funcion5 (codigoOficina int) returns int deterministic
begin
	declare cantidad int;
    select count(*) into cantidad from customers join employees on employeeNumber = salesRepEmployeeNumber where officeCode = codigoOficina;
return cantidad;
end//
delimiter ;

#6) Crear una función que reciba un officeCode y devuelva la cantidad de órdenes que se
#hicieron en esa oficina.
delimiter //
create function funcion6 (codigoOficina int) returns int deterministic
begin
	declare cantidad int;
    select count(*) into cantidad from orders join customers on customers.customerNumber = orders.customerNumber join employees on salesRepEmployeeNumber = employeeNumber join offices on offices.officeCode = employees.officeCode where officeCode = codigoOficina;
return cantidad;
end//
delimiter ;

#7) Crear una función que reciba un nro de orden y un nro de producto, y devuelva el beneficio
#obtenido con ese producto. El beneficio debe calcularse como priceEach – buyPrice.
delimiter //
create function funcion7 (nro_orden int, nro_producto int) returns int deterministic
begin
	declare beneficio int;
    select (priceEach-buyPrice) into beneficio from product join orderdetails on orderNumber = productCode;
return beneficio;
end//
delimiter ;

#8) Crear una función que reciba un orderNumber y si el mismo está en estado cancelado
#devuelva -1, sino 0.
delimiter //
create function funcion8 (nro_orden int, nro_producto int) returns int deterministic
begin
	declare resultado int;
    select ;
return resultado;
end//
delimiter ;

#9) Crear una función que devuelva la fecha de la primera orden hecha por ese cliente. Recibe
#el nro de cliente por parámetro.
delimiter //
create function funcion9(numeroCliente int)returns date deterministic
begin
	declare fecha date;
	set fecha = (select orderDate from orders join
    customers on customers.customerNumber = orders.customerNumber
    where customers.customerNumber = numeroCliente order by orderDate asc limit 1);
    return fecha;
end//
delimiter ;

#10) La columna MSRP en la tabla de productos significa manufacturer 's suggested retail price
#(precio de venta sugerido por el fabricante). Crear una SF que reciba un código de
#producto y devuelva el porcentaje de veces que el producto se vendió por debajo de dicho
#precio.


#11) Crear una función que reciba un código de producto y devuelva la última fecha en la que
#fue pedido el mismo.
delimiter //
create function funcion11(productoCodigo text)returns date deterministic
begin
	declare fecha date;
    set fecha = (select orderDate from orders
    join orderdetails on orders.orderNumber = orderdetails.orderNumber
    where orderdetails.productCode = productoCodigo order by orderDate desc limit 1);
    return fecha;
end//
delimiter ;

#12) Crear una SF que reciba dos fechas desde, hasta y un código de producto. Si el producto
#fue ordenado en alguna orden entre esas fechas que devuelva el mayor precio. Si el
#producto no fue ordenado en esas fechas que devuelva 0.


#13) Crear una SF que reciba el número de empleado y devuelva la cantidad de clientes que
#atiende.
delimiter //
create function funcion13(empleadoCodigo int)returns int deterministic
begin
	declare clien int;
	set clien = (select count(*) from customers where salesRepEmployeeNumber = empleadoCodigo);
    return clien;
end//
delimiter ;

#14) Crear una SF que reciba un número de empleado y devuelva el apellido del empleado al
#que reporta.
delimiter //
create function funcion14(empleadoCodigo int)returns text deterministic
begin
	declare empleado text;
    set empleado = (select lastName from employees where employeeNumber = empleadoCodigo);
    return empleado;
end//
delimiter ;