USE db_fotoestudio;

SELECT * FROM Cliente;
SELECT * FROM Paquete;
SELECT * FROM Producto;
SELECT * FROM DetallePaquete;
SELECT * FROM Reserva;
SELECT * FROM Pago;


-- INSERTAR DATOS A LA TABLA CLIENTE
INSERT INTO Cliente VALUES (1,'Wilfredo', 'Yelma','73312448','7210049 TJ', 'M', 'wilfred.yelma@gmail.com', 'Plan 4  mil, calle 8','Nuevo' );
INSERT INTO Cliente VALUES (2,'Diego', 'Flores','75819852','6715826 SCZ', 'M', 'digoF@gmail.com', 'Plan 4  mil, calle 24','Nuevo' );
INSERT INTO Cliente VALUES (3,'Laura', 'Mendoza','6712447','7581556 SCZ', 'F', 'lau@gmail.com', '3er Anillo, calle 24','Nuevo' );
INSERT INTO Cliente VALUES (4,'Graciela', 'Lijeron','77254868','10525856 CBB', 'F', 'graciela@gmail.com', 'Av. Pirai calle 9, nro 25','Antiguo' );

-- INSERTAR DATOS A LA TABLA PAQUETE
INSERT INTO Paquete (CodigoPaquete, NombrePaquete, Descripcion, PrecioPaquete, TipoPaquete, Estado) VALUES('PC01', 'Cumpleaño infantil', 'Fotografia', 800, 'Básico', 'A');
INSERT INTO Paquete (CodigoPaquete, NombrePaquete, Descripcion, PrecioPaquete, TipoPaquete, Estado) VALUES('PB02', 'Boda', 'Fotografia', 1500, 'Standart', 'A');
INSERT INTO Paquete (CodigoPaquete, NombrePaquete, Descripcion, PrecioPaquete, TipoPaquete, Estado) VALUES('PQ01', 'Quince Años', 'Fotografia y video', 1000, 'Básico', 'A');

-- INSERTAR DATOS A LA TABLA RESERVA
INSERT INTO Reserva (IdCliente,IdPaquete, FechaEntrada ,FechaEvento, PrecioTotal, Saldo, Estado) VALUES(1, 1,'2021-11-29', '2021-12-28', 800, 800, 'Inactiva');
INSERT INTO Reserva (IdCliente,IdPaquete, FechaEntrada ,FechaEvento, PrecioTotal, Saldo, Estado) VALUES(2, 3,'2021-12-5', '2022-01-28', 1500, 1500, 'Inactiva');

-- INSERTAR DATOS A LA TABLA PAGO
INSERT INTO Pago (Fecha, IdReserva, Monto, Descripcion, TipoPago) VALUES  ('2021-12-1',1,400, 'Adelanto de reserva cumple','Efectivo');
INSERT INTO Pago (Fecha, IdReserva, Monto, Descripcion, TipoPago) VALUES  ('2021-12-5',2,700, 'Adelanto de reserva Boda','Efectivo');

-- INSERTAR DATOS A LA TABLA PRODUCTO
INSERT INTO Producto (Nombre, Descripcion, PrecioUnitario) VALUES  ('Foto impresa 10x15','papel mate',2.5);
INSERT INTO Producto (Nombre, Descripcion, PrecioUnitario) VALUES  ('Foto impresa 13x18','papel mate',4.5);
INSERT INTO Producto (Nombre, Descripcion, PrecioUnitario) VALUES  ('Foto Digital','retocada',5.5);
INSERT INTO Producto (Nombre, Descripcion, PrecioUnitario) VALUES  ('Album fotografico 10x15','para 100 fotos',70);
INSERT INTO Producto (Nombre, Descripcion, PrecioUnitario) VALUES  ('Album fotografico 13x18','para 100 fotos',150);
INSERT INTO Producto (Nombre, Descripcion, PrecioUnitario) VALUES  ('Cuadro Acrilico','Tamaño 30x45',150);

-- INSERTAR DATOS A LA TABLA DETALLEPAQUETE
INSERT INTO DetallePaquete  VALUES  (1,1,50, 125);
INSERT INTO DetallePaquete  VALUES  (1,3,80, 440);
INSERT INTO DetallePaquete  VALUES  (1,4,1, 70);
INSERT INTO DetallePaquete  VALUES  (1,6,1, 150);

INSERT INTO DetallePaquete  VALUES  (2,2,80, 360);
INSERT INTO DetallePaquete  VALUES  (2,3,80, 440);
INSERT INTO DetallePaquete  VALUES  (2,5,1, 150);
INSERT INTO DetallePaquete  VALUES  (2,6,3, 450);


-- ==============================================================================================
-- → PROCEDIMIENTO ALMACENADO PARA MODIFICAR FECHA DE RESERVA;

delimiter //
CREATE PROCEDURE modificarFechaEvento_deReserva(in id int, nuevaFecha date)
begin
Update Reserva set FechaEvento = nuevaFecha where IdReserva = id;
end//
delimiter ;

-- LLAMAMOS AL PROCEDIMIENTO:
call modificarFechaEvento_deReserva(1, '2022-01-10');
select *from reserva;

-- --------------------→ TRIGGER ACTUALIZAR EL SALDO  y ESTADO DE RESERVA CUANDO SE INSERTE UN PAGO DE RESERVA 
DELIMITER //
CREATE TRIGGER Trigger_ActualizarSaldoReserva AFTER INSERT ON Pago
FOR EACH ROW BEGIN
Update Reserva set Saldo = Saldo - New.Monto, Estado='Activa' where IdReserva = New.IdReserva;
END//
DELIMITER ;

-- -------------------VISTA PAGOS DE RESERVAS:
CREATE VIEW vista_reservas AS
SELECT r.IdReserva AS N°RESERVA, c.IdCliente AS COD_CLIENTE, c.Nombre AS NOMBRE_CLIENTE, c.Apellido AS APELLIDO,
p.IdPaquete AS N°PAQUETE, p.NombrePaquete AS PAQUETE, p.Descripcion AS DESCRIPCION, p.TipoPaquete AS TIPO, r.FechaEntrada AS FECHA_ENTRADA, r.FechaEvento AS FECHA_EVENTO, 
r.PrecioTotal AS TOTAL, r.Saldo AS SALDO, r.Estado AS ESTADO 
FROM Reserva r 
INNER JOIN Cliente c ON r.IdCliente= c.IdCliente 
INNER JOIN Paquete p ON r.IdPaquete = p.IdPaquete; 

-- LLAMAMOS A LA VISTA
SELECT * FROM vista_reservas;
