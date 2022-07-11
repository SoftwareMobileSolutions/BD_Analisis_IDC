CREATE procedure SP_SMSTools_CM_InsertarRegistros @idUser int,@idActividad int, @dateserver datetime, @comentario nvarchar(1000),@company int, @idEstado int
as
insert into SMSTools_CM_Registros(idUser, idActividad,DateServer,Comentario,idCompany,idEstado)
values(@idUser,@idActividad,@dateserver,@comentario,@company,@idEstado)