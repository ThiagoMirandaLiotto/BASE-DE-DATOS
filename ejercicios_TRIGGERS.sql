#---------Ejercicio 1:---------#
create table customers_audit(
	idAudit int auto_increment not null primary key,
    operacion char(6),
    user varchar(45),
    last_date_modified date,
    
    customerNumber int,
    customerName varchar(50),
    phone int,
    city varchar(50),
    state varchar(50),
    postalCode varchar(15),
    country varchar(50),
    salesRepEmployeeNumber int
);



#------A)------#
delimiter //
create trigger after_insert_customers after insert on customers
for each row
begin
	insert into customers_audit values(NULL, "insert", current_user(), current_date(), new.customerNumber, new.customerName, new.phone, new.city, new.state, new.postalCode, new.country, new.salesRepEmployeeNumber);
end//
delimiter ;

insert into customers values (
  10003, 'Tech Solutions', 'González', 'María',
  '445566', 'Av. Corrientes 1234', 'Piso 4, Oficina 12',
  'Buenos Aires', 'CABA', 'C1043AAX',
  'Argentina', 1504, 50000.00);
select * from customers_audit;


#------B)------#
delimiter //
create trigger before_update_customers before update on customers
for each row
begin
	insert into customers_audit values(NULL, "update", current_user(), current_date(), old.customerNumber, old.customerName, old.phone, old.city, old.state, old.postalCode, old.country, old.salesRepEmployeeNumber);
end //
delimiter ;

UPDATE customers SET phone = '47875566', creditLimit = 75070.00 WHERE customerNumber = 10003;
select * from customers_audit;


#------C)------#
delimiter //
create trigger before_delete_customers before delete on customers
for each row
begin
	insert into customers_audit values(NULL, "delete", current_user(), current_date(), old.customerNumber, old.customerName, old.phone, old.city, old.state, old.postalCode, old.country, old.salesRepEmployeeNumber);
end //
delimiter ;

DELETE FROM customers
WHERE customerNumber = 10003;

select * from customers_audit;






#---------Ejercicio 2:---------#
create table employees_audit(
	idAudit int auto_increment not null primary key,
    operacion char(6),
    user varchar(45),
    last_date_modified date,
    
    employeeNumber int,
    lastName varchar(50),
    firstName varchar(50)
);


#------A)------#
delimiter //
create trigger after_insert_employees after insert on employees
for each row
begin
	insert into employees_audit values(NULL, "insert", current_user(), current_date(), new.employeeNumber, new.lastName, new.firstName);
end//
delimiter ;

insert into employees values
(15040, 'Pérez', 'Juan', 'x1234', 'juan.perez@empresa.com', '1', NULL, 'Sales Manager');

select * from employees_audit;


#------B)------#
delimiter //
create trigger before_update_employees before update on employees
for each row
begin
	insert into employees_audit values
    (NULL, "update", current_user(), current_date(), old.employeeNumber, old.lastName, old.firstName);
end//
delimiter ;

update employees set firstName = 'Carlos', lastName = 'Gómez' WHERE employeeNumber = 15040;

select * from employees_audit;


#------C)------#
delimiter //
create trigger before_delete_employees before delete on employees
for each row
begin
	insert into employees_audit values
    (NULL, "delete", current_user(), current_date(), old.employeeNumber, old.lastName, old.firstName);
end //
delimiter ;

delete from employees where employeeNumber = 15040;

select * from employees_audit;




#---------3---------#
delimiter //
create trigger before_delete_products before delete on products
for each row
begin
	if old.productCode 
    in(select productCode from orderdetails 
    join orders on orders.orderNumber = orderdetails.orderNumber
    where timestampdiff(month, current_date(), orderDate) < 2) then
		signal sqlstate '45000' set message_text = "Error, tiene ordenes asociadas";
	end if;
end //
delimiter ;

drop trigger before_delete_products;

select * from orderdetails;
select * from products;
select * from orders;
delete from products where productCode = "S18_2325";