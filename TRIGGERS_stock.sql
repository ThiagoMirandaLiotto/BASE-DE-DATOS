#-------------1-------------:
delimiter //
create trigger ejercicio1 after insert on pedido_producto
for each row
begin
	update ingresostock_producto set cantidad = cantidad - new.cantidad
    where Producto_codProducto = new.Producto_codProducto;
end//
delimiter ;

#-------------2-------------:
delimiter //
create trigger ejercicio2 before delete on ingresostock
for each row
begin
	delete from ingresostock_producto 
    where IngresoStock_idIngreso = old.idIngreso;
end//
delimiter ;

#-------------3-------------:
delimiter // 
create trigger ejercicio3 after insert on pedido
for each row
begin
	declare monto_total_gastado int;
    set monto_total_gastado = (select sum(precioUnitario*cantidad) from pedido_producto
    join pedido on Pedido_idPedido = idPedido where Cliente_codCliente = new.Cliente_codCliente and datediff(current_date(), fecha) < 730);

	if monto_total_gastado > 100000 then
		update cliente set categoria = "oro" where codCliente = new.Cliente_codCliente;
	else if monto_total_gastado > 50000 then
		update cliente set categoria = "plata" where codCliente = new.Cliente_codCliente;
	else
		update cliente set categoria = "bronce" where codCliente = new.Cliente_codCliente;
	end if;
    end if;
end//
delimiter ;

#-------------4-------------;
delimiter //
create trigger ejercicio4 after insert on ingresostock_producto
for each row
begin
	update producto set stock = stock + new.cantidad where codProducto = new.Producto_codProducto;
end//
delimiter ;