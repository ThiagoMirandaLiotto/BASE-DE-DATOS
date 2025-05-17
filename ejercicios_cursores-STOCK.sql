-- 1) Crear un Stored Procedure que actualice el stock de los productos teniendo ingresos
-- de esta semana. 
delimiter //
create procedure actuStock () 
BEGIN
    declare cant int;
    declare cod int;
    declare hayFilas boolean default 1;
    declare recorrer cursor for select codProducto from producto;
    declare continue handler for not found set hayFilas = 0;
    
    open recorrer;
    bucle:loop
        fetch recorrer into cod;
        if hayFilas = 0 then
            leave bucle;
        end if;
select cantidad into cant from ingresostock_producto join ingresostock on idIngreso=IngresoStock_idIngreso where Producto_codProducto=cod and fecha between current_date() and datediff(0-0-7,current_date());
update producto set stock=stock+cant where Producto_codProducto=codProducto;
 
end loop bucle;
close recorrer;
end//
delimiter ;
 

--2) Crear un Stored Procedure que reduzca el precio de los productos en un 10% si no se vendieron más de 100 unidades en la semana. 
delimiter //
create procedure actuPrecio () 
BEGIN
    declare cant int;
    declare cod int;
    declare hayFilas boolean default 1;
    declare recorrer cursor for select codProducto from producto;
    declare continue handler for not found set hayFilas = 0;
    
    open recorrer;
    bucle:loop
        fetch recorrer into cod;
        if hayFilas = 0 then
            leave bucle;
        end if;

    select cantidad into cant from pedido_producto join pedido on idPedido=Pedido_idPedido where Producto_codProducto=cod and fecha between current_date() and datediff(0-0-7,current_date());
    if cant < 100 then 
        update producto set precio = precio - (precio * 0,1) where codProducto = cod;
    end if;
    
    end loop bucle;
    close recorrer;
end//
delimiter ;

--3) Crear un Stored Procedure que actualice el precio de los productos. Debe ser un 10% más que el mayor precio al que lo proveen los proveedores. 
DELIMITER //
CREATE PROCEDURE actualizarPrecioDesdeProveedor()
BEGIN
  DECLARE cod INT;
  DECLARE maxPrecio DECIMAL(10,2);
  DECLARE fin BOOLEAN DEFAULT FALSE;
  DECLARE cursorProductos CURSOR FOR SELECT codProducto FROM producto;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

  OPEN cursorProductos;
  bucle: LOOP
    FETCH cursorProductos INTO cod;
    IF fin THEN
      LEAVE bucle;
    END IF;

    SELECT MAX(precio) INTO maxPrecio
    FROM producto_proveedor
    WHERE Producto_codProducto = cod;

    IF maxPrecio IS NOT NULL THEN
      UPDATE producto
      SET precio = maxPrecio * 1.10
      WHERE codProducto = cod;
    END IF;
  END LOOP bucle;
  CLOSE cursorProductos;
END //
DELIMITER ;

--4) Suponiendo que agregamos una columna llamada “nivel” en la tabla de proveedores, se pide realizar un procedimiento que calcule la cantidad de ingresos por proveedor en los últimos 2 meses y actualice el nivel del proveedor. Los niveles son “Bronce” hasta 50 ingresos inclusive, “Plata” de 50 a 100 ingresos inclusive y “Oro” más de 100. 
DELIMITER //
CREATE PROCEDURE actualizarNivelProveedores()
BEGIN
  DECLARE idProv INT;
  DECLARE cantIngresos INT;
  DECLARE fin BOOLEAN DEFAULT FALSE;
  DECLARE cursorProv CURSOR FOR SELECT idProveedor FROM proveedor;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;

  OPEN cursorProv;
  bucle: LOOP
    FETCH cursorProv INTO idProv;
    IF fin THEN
      LEAVE bucle;
    END IF;

    SELECT COUNT(*) INTO cantIngresos
    FROM ingresostock
    WHERE Proveedor_idProveedor = idProv
      AND fecha >= DATE_SUB(CURDATE(), INTERVAL 2 MONTH);

    IF cantIngresos <= 50 THEN
      UPDATE proveedor SET nivel = 'Bronce' WHERE idProveedor = idProv;
    ELSEIF cantIngresos <= 100 THEN
      UPDATE proveedor SET nivel = 'Plata' WHERE idProveedor = idProv;
    ELSE
      UPDATE proveedor SET nivel = 'Oro' WHERE idProveedor = idProv;
    END IF;
  END LOOP bucle;
  CLOSE cursorProv;
END //
DELIMITER ;

--5) Realice un procedimiento que actualice el precio unitario de los productos que están en pedidos pendientes de pago, al precio actual del producto.
DELIMITER //
CREATE PROCEDURE actualizarPreciosPedidosPendientes()
BEGIN
  UPDATE pedido_producto
  JOIN pedido ON pedido_producto.Pedido_idPedido = pedido.idPedido
  JOIN producto ON pedido_producto.Producto_codProducto = producto.codProducto
  JOIN estado ON pedido.Estado_idEstado = estado.idEstado
  SET pedido_producto.precioUnitario = producto.precio
  WHERE estado.nombre = 'Pendiente';
END //
DELIMITER ;
