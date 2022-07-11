-- =================================
-- Nombre: José María Barrientos
-- Fecha: 2022/03/28
-- Descripción: Permite obtener la conexión a una base de datos
-- =================================
CREATE
 PROCEDURE fleet_webapirest_route
AS
BEGIN
  select 
         wro.sentencia spname
        ,wro.cadenaconexion cn
  from webapirest_route_operaciones wro
END

--select * from webapirest_route_operaciones wro