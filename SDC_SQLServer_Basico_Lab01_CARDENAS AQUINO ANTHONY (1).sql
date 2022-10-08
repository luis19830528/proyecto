/*
CREAR UNA BASE DE DATOS
*/


-- LOS ARCHIVOS SE GUARDAN EN GRUPOS A EXCEPCION DEL LOG

xp_create_subdir 'C:\Hotel'
go
xp_create_subdir 'F:\Datos\Hotel\Facturacion'
GO
CREATE database HOTEL
    on PRIMARY
    (NAME = 'Hotel01', FILENAME ='C:\Hotel\Hotel01.mdf',
    SIZE =20MB, MaxSize = 20GB , filegrowth =100MB),
    (NAME = 'Datos02', filename ='F:\Datos\Hotel\Datos02.ndf', Size = 30MB),

FILEGROUP FACTURACION
    (Name ='Reservas', filename = 'F:\Datos\Hotel\Facturacion\Reservas.ndf', filegrowth=50%),
    (Name ='Ventas', filename = 'F:\Datos\Hotel\Facturacion\Ventas.ndf', filegrowth=50%),
FILEGROUP PERSONAL
    (Name = 'Personal',filename = 'F:\Datos\Hotel\Facturacion\Personal.ndf', filegrowth = 50%, Size =100MB)
Log ON
    (Name = 'EscritorioSQL', filename = 'C:\Hotel\EscritorioSQL.ldf',Size =200MB)
 
go

use HOTEL
go
Create schema FACTURACION
go
Create schema RESERVAS
go
CREATE TABLE RESERVAS.USUARIO(
cod_usuario int primary key,
Dni varchar(10) not null unique,
Paterno varchar(50) not null,
Materno varchar(50) not null,
Nombres varchar(50) not null,
fec_nac date		not null,
password varchar(100)
)
go
INSERT INTO RESERVAS.USUARIO(cod_usuario,Dni,Paterno,Materno,Nombres,fec_nac,password)
	VALUES(1,'47455090','Cardenas','Aquino','Anthony','11-16-1992','123456')
	go
INSERT INTO RESERVAS.USUARIO(cod_usuario,Dni,Paterno,Materno,Nombres,fec_nac,password)
	VALUES(2,'47855090','Casas','Revilla','Paola','10-10-1990','123456')
	go
INSERT INTO RESERVAS.USUARIO(cod_usuario,Dni,Paterno,Materno,Nombres,fec_nac,password)
	VALUES(3,'46455090','Mendez','Barrientos','Janeth','10-16-1990','123456')
	go

CREATE TABLE RESERVAS.TipoHabitacion(
cod_tipo int primary key,
descripcion varchar(20)
check (descripcion = 'VIP' or descripcion = 'BASICA') not null
);
INSERT INTO RESERVAS.TipoHabitacion(cod_tipo,descripcion)
	VALUES (1,'VIP')
	go
INSERT INTO RESERVAS.TipoHabitacion(cod_tipo,descripcion)
	VALUES (2,'VIP')
	go
INSERT INTO RESERVAS.TipoHabitacion(cod_tipo,descripcion)
	VALUES (3,'BASICA')
	go
CREATE TABLE FACTURACION.Cliente(
cod_cliente int primary key,
Dni varchar(10) not null unique,
Paterno varchar(50) not null,
Materno varchar(50) not null,
Nombres varchar(50) not null,
fec_nac date		not null
)
go
select * from reservas.TipoHabitacion
INSERT INTO FACTURACION.Cliente(cod_cliente,Dni,Paterno,Materno,Nombres,fec_nac)
	VALUES(1,'98512457','zevallos','valencia','yudith','10-10-1990');
	INSERT INTO FACTURACION.Cliente(cod_cliente,Dni,Paterno,Materno,Nombres,fec_nac)
	VALUES(2,'98512456','ventura','grimaldina','iraida','10-10-1990');
	INSERT INTO FACTURACION.Cliente(cod_cliente,Dni,Paterno,Materno,Nombres,fec_nac)
	VALUES(3,'98512455','soto','torres','carlos','10-10-1990');

