#-------------1-------------:
delimiter //
create event ejercicio1 on schedule EVERY 1 DAY do
begin
	update orders set status = "Delayed" where status = "In Process" and current_date() > shippedDate;
end//
delimiter ;

#-------------2-------------:
delimiter //
create event ejercicio2 on schedule EVERY 1 MONTH do
begin
	delete from payments where datediff(current_date(), paymentDate)/365 > 5;
end//
delimiter ;

#-------------3-------------:
delimiter //
create event ejercicio3 on schedule EVERY 1 MONTH ends now() + interval 1 YEAR do
begin
	declare clientes int;
    update customer set creditLimit = creditLimit*1.1 where
    customerNumber in (select customerNumber from orders where count(*) > 10 and
	datediff(current_date(), paymentDate) < 365 group by customerNumber);
    
end//
delimiter ;
