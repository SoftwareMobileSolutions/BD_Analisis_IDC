-- =======================
-- Autor: José María Barrientos
-- Fecha: Permite obtener los usarios que tienen acceso a la web apirest
-- Descripción: Permite obtener si el usuario de la webapi posee acceso
-- =======================
CREATE PROCEDURE webapirest_getUserAccess
  @usuario varchar(50),
  @userkey varchar(512)
AS
BEGIN
  SELECT convert(bit, (SELECT count(*) FROM user_webapi WHERE usuario = @usuario AND userkey=@userkey)) resultado
END