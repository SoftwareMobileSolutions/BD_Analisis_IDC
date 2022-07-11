-- =============================================
-- Author:		ARMANDO VILLAVICENCIO
-- Create date: 18-04-2022
-- Description:	Summary de jobs diarios
-- =============================================
--EXEC BI_ObtenerSummaryJobs
CREATE PROCEDURE [dbo].[BI_ObtenerSummaryJobs]
AS
BEGIN
			SELECT  DISTINCT  js.DateInfo,s.nombre AS 'Servidor',s.descripcion AS 'Descripcion de servidor ',j.nombre AS 'Job',
			js.Run_Status AS  Run_Status,CONVERT(TIME,js.RunDuration) AS RunDuration,
			((datepart(hour,js.RunDuration)*60) + (datepart(minute,js.RunDuration))) AS TotalMinutosEjecucion,
			((datepart(MINUTE,js.RunDuration)*60) + (datepart(SECOND,js.RunDuration))) AS TotalSegundosEjecucion,
			(j.promedioEjecucion/60) AS PromedioMinutos,j.promedioEjecucion AS PromedioSegundos,
			(((datepart(hour,js.RunDuration)*60) + (datepart(minute,js.RunDuration))) - (j.promedioEjecucion/60))  AS VarianzaMinutos,
			(((datepart(MINUTE,js.RunDuration)*60) + (datepart(SECOND,js.RunDuration))) - j.promedioEjecucion)  AS VarianzaSegundos,

			js.Mensaje, CASE WHEN js.step_name = '(Resultado del Jobs)' THEN 'Consolidado' ELSE 'Detalle' END AS 'Tipo Job',js.step_name
			FROM jobs_summary js 
			INNER JOIN servidor s ON js.serverid = s.id 
			INNER JOIN jobs j ON  j.jobid = js.jobid
			WHERE	js.DateInfo > DATEADD(DAY,-1,GETDATE())

		
			--DECLARE @fechainicio DATETIME
			--SET @fechainicio = DATEADD(hh,DATEPART(hh,getdate())*-1,getdate())
			--SET @fechainicio = DATEADD(mi,DATEPART(mi,getdate())*-1,@fechainicio)
			--SET @fechainicio = DATEADD(ss,DATEPART(ss,getdate())*-1,@fechainicio)
			--SET @fechainicio = DATEADD(ms,DATEPART(ms,getdate())*-1,@fechainicio)
			----SELECT * FROM jobs j
			--SELECT DISTINCT  js.DateInfo,''+CONVERT(varchar(50),s.nombre)+'' AS 'Servidor',s.descripcion AS 'Descripcion de servidor ',j.nombre AS 'Job',
			----CASE WHEN js.Run_Status = 'succeded' THEN 'Exito' ELSE 'Error'END AS Run_Status,
			--js.Run_Status  AS Run_Status,
			--CONVERT(TIME,js.RunDuration) AS RunDuration,
			--js.Mensaje
			--FROM jobs_today js
			--INNER JOIN servidor s ON js.serverid = s.id 
			--INNER JOIN jobs j ON  j.jobid = js.JobId
			--WHERE js.DateInfo  = @fechainicio-- AND js.Run_Status = 'failed'
			----AND j.ServerId = 2
END

