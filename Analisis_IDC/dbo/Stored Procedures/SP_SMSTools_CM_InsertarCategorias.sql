CREATE PROCEDURE SP_SMSTools_CM_InsertarCategorias @categoria nvarchar(25),@descripcion nvarchar(100),@activo int
AS   
insert into SMSTools_CM_Categoria(Categoria, Descripcion,Activo) 
values (@categoria,@descripcion,@activo)