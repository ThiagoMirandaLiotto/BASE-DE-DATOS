-- 1
delimiter //
create function esFrecuente(idCliente varchar(20)) returns text deterministic
begin

declare cantVentas int default 0;
declare cantCompras int default 0;

select count(*) into cantCompras from pedido where Cliente_codCliente = idCliente;
select count(*) into cantVentas from pedido where fecha >= "2005-01-01";

if (cantVentas/cantCompras >= (cantVentas*0.05)) then 
return "es frecuente";
else 
return "no es frecuente";
end if;

return frecuente;
end //

delimiter ;
select esFrecuente("1");





-- 2
delimiter %%
create function cantPedidos(idCliente varchar(20)) returns int deterministic
begin
declare cantidad int default 0;
select count(*) into cantidad from pedido join estado on Estado_idEstado = idEstado 
where Cliente_codCliente = idCliente and nombre = "Pendiente";
return cantidad;
end %%
delimiter ;
select cantPedidos("1");