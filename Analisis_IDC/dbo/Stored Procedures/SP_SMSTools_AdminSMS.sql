--exec SP_SMSTools_AdminSMS -1,1,2
--exec SP_SMSTools_AdminSMS '12200',-1,2,1
--exec SP_SMSTools_AdminSMS -1,2,1,0,'12200,121,3321,6516,61'
--exec SP_SMSTools_AdminSMS -1,2,1,'12200,121,3321,6516,61',1,0
--exec SP_SMSTools_AdminSMS -1,3,2,'12200,121,3321,6516,61',1,2
-- exec SP_SMSTools_AdminSMS 0,3,2,'12200,1',0,2
-- exec SP_SMSTools_AdminSMS 0,3,2,'12200',0,2,33,ArmandoVillavicencio
--exec SP_SMSTools_AdminSMS 0,3,2,'12200',0,3,'Armando prueba' ,21,ArmandoVillavicencio
--exec SP_SMSTools_AdminSMS 0,2,2,'12200',0,0,'Sin Observaciones',0,ArmandoVillavicencio
--exec SP_SMSTools_AdminSMS -1,1,1
--exec SP_SMSTools_AdminSMS 0,3,1,'3566',0,1,'PRUEBA ARMAND',14,'ArmandoVillavicencio'
CREATE PROCEDURE [dbo].[SP_SMSTools_AdminSMS] 
@companyid INT = -1,
@bandera INT, --  1--Obtener datos por compañia  -- 2 -- Actualizar Plan -- 3 -- Actualizar Estado -- -1 motivo de cambio de estado
@plataformaBandera INT,
@cadenaMobile VARCHAR(MAX) = NULL ,
@planid INT = null,
@estadoid  INT = NULL,
@observaciones  VARCHAR(max) = 'Sin Observaciones',
@motivoretiro INT  = 0 ,
@usuario VARCHAR(500) = ''

--UPDATE FM_Bluefenyx.dbo.mobile  SET [status] = 0 WHERE mobileid = 12200

-- SELECT  * FROM [10.0.0.4].FM_Bluefenyx.dbo.mobile WHERE mobileid = 12200
 --SELECT  * FROM [10.0.0.4].FM_Bluefenyx.dbo.MOBILE_LOG  ma WHERE mobileid = 12200
 --SELECT TOP 10   * FROM [10.0.0.5].FleetManager.dbo.MOBILE_LOG  ma ORDER BY ma.fecha_de_cambio  DESC 

