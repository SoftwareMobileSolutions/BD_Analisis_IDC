CREATE PROCEDURE SP_SMSTools_CM_InsertarProtocolos @protocolo nvarchar(25),@descripcion nvarchar(100),@idEstado int
AS   
insert into SMSTools_CM_Protocolos(nombreprotocolo, Descripcion, Activo) 
values (@protocolo,@descripcion,@idEstado)