###------------	PROCEDURE ------------###

#-----------Ejercicio 1-----------:
delimiter //
create procedure productosCaros()
begin
	select productCode from products where buyPrice > (select avg(buyPrice) from products);
	select count(*) from products where buyPrice > (select avg(buyPrice) from products);
end //
delimiter ;

call productosCaros();
drop procedure productosCaros;


#-----------Ejercicio 2-----------:
delimiter //
create procedure borrarOrden(in codigoProducto text)
begin
	select count(*) from orderdetails where productCode = codigoProducto;
    delete from orderdetails where productCode = codigoProducto;
    delete from products where productCode = codigoProducto;
end //
delimiter ; 

call borrarOrden("S10_1949");

#-----------Ejercicio 3-----------:
select * from productlines;

delimiter //
create procedure borrarLinea(in linea text, out result text)
begin
	if linea in (select productLine from products) then
		set result = "La linea de productos no pudo borrarse porque contiene productos asociados";
	else
		set result = "La linea de productos fue borrada";
        delete from productline where productline = linea;
	end if;
    select result;
end //
delimiter ;

call borrarLinea("Trains", @result);

#-----------Ejercicio 4-----------:
delimiter //
create procedure estado()
begin
	select state, count(*) from orders join customers on orders.customerNumber = customers.customerNumber where state is not null group by state;
end //
delimiter ;

drop procedure estado;
call estado();

#-----------Ejercicio 5-----------:
delimiter //
create procedure empleadosConSubordinados()
begin
	select 
		e.employeeNumber as jefe,
		concat(e.firstName, ' ', e.lastName) as nombre,
		count(s.employeeNumber) as subordinados
	from employees e
	join employees s on e.employeeNumber = s.reportsTo
	group by e.employeeNumber;
end //
delimiter ;

call empleadosConSubordinados();
drop procedure empleadosConSubordinados;

#-----------Ejercicio 6-----------:
delimiter //
create procedure ordenesTotales()
begin
	select 
		orders.orderNumber,
		sum(quantityOrdered * priceEach) as total
	from orders
	join orderdetails using(orderNumber)
	group by orders.orderNumber;
end //
delimiter ;

call ordenesTotales();
drop procedure ordenesTotales;

#-----------Ejercicio 7-----------:
delimiter //
create procedure ordenesPorCliente()
begin
	select 
		customers.customerNumber,
		customers.customerName,
		orders.orderNumber,
		sum(quantityOrdered * priceEach) as total
	from customers
	join orders using(customerNumber)
	join orderdetails using(orderNumber)
	group by customers.customerNumber, orders.orderNumber;
end //
delimiter ;

call ordenesPorCliente();


#-----------Ejercicio 8-----------:
delimiter //
create procedure actualizarComentario(in numeroOrden int, in comentario text, out resultado int)
begin
	if numeroOrden in (select orderNumber from orders) then
		update orders set comments = comentario where orderNumber = numeroOrden;
		set resultado = 1;
	else
		set resultado = 0;
	end if;
    select resultado;
end //
delimiter ;
call actualizarComentario(10100, "Comentario actualizado", @resultado);







#-----------CURSOR-----------:
#-----------Ejercicio 9-----------:
delimiter //
create procedure getCiudadesOffices(out ciudadesList text)
begin
    declare ciudadObtenida varchar(255) default '';
    declare hayFilas bool default 1;
    
    declare oficinasCursor cursor for 
        select city from offices;

    declare continue handler for not found set hayFilas = 0;

end
//delimiter ;
#-----------Ejercicio 10------------;
delimiter //
create procedure ordenesCanceladas (out cantOrdenes int) 
begin
declare hayFilas boolean default 1;
declare orderNumber1 int;
declare orderDate1 date;
declare requiredDate1 date;
declare shippedDate1 date;
declare status1 varchar(45);
declare comments1 varchar(45);
declare customerNumber1 int;
declare contador int default 0;
declare recorrer cursor for select orderNumber, orderDate, requiredDate, shippedDate, status, comments, customerNumber from orders;
declare continue handler for not found set hayFilas = 0;
open recorrer;
bucle:loop
fetch recorrer into orderNumber1,orderDate1,requiredDate1,shippedDate1,status1,customerNumber1;
if hayFilas = 0 then
leave bucle;
end if;
if status1="Cancelled" then
set contador=contador+1;
set cantOrdenes=contador;
insert into CanceledOrders values(orderNumber1,orderDate1, requiredDate1, shippedDate1, status1, comments1, customerNumber1);
end if;
end loop bucle;
close recorrer;
end//
delimiter ;

