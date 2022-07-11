-- =============================================
-- Author:		Armando Villavicencio
-- Create date: 30/03/2022
-- Description:	<Description,,>
-- =============================================
create PROCEDURE Summary_Indicadores

AS
BEGIN
	truncate table Indicadores_Summary
declare @lengConsultas int , 
@consulta varchar(max), 
@IdServer INT ,
@IdServer_Conexion VARCHAR(max),
@Indicador_Name VARCHAR(250),
@BDConexion VARCHAR(250),
@Indicador VARCHAR(250),
@Indicador_ID INT,
@Indicador_Rango INT,
@N INT=1,
@TipoIndicador INT =1 -- 1 - tabla de transicion (status_log, status_logfuel,status_logtemperature ... etc)
set @lengConsultas = (select count(*) from Indicadores WHERE TipoIndicador = 1 ) + 1
	
	--SELECT  @lengConsultas
		while (@N<@lengConsultas )
		BEGIN
			SET @IdServer =  (SELECT i.ServidorId FROM Indicadores i  WHERE i.Id= @N AND  i.Activo = 1 AND i.ServidorId  <> 9 AND TipoIndicador = 1)
			SET @BDConexion =  (SELECT i.BDConexion FROM Indicadores i  WHERE i.Id= @N AND  i.Activo = 1 AND i.ServidorId  <> 9 AND TipoIndicador = 1)
			SET @Indicador =  (SELECT i.Indicador FROM Indicadores i  WHERE i.Id= @N AND  i.Activo = 1 AND i.ServidorId  <> 9 AND TipoIndicador = 1)
			SET @Indicador_Rango =  (SELECT i.RangoEvaluacion FROM Indicadores i  WHERE i.Id= @N AND  i.Activo = 1 AND i.ServidorId  <> 9 AND TipoIndicador = 1)
			SET @Indicador_ID =  (SELECT i.id FROM Indicadores i  WHERE i.Id= @N AND  i.Activo = 1 AND i.ServidorId  <> 9 AND TipoIndicador = 1)
			SET @IdServer_Conexion =  (SELECT s.nombre FROM Indicadores i  INNER JOIN servidor s ON i.ServidorId = s.id WHERE i.Id= @N AND  i.activo = 1 AND i.ServidorId <> 9 AND TipoIndicador = 1)
		--	SELECT @IdServer IdServer,@BDConexion BDConexion,@Indicador Indicador,@Indicador_Rango Indicador_Rango,@Indicador_ID Indicador_ID,@IdServer_Conexion IdServer_Conexion
				SET @consulta = '
				insert into Indicadores_Summary (DateServer,DateInfo,ServidorId,IndicadorId,Verificacion,Descripcion)
				SELECT top 1 GETDATE() AS DateServer ,dateadd(hour,-6,GETDATE()) AS DateInfo ,
				'+CONVERT(VARCHAR(max),@IdServer)+' AS ServidorId ,
				'+CONVERT(VARCHAR(max),@Indicador_ID)+'  AS IndicadorId ,  
				CASE
				WHEN max(dategps) > DATEADD(MINUTE,-'+CONVERT(VARCHAR(max),@Indicador_Rango)+' ,GETDATE())
				THEN 1 ELSE 0 END  AS Verificacion,
				CASE
				WHEN max(dategps) > DATEADD(MINUTE,-'+CONVERT(VARCHAR(max),@Indicador_Rango)+',GETDATE())
				THEN ''Los datos estan sincronizados''
				ELSE ''Los datos ['+CONVERT(VARCHAR(max),@IdServer_Conexion)+'].['+CONVERT(VARCHAR(max),@BDConexion)+'].[dbo].['+CONVERT(VARCHAR(max),@Indicador)+'] no estan sincronizados, la ultima insercción fue ''+convert(varchar(100),dategps,120)+''.'' 
				END AS Descripcion
				FROM ['+CONVERT(VARCHAR(max),@IdServer_Conexion)+'].['+CONVERT(VARCHAR(max),@BDConexion)+'].[dbo].['+CONVERT(VARCHAR(max),@Indicador)+']
				group by dategps order by dategps desc '
				--SELECT @consulta
				exec(@consulta)
			set @N=@N+1
		end
--  SELECT top 1 GETDATE() AS DateInfo ,4 AS ServidorId ,1 AS IndicadorId ,  CASE  WHEN max(dategps) > DATEADD(MINUTE,-65,GETDATE())  THEN 1 ELSE 0 END  AS Verificacion,  CASE  WHEN max(dategps) > DATEADD(MINUTE,-65,GETDATE())  THEN 'Los datos estan sincronizados'  ELSE 'Los datos no estan sincronizados , la ultima insercción fue '+convert(varchar(100),dategps,120)+'.'   END AS Descripcion  FROM [10.0.0.9].[FleetManager].[dbo].status_log  group by dategps order by dategps desc 

--SELECT  * FROM Indicadores_Summary
SELECT  iss.DateInfo,s.nombre AS Servidor,i.Indicador,iss.Verificacion,iss.Descripcion FROM Indicadores_Summary iss
INNER JOIN Indicadores i ON [iss].IndicadorId = i.Id
INNER JOIN servidor s ON  iss.ServidorId = s.Id


END
