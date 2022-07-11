CREATE PROCEDURE insertRpteServer 
@nombre varchar(60),
@servidor int,
@horalocal varchar(15),
@horaserver varchar(15),
@company varchar(25),
@periodicidad int, 
@ubicacion varchar(200),
@registro varchar(200),
@plataforma int, 
@descripcion varchar(200),
@activo int

AS BEGIN

insert into ReportesServer (Nombre,	Servidor, HoraLocal, HoraServidor, Company, Periodicidad, Ubicacion, Registro, Plataforma, Descripcion, Activo)
values (@nombre,@servidor,@horalocal,@horaserver,@company,@periodicidad,@ubicacion,@registro,@plataforma,@descripcion,@activo)


select * from ReportesServer order by idreporte desc

END