CREATE TABLE RESERVAS.Reserva(
cod_reserva int primary key,
cod_usuario int foreign key references RESERVAS.USUARIO(cod_usuario),
cod_cliente int foreign key references FACTURACION.CLIENTE(cod_cliente),
fecha date check (fecha >= getdate())
)
go
INSERT INTO RESERVAS.Reserva(cod_reserva,cod_usuario,cod_cliente,fecha)
	VALUES(1,1,1,'11-11-2022');
	INSERT INTO RESERVAS.Reserva(cod_reserva,cod_usuario,cod_cliente,fecha)
	VALUES(2,2,1,'11-12-2022');
	INSERT INTO RESERVAS.Reserva(cod_reserva,cod_usuario,cod_cliente,fecha)
	VALUES(3,1,1,'11-12-2022');

CREATE TABLE RESERVAS.Habitacion(
cod_Habitacion int primary key,
cod_tipo int foreign key references RESERVAS.TipoHabitacion(cod_tipo),
descripcion varchar(20) not null unique
)
go

insert into RESERVAS.Habitacion(cod_Habitacion,cod_tipo,descripcion)
values(1,1,'habitacion 1');
insert into RESERVAS.Habitacion(cod_Habitacion,cod_tipo,descripcion)
values(2,2,'habitacion 2');
insert into RESERVAS.Habitacion(cod_Habitacion,cod_tipo,descripcion)
values(3,3,'habitacion 3');

CREATE TABLE RESERVAS.ReservaHabitacion(
cod_reservaHabitacion int primary key,
cod_reserva int foreign key references RESERVAS.Reserva(cod_reserva),
cod_habitacion int foreign key references RESERVAS.Habitacion(cod_habitacion),
)
go

insert into RESERVAS.ReservaHabitacion (cod_reservaHabitacion,cod_reserva,cod_habitacion)
values(1,1,1);
insert into RESERVAS.ReservaHabitacion (cod_reservaHabitacion,cod_reserva,cod_habitacion)
values(2,1,1);
insert into RESERVAS.ReservaHabitacion (cod_reservaHabitacion,cod_reserva,cod_habitacion)
values(3,1,1);

CREATE TABLE FACTURACION.Servicio(
cod_Servicio int primary key,
Concepto varchar(50) default 'Habitacion' not null
)
go

insert into FACTURACION.Servicio (cod_Servicio)
values(1);
insert into FACTURACION.Servicio (cod_Servicio)
values(2);
insert into FACTURACION.Servicio (cod_Servicio)
values(3);

CREATE TABLE FACTURACION.Factura(
cod_factura int primary key,
cod_cliente int foreign key references FACTURACION.Cliente(cod_cliente),
Concepto varchar(50)  not null,
fecha datetime check (fecha >= getdate())
)
go
insert into FACTURACION.Factura(cod_factura,cod_cliente,Concepto,fecha)
values(1,2,'servicio habitacion','11-11-2022');
insert into FACTURACION.Factura(cod_factura,cod_cliente,Concepto,fecha)
values(2,2,'servicio habitacion','11-11-2022')
insert into FACTURACION.Factura(cod_factura,cod_cliente,Concepto,fecha)
values(3,2,'servicio habitacion','11-11-2022')

CREATE TABLE FACTURACION.FacturaDetalle(
cod_FacturaDetalle int primary key,
cod_servicio int foreign key references FACTURACION.Servicio(cod_servicio),
cod_factura int foreign key references FACTURACION.Factura(cod_factura),
cantidad int check(cantidad > 0) not null
)
go

insert into FACTURACION.FacturaDetalle(cod_FacturaDetalle,cod_servicio,cod_factura,
cantidad)
values(1,1,1,1);
insert into FACTURACION.FacturaDetalle(cod_FacturaDetalle,cod_servicio,cod_factura,
cantidad)
values(2,1,1,3);
insert into FACTURACION.FacturaDetalle(cod_FacturaDetalle,cod_servicio,cod_factura,
cantidad)
values(3,1,1,5);
insert into FACTURACION.FacturaDetalle(cod_FacturaDetalle,cod_servicio,cod_factura,
cantidad)
values(4,1,1,10);