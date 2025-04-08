-- 1
delimiter //
create function proveedorFrecuente(idProveedor int) returns text deterministic
begin
	declare cantProv int default 0;
	declare cantProd int default 0;
	select count(*) into cantProv from ingresostock where Proveedor_idProveedor = idProveedor;
    select count(*) into cantProd from ingresostock where fecha > "2020-01-01";
    if (cantProv >= (cantProd*0.05)) then return "es frecuente";
    else return "no es frecuente";
    end if;
end //
delimiter ;
select proveedorFrecuente(2);
-- 2
delimiter $$
create function precioAvg(idProducto int) returns float deterministic
begin
	declare promedio float default 0;
	select avg(precio) into promedio from producto where idProducto = codProducto;
    return promedio;
end $$
delimiter ;
select precioAvg(1);