/*
1	Demo
2	Activo
3	Inactivo
0	Nuevo ingreso
4	Reactivacion
*/
AS   
BEGIN
	IF  @bandera = -1 BEGIN
	
	SELECT motivoretiroid AS valor ,nombre AS texto FROM mobile_motivo_retiro ORDER BY  nombre
	end

	DECLARE @TablaMobile table ( ID int  IDENTITY(1,1) ,mobileid_Tab int )
	DECLARE @tbPlan table ( ID int  ,plan_Tab VARCHAR(3) )
	INSERT INTO @tbPlan (Id,plan_Tab)	SELECT 0,'A'
	INSERT INTO @tbPlan (Id,plan_Tab) SELECT 1,'B'
	INSERT INTO @tbPlan (Id,plan_Tab) SELECT 2,'C'
	INSERT INTO @tbPlan (Id,plan_Tab) SELECT 3,'CP'
	
	Insert into @TablaMobile
	SELECT  VALUE FROM  STRING_SPLIT(@cadenaMobile,',') 	

	IF @plataformaBandera = 1 
	BEGIN
		IF @bandera = 1 -- OBTENER DATOS POR COMPAÑIA
		BEGIN
				IF @companyid = -1 -- OBTENER DATOS POR COMPAÑIA
				BEGIN 
				
					SELECT  c.companyid,c.name AS compania,s.subfleetid,s.name as subflota,M.mobileid,M.name alias , M.plate,mst.name estado,M.make marca,M.model,moto.motoristaid,moto.nombre motorista,m.vin,m.yearmade,m.capacity,D.deviceid,D.name mdmid,d1.devicetypeid, d1.name devicetype,me.tipoPlan
					FROM [10.0.0.5].Fleetmanager.dbo.mobile m 
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.mobile_company mc ON m.mobileid = mc.mobileid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.device d ON m.deviceid = d.deviceid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.devicetype d1 ON d.devicetypeid = d1.devicetypeid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.mobile_subfleet ms ON m.mobileid = ms.mobileid 
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.subfleet s ON ms.subfleetid = s.subfleetid AND s.companyid = mc.companyid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.MobileEx me ON m.mobileid = me.mobileid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.company c ON s.companyid = c.companyid
					LEFT JOIN [10.0.0.5].Fleetmanager.dbo.mobile_motorista mm ON m.mobileid = mm.mobileid
					LEFT JOIN [10.0.0.5].Fleetmanager.dbo.motorista moto ON mm.motoristaid = moto.motoristaid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.mobile_status mst ON mst.mobilestatusid = M.status
					--WHERE c.companyid IS nu
					ORDER BY c.name
				END
				ELSE
				BEGIN 
					SELECT c.companyid,c.name  AS subflota,s.subfleetid,s.name as subflota,M.mobileid,M.name alias , M.plate,mst.name estado,M.make marca,M.model,moto.motoristaid,moto.nombre motorista,m.vin,m.yearmade,m.capacity,D.deviceid,D.name mdmid,d1.devicetypeid, d1.name devicetype,me.tipoPlan
					FROM [10.0.0.5].Fleetmanager.dbo.mobile m 
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.mobile_company mc ON m.mobileid = mc.mobileid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.device d ON m.deviceid = d.deviceid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.devicetype d1 ON d.devicetypeid = d1.devicetypeid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.mobile_subfleet ms ON m.mobileid = ms.mobileid 
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.subfleet s ON ms.subfleetid = s.subfleetid AND s.companyid = mc.companyid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.MobileEx me ON m.mobileid = me.mobileid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.company c ON s.companyid = c.companyid
					LEFT JOIN [10.0.0.5].Fleetmanager.dbo.mobile_motorista mm ON m.mobileid = mm.mobileid
					LEFT JOIN [10.0.0.5].Fleetmanager.dbo.motorista moto ON mm.motoristaid = moto.motoristaid
					INNER JOIN [10.0.0.5].Fleetmanager.dbo.mobile_status mst ON mst.mobilestatusid = M.status
					WHERE c.companyid = @companyid
					ORDER BY c.name
				END
		END
		ELSE IF @bandera = 2 -- Actualizar plan
		BEGIN
			--SELECT TipoPlan FROM [10.0.0.5].Fleetmanager.dbo.MobileEx WHERE mobileid = 12200
			--SELECT status FROM [10.0.0.5].Fleetmanager.dbo.mobile WHERE mobileid = 12200
			BEGIN  TRY
					DECLARE @lengConsultas int , @consulta varchar(max), @plan VARCHAR(3), @mobileid INT
					declare @N INT=1
					set @lengConsultas = (select count(mobileid_Tab) from @TablaMobile ) + 1	
					
							while (@N<@lengConsultas )
							BEGIN
							SET @plan = (SELECT plan_Tab FROM @tbPlan WHERE Id = @planid)
							SET @mobileid = (SELECT mobileid_Tab FROM @TablaMobile WHERE Id = @N)
						
							SET @consulta =  ('	UPDATE  [10.0.0.5].Fleetmanager.dbo.MobileEx  SET TipoPlan = '''+@plan+''' WHERE mobileid = '+CONVERT(varchar(15),@mobileid)+'')
							--select @consulta
								exec(@consulta)
								set @N=@N+1
								

							END
			SELECT 1
			END TRY
			BEGIN CATCH
			SELECT -1	
			END CATCH

		
--SELECT TOP 100 * FROM [10.0.0.5].Fleetmanager.dbo.mobile_log
--SELECT TOP 100 * FROM [10.0.0.5].Fleetmanager.dbo.mobile_motivo_retiro mmr ORDER BY nombre ASC 
		END ELSE IF @bandera = 3 -- Actualizar estado
		BEGIN
			BEGIN  TRY
				DECLARE @lengConsultas_Estado int , @consulta_Estado varchar(max), @mobileid_Estado INT
				declare @N_Estado INT=1					DECLARE @estadoid_Anterior int
				set @lengConsultas_Estado = (select count(mobileid_Tab) from @TablaMobile ) + 1		
				--SELECT @lengConsultas_Estado
					while (@N_Estado<@lengConsultas_Estado )
					BEGIN					
						SET @mobileid_Estado = (SELECT mobileid_Tab FROM @TablaMobile WHERE Id = @N_Estado)
							
						SET @estadoid_Anterior = (SELECT [STATUS] FROM [10.0.0.5].Fleetmanager.dbo.mobile WHERE mobileid = @mobileid_Estado)
						SET @consulta_Estado =  ('INSERT INTO [10.0.0.5].Fleetmanager.dbo.mobile_log (mobileid,estado_anterior,estado_nuevo,fecha_de_cambio,usuario,observaciones,motivoretiroid) 			
						VALUES ('+CONVERT(varchar(15),@mobileid_Estado)+','+CONVERT(varchar(15),@estadoid_Anterior)+','+CONVERT(varchar(15),@estadoid)+',getdate(),'''+@usuario+''','''+@observaciones+''','+CONVERT(varchar(15),@motivoretiro)+') 
						UPDATE  [10.0.0.5].Fleetmanager.dbo.mobile  SET [status] = '+CONVERT(varchar(15),@estadoid)+' WHERE mobileid = '+CONVERT(varchar(15),@mobileid_Estado)+'')
						--select @consulta_Estado
						exec(@consulta_Estado)
						set @N_Estado=@N_Estado+1
					END
			SELECT 1
			END TRY
			BEGIN CATCH
			SELECT -1	
			END CATCH
		END
	END
	ELSE	---==============================================================BLUEFENYX=========================================================
	BEGIN
		IF @bandera = 1 -- OBTENER DATOS POR COMPAÑIA
		BEGIN
				IF @companyid = -1 -- OBTENER DATOS POR COMPAÑIA
				BEGIN 
				
					SELECT  c.companyid,c.name AS compania,s.subfleetid,s.name as subflota,M.mobileid,M.name alias , M.plate,mst.name estado,M.make marca,M.model,moto.motoristaid,moto.nombre motorista,m.vin,m.yearmade,m.capacity,D.deviceid,D.name mdmid,d1.devicetypeid, d1.name devicetype,me.tipoPlan
					FROM [10.0.0.4].FM_Bluefenyx.dbo.mobile m 
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile_company mc ON m.mobileid = mc.mobileid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.device d ON m.deviceid = d.deviceid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.devicetype d1 ON d.devicetypeid = d1.devicetypeid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile_subfleet ms ON m.mobileid = ms.mobileid 
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.subfleet s ON ms.subfleetid = s.subfleetid AND s.companyid = mc.companyid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.MobileEx me ON m.mobileid = me.mobileid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.company c ON s.companyid = c.companyid
					LEFT JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile_motorista mm ON m.mobileid = mm.mobileid
					LEFT JOIN [10.0.0.4].FM_Bluefenyx.dbo.motorista moto ON mm.motoristaid = moto.motoristaid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile_status mst ON mst.mobilestatusid = M.status
					ORDER BY c.name
				END
				ELSE
				BEGIN 
					SELECT c.companyid,c.name  AS subflota,s.subfleetid,s.name as subflota,M.mobileid,M.name alias , M.plate,mst.name estado,M.make marca,M.model,moto.motoristaid,moto.nombre motorista,m.vin,m.yearmade,m.capacity,D.deviceid,D.name mdmid,d1.devicetypeid, d1.name devicetype,me.tipoPlan
					FROM [10.0.0.4].FM_Bluefenyx.dbo.mobile m 
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile_company mc ON m.mobileid = mc.mobileid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.device d ON m.deviceid = d.deviceid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.devicetype d1 ON d.devicetypeid = d1.devicetypeid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile_subfleet ms ON m.mobileid = ms.mobileid 
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.subfleet s ON ms.subfleetid = s.subfleetid AND s.companyid = mc.companyid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.MobileEx me ON m.mobileid = me.mobileid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.company c ON s.companyid = c.companyid
					LEFT JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile_motorista mm ON m.mobileid = mm.mobileid
					LEFT JOIN [10.0.0.4].FM_Bluefenyx.dbo.motorista moto ON mm.motoristaid = moto.motoristaid
					INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile_status mst ON mst.mobilestatusid = M.status
					WHERE c.companyid = @companyid
					ORDER BY c.name
				END
		END
		ELSE IF @bandera = 2 -- Actualizar plan
		BEGIN
			--SELECT TipoPlan FROM [10.0.0.4].FM_Bluefenyx.dbo.MobileEx WHERE mobileid = 12200
			--SELECT status FROM [10.0.0.4].FM_Bluefenyx.dbo.mobile WHERE mobileid = 12200
		BEGIN  TRY
			DECLARE @B_lengConsultas int , @B_consulta varchar(max), @B_plan VARCHAR(3), @B_mobileid INT
			declare @B_N INT=1				
			set @B_lengConsultas = (select count(mobileid_Tab) from @TablaMobile ) + 1			
					while (@B_N<@B_lengConsultas )
					BEGIN
					SET @B_plan = (SELECT plan_Tab FROM @tbPlan WHERE Id = @planid)
					SET @B_mobileid = (SELECT mobileid_Tab FROM @TablaMobile WHERE Id = @B_N)
					--SELECT @B_plan,@B_mobileid
					SET @B_consulta =  ('UPDATE  [10.0.0.4].FM_Bluefenyx.dbo.MobileEx  SET TipoPlan = '''+@B_plan+''' WHERE mobileid = '+CONVERT(varchar(15),@B_mobileid)+'')
					--select @B_consulta
						exec(@B_consulta)
						set @B_N=@B_N+1
					END
		SELECT 1
			END TRY
			BEGIN CATCH
			SELECT -1	
			END CATCH
		END ELSE IF @bandera = 3 -- Actualizar estado
		BEGIN
		BEGIN  TRY
			DECLARE @B_lengConsultas_Estado int , @B_consulta_Estado varchar(max), @B_mobileid_Estado INT
			declare @B_N_Estado INT=1				DECLARE @estadoid_Anterior_B int	
			set @B_lengConsultas_Estado = (select count(mobileid_Tab) from @TablaMobile ) + 1		
			--SELECT @lengConsultas_Estado
			while (@B_N_Estado<@B_lengConsultas_Estado )
			BEGIN					
				SET @B_mobileid_Estado = (SELECT mobileid_Tab FROM @TablaMobile WHERE Id = @B_N_Estado)
				--SELECT @mobileid_Estado,@estadoid
				SET @estadoid_Anterior_B = (SELECT [STATUS] FROM  [10.0.0.4].FM_Bluefenyx.dbo.mobile WHERE mobileid = @B_mobileid_Estado)
				SELECT @B_mobileid_Estado
				SET @B_consulta_Estado =  ('INSERT INTO  [10.0.0.4].FM_Bluefenyx.dbo.mobile_log (mobileid,estado_anterior,estado_nuevo,fecha_de_cambio,usuario,observaciones,motivoretiroid) 			
						VALUES ('+CONVERT(varchar(15),@B_mobileid_Estado)+','+CONVERT(varchar(15),@estadoid_Anterior_B)+','+CONVERT(varchar(15),@estadoid)+',getdate(),'''+@usuario+''','''+@observaciones+''','+CONVERT(varchar(15),@motivoretiro)+') 
						UPDATE [10.0.0.4].FM_Bluefenyx.dbo.mobile  SET [status] = '+CONVERT(varchar(15),@estadoid)+' WHERE mobileid = '+CONVERT(varchar(15),@B_mobileid_Estado)+'')
				--select @B_consulta_Estado
				exec(@B_consulta_Estado)
				set @B_N_Estado=@B_N_Estado+1
			END
		SELECT 1
		END TRY
		BEGIN CATCH
		SELECT -1	
		END CATCH
		END

	END 
END

--SELECT TOP 10 * FROM  [10.0.0.4].FM_Bluefenyx.dbo.mobile_log ORDER BY fecha_de_cambio DESC 
--SELECT TOP 10 * FROM  [10.0.0.5].Fleetmanager.dbo.mobile_log ORDER BY fecha_de_cambio DESC 

