#----------Ejercicio 1----------:
delimiter //
create function empleadosNiveles(codigoEmpleado int)returns text deterministic
begin
	declare nivel text;
	declare empleados int;
    set empleados = (select count(*) from employees where reportsTo = codigoEmpleado);
	
	if empleados > 19 then
		set nivel = "Nivel 3";
	else if empleados > 9 then
		set nivel = "Nivel 2";
	else
		set nivel = "Nivel 1";
	end if;
    end if;
    
    return nivel;
    
end	//
delimiter ;

select empleadosNiveles(1002);

#----------Ejercicio 2----------:
delimiter //
create function entrefechas (orderDate date, shippedDate date) returns int deterministic
begin
	declare dias int;
	set dias = (select datediff(orderDate, shippedDate));

	return dias;
end //
delimiter ;

select entrefechas("2005-03-20", "2005-03-05");

#----------Ejercicio 3----------:
delimiter //
create function estadoOrdenes() returns int deterministic
begin
	declare cantidad int;
    set cantidad = (select count(*) from orders where entrefechas(orderDate, shippedDate) > 10);
    update orders set status = "cancelled" where entrefechas(orderDate, shippedDate) > 10;
    return cantidad;
end// 
delimiter ;

select estadoOrdenes;
#----------Ejercicio 4----------:
delimiter //
create function eliminarProducto(codigoOrden int, codigoProducto text) returns int deterministic
begin
	declare cantidad int;
    set cantidad = (select quantityOrdered from orderdetails where orderNumber = codigoOrden and productCode = codigoProducto);
    delete from orderdetails where orderNumber = codigoOrden and productCode = codigoProducto;
		
	return cantidad;
end //
delimiter ;

select eliminarProducto(10100, "S18_1749");

#----------Ejercicio 5----------:
delimiter //
create function stock(codigoProducto text) returns text deterministic
begin
	declare cantidad int;
    declare stock text;
	set cantidad = (select quantityInStock from products where productCode = codigoProducto);
    
    if cantidad > 5000 then
		set stock = "Sobrestock";
	else if stock > 5000 then
		set stock = "Stock adecuado";
	else
		set stock = "BajoStock";
	end if;
    end if;
    
    return stock;
end //
delimiter ;

drop function stock;
select * from products;
select stock("S12_1099");
#----------Ejercicio 6----------:
