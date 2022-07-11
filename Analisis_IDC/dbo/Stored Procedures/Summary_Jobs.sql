-- =============================================
-- Author:		ARMANDO VILLAVICENCIO
-- Create date: 19-03-2022
-- Description:	Summary de jobs diarios
-- =============================================
--exec Summary_Jobs
--SELECT * FROM jobs_today jt
CREATE PROCEDURE [dbo].[Summary_Jobs]
AS
BEGIN
SET LANGUAGE 'Spanish'
			declare @lengConsultas int , @consulta varchar(max), @IdServer INT ,@IdServer_Conexion VARCHAR(max),@jobName VARCHAR(max), @jobId INT
			declare  @consulta14 varchar(max), @IdServer14 INT ,@IdServer_Conexion14 VARCHAR(max),@jobName14 VARCHAR(max), @jobId14 INT
			DECLARE @fechainicio DATETIME
			SET @fechainicio = DATEADD(hh,DATEPART(hh,getdate())*-1,getdate())
			SET @fechainicio = DATEADD(mi,DATEPART(mi,getdate())*-1,@fechainicio)
			SET @fechainicio = DATEADD(ss,DATEPART(ss,getdate())*-1,@fechainicio)
			SET @fechainicio = DATEADD(ms,DATEPART(ms,getdate())*-1,@fechainicio)
			set @lengConsultas = (select count(*) from jobs ) + 1
			declare @N INT=1

			while (@N<@lengConsultas )
			begin
			SET @IdServer =  (SELECT j.serverid FROM jobs j WHERE j.jobid = @N AND  j.activo = 1 AND j.serverid <> 9)
			SET @jobName =  (SELECT j.nombre FROM jobs j WHERE j.jobid = @N AND  j.activo = 1 AND j.serverid <> 9)
			SET @jobId =  (SELECT j.jobid FROM jobs j WHERE j.jobid = @N AND  j.activo = 1 AND j.serverid <> 9)
			SET @IdServer_Conexion =  (SELECT s.nombre FROM jobs j  INNER JOIN servidor s ON j.serverid = s.id WHERE j.jobid = @N AND  j.activo = 1 AND j.serverid <> 9)

			--SET @consulta = 'select '+CONVERT(VARCHAR(max),@IdServer)+','+CONVERT(VARCHAR(max),@IdServer_Conexion)+','+CONVERT(VARCHAR(max),@jobName)+''+CONVERT(VARCHAR(max),@jobId)+''
			SET @consulta ='SET LANGUAGE ''Spanish'' IF EXISTS (SELECT * FROM jobs_summary WHERE ServerId = 4 AND JobId = 1 AND DateInfo ='''+CONVERT(VARCHAR(max),@fechainicio)+''' ) 
			DELETE jobs_summary WHERE ServerId ='+CONVERT(VARCHAR(max),@IdServer)+' AND JobId = '+CONVERT(VARCHAR(max),@jobId)+' AND DateInfo ='''+CONVERT(VARCHAR(max),@fechainicio)+''' 
			INSERT INTO jobs_summary (Stepid,Mensaje,Step_Name,DateInfo,RunDuration,Run_Status,ServerId,JobId) select step_id,message,case when a.step_name = ''(Job outcome)'' then''(Resultado del Jobs)'' when a.step_name = ''(Resultado de trabajo)'' then''(Resultado del Jobs)'' else a.step_name end as step_name ,convert(datetime, convert(char(8), run_date), 112), 
			case  len(run_duration) 
			when  6 then left(convert(varchar(6), run_duration),2)+'':''+substring(convert(varchar(6), run_duration),3,2)+'':''+right(convert(varchar(6),run_duration),2)		
			when  5 then ''0''+left(convert(varchar(5), run_duration),1)+'':''+substring(convert(varchar(5), run_duration),2,2)+'':''+right(convert(varchar(6),run_duration),2)   		
			when  4 then ''00''+'':''+left(convert(varchar(4),run_duration),2)+'':''+right(convert(varchar(4),run_duration),2)			
			when  3 then ''00:0''+left(convert(varchar(3),run_duration),1)+'':''+right(convert(varchar(4),run_duration),2)				
			when 2 then ''00:00''+'':''+right(convert(varchar(4),run_duration),2)					
			when 1 then ''00:00:0''+right(convert(varchar(4),run_duration),2)
			else ''00:00:00'' end as ''run_duration'',	
			case Run_Status
			when 0 then ''Error''
			when  1 then ''Éxito''
			when 2 then ''Retry''
			when 3 then ''Canceled''
			end as ''run_status'','+CONVERT(VARCHAR(max),@IdServer)+','+CONVERT(VARCHAR(max),@jobId)+'
			from['+CONVERT(VARCHAR(max),@IdServer_Conexion)+'].msdb.dbo.sysjobhistory as a 
			left join ['+CONVERT(VARCHAR(max),@IdServer_Conexion)+'].msdb.dbo.sysjobs  as b
			on a.job_id = b.job_id 
			WHERE b.name = '''+CONVERT(VARCHAR(max),@jobName)+''' AND convert(datetime, convert(char(8), run_date), 112) ='''+CONVERT(VARCHAR(max),@fechainicio)+''' 
			order by run_date desc,step_id'
			/*-----------SE CORRE SOLO PARA EL SERVIDOR LOCAL-----*/
			SET @IdServer14 =  (SELECT j.serverid FROM jobs j WHERE j.jobid = @N AND  j.activo = 1 AND j.serverid = 9)
			SET @jobName14 =  (SELECT j.nombre FROM jobs j WHERE j.jobid = @N AND  j.activo = 1 AND j.serverid = 9)
			SET @jobId14 =  (SELECT j.jobid FROM jobs j WHERE j.jobid = @N AND  j.activo = 1 AND j.serverid = 9)
			SET @IdServer_Conexion14 =  (SELECT s.nombre FROM jobs j  INNER JOIN servidor s ON j.serverid = s.id WHERE j.jobid = @N AND  j.activo = 1 AND j.serverid = 9)

			
			SET @consulta14 ='SET LANGUAGE ''Spanish'' IF EXISTS (SELECT * FROM jobs_summary WHERE ServerId = 4 AND JobId = 1 AND DateInfo ='''+CONVERT(VARCHAR(max),@fechainicio)+''' ) 
			DELETE jobs_summary WHERE ServerId ='+CONVERT(VARCHAR(max),@IdServer14)+' AND JobId = '+CONVERT(VARCHAR(max),@jobId14)+' AND DateInfo ='''+CONVERT(VARCHAR(max),@fechainicio)+''' 
			INSERT INTO jobs_summary (Stepid,Mensaje,Step_Name,DateInfo,RunDuration,Run_Status,ServerId,JobId) select step_id,message,case when a.step_name = ''(Job outcome)'' then''(Resultado del Jobs)'' when a.step_name = ''(Resultado de trabajo)'' then''(Resultado del Jobs)'' else a.step_name end as step_name ,convert(datetime, convert(char(8), run_date), 112), 
			case  len(run_duration) 
			when  6 then left(convert(varchar(6), run_duration),2)+'':''+substring(convert(varchar(6), run_duration),3,2)+'':''+right(convert(varchar(6),run_duration),2)		
			when  5 then ''0''+left(convert(varchar(5), run_duration),1)+'':''+substring(convert(varchar(5), run_duration),2,2)+'':''+right(convert(varchar(6),run_duration),2)   		
			when  4 then ''00''+'':''+left(convert(varchar(4),run_duration),2)+'':''+right(convert(varchar(4),run_duration),2)			
			when  3 then ''00:0''+left(convert(varchar(3),run_duration),1)+'':''+right(convert(varchar(4),run_duration),2)				
			when 2 then ''00:00''+'':''+right(convert(varchar(4),run_duration),2)					
			when 1 then ''00:00:0''+right(convert(varchar(4),run_duration),2)
			else ''00:00:00'' end as ''run_duration'',	
			case Run_Status
			when 0 then ''Error''
			when  1 then ''Éxito''
			when 2 then ''Retry''
			when 3 then ''Canceled''
			end as ''run_status'','+CONVERT(VARCHAR(max),@IdServer14)+','+CONVERT(VARCHAR(max),@jobId14)+'
			from msdb.dbo.sysjobhistory as a 
			left join msdb.dbo.sysjobs  as b
			on a.job_id = b.job_id 
			WHERE b.name = '''+CONVERT(VARCHAR(max),@jobName14)+''' AND convert(datetime, convert(char(8), run_date), 112) ='''+CONVERT(VARCHAR(max),@fechainicio)+''' 
			order by run_date desc,step_id'



			--select @consulta
			exec(@consulta)
			exec(@consulta14)
			set @N=@N+1
			END
			TRUNCATE TABLE [jobs_today]
			INSERT INTO jobs_today ([Stepid],[Mensaje],[Step_Name],[DateInfo],[RunDuration],[Run_Status],[ServerId],[JobId])
			SELECT [Stepid],[Mensaje],[Step_Name],[DateInfo],[RunDuration],[Run_Status],[ServerId],[JobId] FROM jobs_summary js WHERE js.DateInfo = @fechainicio

			--=======================================EVALUACION DE PROMEDIOS DE TIEMPOS POR JOB (15 DIAS ATRAS) ============
			DECLARE @promedios TABLE (id INT IDENTITY(1,1),Consulta VARCHAR(500))
			declare @lengConsultas_PROM int , @consulta_PROM  varchar(max)
			declare @N_PROM  INT=1
				INSERT INTO @promedios(Consulta)
				SELECT  --j_.nombre,AVG(((datepart(hour,js_.RunDuration)*60) + (datepart(minute,js_.RunDuration)))) AS promedio,
				'update jobs set promedioEjecucion = '+CONVERT(VARCHAR(10),AVG(((datepart(HOUR,js_.RunDuration)*3600)+(datepart(MINUTE,js_.RunDuration)*60) + (datepart(SECOND,js_.RunDuration)))))+' where jobid = '+CONVERT(VARCHAR(10),j_.jobid)+'' AS consulta
				FROM jobs_summary js_
				INNER JOIN servidor s_ ON js_.serverid = s_.id 
				INNER JOIN jobs j_ ON  j_.jobid = js_.jobid 
				WHERE  js_.step_name = '(Resultado del Jobs)' AND js_.DateInfo > DATEADD(DAY,-15,GETDATE())-- AND j_.nombre ='MobileSummaryBlueFenyx'
				GROUP BY j_.nombre,j_.jobid
							
			set @lengConsultas_PROM  = (select count(*) from @promedios ) + 1
			while (@N_PROM <@lengConsultas_PROM  )
			begin
				SET @consulta_PROM = (SELECT Consulta FROM @promedios WHERE id = @N_PROM)
			exec(@consulta_PROM)
				set @N_PROM=@N_PROM+1
			end
			--==============================================================================================
			/*
			
			DECLARE @fechainicio DATETIME
			SET @fechainicio = DATEADD(hh,DATEPART(hh,getdate())*-1,getdate())
			SET @fechainicio = DATEADD(mi,DATEPART(mi,getdate())*-1,@fechainicio)
			SET @fechainicio = DATEADD(ss,DATEPART(ss,getdate())*-1,@fechainicio)
			SET @fechainicio = DATEADD(ms,DATEPART(ms,getdate())*-1,@fechainicio)
			--select fechainicio
			SELECT * FROM jobs_summary js WHERE js.DateInfo = @fechainicio
			SELECT js.DateInfo,s.nombre AS 'Servidor',s.descripcion AS 'Descripcion de servidor ',j.nombre AS 'Job',js.Run_Status,js.RunDuration,js.Mensaje FROM jobs_summary js
			INNER JOIN servidor s ON js.serverid = s.id 
			INNER JOIN jobs j ON  j.jobid = js.JobId
			WHERE js.DateInfo  = @fechainicio AND js.Run_Status = 'failed'
			*/
END
