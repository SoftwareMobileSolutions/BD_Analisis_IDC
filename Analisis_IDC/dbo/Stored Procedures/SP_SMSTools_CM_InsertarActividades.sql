CREATE PROCEDURE [dbo].[SP_SMSTools_CM_InsertarActividades] 
@nombre nvarchar(75),
@desc nvarchar(250),
@categoria int,
@periodicidad int,
@dias nvarchar(30),
@turno int,
@tiempo nvarchar(100), 
@correos nvarchar(250),
@activo INT

AS   
begin
	insert into SMSTools_CM_Actividades(NombreActivdad, Descripcion, idCategoria,Periodicidad,dias,Turno,TiempoEstimado,Correos,Activo) 
	values (@nombre,@desc,@categoria,@periodicidad,@dias,@turno,@tiempo,@correos,@activo)
end