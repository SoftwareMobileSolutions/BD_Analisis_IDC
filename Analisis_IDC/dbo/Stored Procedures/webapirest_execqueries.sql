-- ==============================
-- Fecha: 2022/04/01
-- Autor: José María Barrientos
-- Descripción: Genera las consultas dinámicas de los SP de 
-- ==============================

CREATE PROCEDURE webapirest_execqueries
  @idoperacion varchar(25),
  @parametros varchar(MAX)
AS
BEGIN
  DECLARE @iplocal VARCHAR(15) SET @iplocal = (SELECT CONVERT(varchar(15), CONNECTIONPROPERTY('local_net_address')))
  DECLARE @ip VARCHAR(15), @db VARCHAR(50), @user varchar(50), @pass varchar(50), @spname varchar(MAX)
  DECLARE @prefijoConexion VARCHAR(100) SET @prefijoConexion = ''
  DECLARE @query VARCHAR(MAX) = ''

  SELECT @ip =wr.ip, 
         @db = wr.db,
         @user = wr.[user],
         @pass = wr.pass,
         @spname = wro.sentencia
  FROM webapirest_route wr
  INNER JOIN webapirest_route_operaciones wro ON wro.idwroute = wr.idwroute
  WHERE wro.operacionid = @idoperacion

  IF (@iplocal <> @ip)
  BEGIN
    SET @prefijoConexion = '[' + @ip + '].'
  END
  SET @prefijoConexion += @db + '.dbo.'
  SET @query = 'exec ' + @prefijoConexion + @spname + ' ' + @parametros

  EXECUTE (@query)

END
-- EXEC webapirest_execqueries 'spdeprueba','20220404,20220404'