#-----------Ejercicio 11-----------:
delimiter //
create procedure actualizarComentariosOrdenes(in numeroCliente int)
begin
	declare numeroOrden int;
	declare total float;
	declare terminado int default 0;
	declare cursorOrdenes cursor for 
		select orderNumber from orders 
		where customerNumber = numeroCliente and (comments is null or comments = '');
	declare continue handler for not found set terminado = 1;

	open cursorOrdenes;
	
	leer_ordenes: loop
		fetch cursorOrdenes into numeroOrden;
		if terminado = 1 then
			leave leer_ordenes;
		end if;

		select sum(quantityOrdered * priceEach)
		into total
		from orderdetails
		where orderNumber = numeroOrden;

		update orders
		set comments = concat('El total de la orden es ', total)
		where orderNumber = numeroOrden;
	end loop;

	close cursorOrdenes;
end //
delimiter ;

call actualizarComentariosOrdenes(103);

#-----------Ejercicio 12-----------:
delimiter //
create procedure telefonosClientesInactivos(out telefonos text)
begin
	declare telefonoActual varchar(50);
	declare terminado int default 0;
	declare cursorTelefonos cursor for
		select phone from customers
		where customerNumber in (
			select customerNumber from orders where status = 'Cancelled'
		)
		and customerNumber not in (
			select customerNumber from orders where status != 'Cancelled'
		);
	declare continue handler for not found set terminado = 1;

	set telefonos = '';

	open cursorTelefonos;

	listarTelefonos: loop
		fetch cursorTelefonos into telefonoActual;
		if terminado = 1 then
			leave listarTelefonos;
		end if;
		if telefonos = '' then
			set telefonos = telefonoActual;
		else
			set telefonos = concat(telefonos, ', ', telefonoActual);
		end if;
	end loop;

	close cursorTelefonos;

	select telefonos;
end //
delimiter ;

call telefonosClientesInactivos(@telefonos);


#-----------Ejercicio 13-----------:
delimiter //
create procedure comisiones (out comision float) 
begin
declare plata int default 0;
declare hayFilas boolean default 1;
declare sales int;
declare amounti float;
declare recorrer cursor for select salesRepEmployeeNumber, customers.customersNumber from customers join payments on payments.customerNumber=customers.customerNumber;
declare continue handler for not found set hayFilas = 0;
open recorrer;
bucle:loop
fetch recorrer into sales, customerNumber1;
if hayFilas = 0 then
leave bucle;
end if;
 
select sum(amount) into plata from payments join customers on customers.customerNumber=payments.customerNumber where payments.customerNumber=customerNumber1;
if plata>100000
then 
set comision=plata+plata*0.5;
else if plata between 99999 and 50000
then
set comision=plata+plata*0.3;
else
set comision=plata;
end if;
end if;
 
end loop bucle;
close recorrer;
end//
delimiter ;


#-----------Ejercicio 14-----------:
delimiter //
create procedure asignarEmpleados()
begin
	declare idCliente int;
	declare idEmpleado int;
	declare terminado int default 0;
	declare cursorClientes cursor for
		select customerNumber from customers where salesRepEmployeeNumber is null;
	declare continue handler for not found set terminado = 1;

	open cursorClientes;

	loopClientes: loop
		fetch cursorClientes into idCliente;
		if terminado = 1 then
			leave loopClientes;
		end if;

		select employeeNumber
		into idEmpleado
		from employees
		left join (
			select salesRepEmployeeNumber, count(*) as totalClientes
			from customers
			where salesRepEmployeeNumber is not null
			group by salesRepEmployeeNumber
		) as cantidadClientes
		on employees.employeeNumber = cantidadClientes.salesRepEmployeeNumber
		order by ifnull(totalClientes, 0)
		limit 1;

		update customers set salesRepEmployeeNumber = idEmpleado where customerNumber = idCliente;
	end loop;

	close cursorClientes;
end //
delimiter ;

call asignarEmpleados();
