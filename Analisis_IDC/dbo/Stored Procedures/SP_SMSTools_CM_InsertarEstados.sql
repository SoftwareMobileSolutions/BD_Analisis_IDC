CREATE PROCEDURE SP_SMSTools_CM_InsertarEstados @estado nvarchar(25),@descripcion nvarchar(100),@activo int
AS   
insert into SMSTools_CM_Estados (estado, descripcion, activo) 
values (@estado,@descripcion,@activo)