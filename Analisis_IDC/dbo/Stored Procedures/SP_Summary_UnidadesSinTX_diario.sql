-- =============================================
-- Author:		Armando Villavicencio
-- Create date: 2022-30-03
-- Description:	<Description,,>
-- =============================================
--EXEC [SP_Summary_UnidadesSinTX_Diario]
CREATE PROCEDURE [dbo].[SP_Summary_UnidadesSinTX_diario]

AS
BEGIN
/*
DROP TABLE Summary_UnidadesSinTX
CREATE TABLE Summary_UnidadesSinTX (dateinfo datetime, ingenioText varchar(500),mobileid	int,ingenio int,	tipoplan varchar(5),	companyid	int,compania varchar(250),	subflota	varchar(250),estado varchar(50),
				placa varchar(25),	alias varchar(150),	dispositivo	 varchar(50),tipodispositivo varchar(50),	imei varchar(50),	
				icc	 varchar(50),	lineacelular varchar(50),		FechaUltimaTX	datetime ,diasDif int ,ubicacion varchar(1000),responsable varchar(250),					
				estadoactual varchar(250),diagnostico varchar(250),ticketid int ,fechaultimagestion datetime, comentarios varchar(max)	)
*/

				DECLARE @RunStoredProcSQL VARCHAR(max);
				SET @RunStoredProcSQL ='select lr.mobileid mobileid,
				(select top 1 subf.companyid from subfleet subf inner join mobile_subfleet mosu on  mosu.subfleetid=subf.subfleetid and mosu.mobileid=m.mobileid and subf.companyid in (292,89,297,977,1177,685))as ingenio,mx.tipoplan
				,c.companyid as companyid,c.name compania,s.name subflota, mst.name estado ,
				m.plate placa,m.name alias,d.name dispositivo,dt.name tipodispositivo,dx.imei imei,dx.Num_SIM as icc,dx.lineacelular,  dateadd(hh,-6,dategps) as fechaUltimaTX,  dateadd(hh,-6,dateserver) as dateserver,lr.location ubicacion,r.nombre_Resp,null,null,0,null,null
				from mobile_lastreport lr
				inner join mobile m on lr.mobileid=m.mobileid 
				inner join device d on d.deviceid=m.deviceid 
				inner join deviceex dx on m.deviceid=dx.deviceid
				inner join mobileex mx on mx.mobileid=m.mobileid
				inner join mobile_subfleet ms on ms.mobileid=m.mobileid
				inner join subfleet s on s.subfleetid=ms.subfleetid 
				inner join company c on c.companyid=s.companyid
				inner join mobile_company mc on m.mobileid=mc.mobileid and c.companyid=mc.companyid-- and s.companyid=1279
				inner join devicetype dt on d.devicetypeid=dt.devicetypeid
				inner join mobile_status mst on mst.mobilestatusid = m.status
				left join company_responsable cr on cr.Companyid = c.companyid
				left join responsable r on cr.Responsableid = r.Responsableid
				where dategps < dateadd(mi,-70,getdate()) --and dategps>dateadd(hh,-72,getdate())
				and m.status<>3 and mc.companyid not in(128,6,200,573,754)  and d.devicetypeid <> 25 
				/*and mc.companyid = 515*/
				order by FechaUltimaTX desc'

				declare @unidadessinx table (mobileid	int,ingenio int,	tipoplan varchar(5),	companyid	int,compania varchar(250),	subflota	varchar(250),estado varchar(50),
				placa varchar(25),	alias varchar(150),	dispositivo	 varchar(50),tipodispositivo varchar(50),	imei varchar(50),	
				icc	 varchar(50),	lineacelular varchar(50),		FechaUltimaTX	datetime,		dateserver	datetime ,ubicacion varchar(1000),responsable varchar(250),	
				/*empiecan datos del 192.168.1.5*/
				estadoactual varchar(250),diagnostico varchar(250),ticketid int ,fechaultimagestion datetime, comentarios varchar(max)	)

				insert into @unidadessinx
				EXEC (@RunStoredProcSQL) AT [10.0.0.5];
				--select * from @unidadessinx

				declare @VW_ConsultaTickets__ table (mobileid int 
				,estadoactual varchar(250),
				diagnostico varchar(250),
				ticketid int ,
				fechaultimagestion datetime, 
				comentarios varchar(max) )

				insert into @VW_ConsultaTickets__
				select uxx.mobileid, vwt.estadoactual,vwt.diagnostico,vwt.ticketid,vwt.fechaultimagestion,null
				from [192.168.1.5].soporte.dbo.VW_ConsultaTickets vwt 
				inner join @unidadessinx uxx on vwt.MobileID = uxx.MobileID
				
				/*WHERE uxx.MobileID 
				IN (SELECT ms.mobileid FROM [10.0.0.5].[FleetManager].dbo.mobile_subfleet ms
				INNER JOIN [10.0.0.5].[FleetManager].dbo.subfleet s ON ms.subfleetid = s.subfleetid
				WHERE s.companyid = 515)*/
				group by  uxx.mobileid, vwt.estadoactual,vwt.diagnostico,vwt.ticketid,vwt.fechaultimagestion
				order by mobileid,FechaUltimaGestion --desc

				--select * from @VW_ConsultaTickets__

				declare @ticketid int,@estado varchar(250), @diag varchar(250) 
				declare @coment varchar(max), @fechagest datetime, @mobileid int, @mobileidant int , @fechagestant datetime
				set @mobileidant = 0

				DECLARE CurSinTXTickets CURSOR FOR 
				select ticketid, estadoactual, diagnostico,fechaultimagestion,mobileid from @VW_ConsultaTickets__ 
				OPEN CurSinTXTickets
				FETCH NEXT FROM CurSinTXTickets INTO @ticketid ,@estado , @diag, @fechagest, @mobileid 
				WHILE @@fetch_status = 0
				BEGIN
					if(@mobileidant = @mobileid)
					begin						
						if(@fechagest > @fechagestant)
						begin				
							set @coment = (select top 1 comentarios from [192.168.1.5].soporte.dbo.detalleticket  where ticketid = @ticketid  and Fecha = @fechagest)
							update @unidadessinx set comentarios = @coment,estadoactual=@estado,diagnostico=@diag,ticketid = @ticketid,fechaultimagestion = @fechagest where mobileid = @mobileid
							set @fechagestant = @fechagest
						end
					end	
					else
					begin
						set @coment = (select top 1 comentarios from [192.168.1.5].soporte.dbo.detalleticket  where ticketid = @ticketid  and Fecha = @fechagest)
						update @unidadessinx set comentarios = @coment,estadoactual=@estado,diagnostico=@diag,ticketid = @ticketid,fechaultimagestion = @fechagest where mobileid = @mobileid
						set @fechagestant = @fechagest
					end				
					set @mobileidant = @mobileid
				FETCH NEXT FROM CurSinTXTickets INTO @ticketid ,@estado , @diag, @fechagest, @mobileid 
				END
				CLOSE CurSinTXTickets
				DEALLOCATE CurSinTXTickets
			
	--				DECLARE @dateprocess DATETIME =  dateadd(dd,-1,getdate())
	--DECLARE @fechainicio DATETIME,		@fechafin DATETIME
	--SET @fechainicio = DATEADD(hh,DATEPART(hh,@dateprocess)*-1,@dateprocess)
	--SET @fechainicio = DATEADD(mi,DATEPART(mi,@dateprocess)*-1,@fechainicio)
	--SET @fechainicio = DATEADD(ss,DATEPART(ss,@dateprocess)*-1,@fechainicio)
	--SET @fechainicio = DATEADD(ms,DATEPART(ms,@dateprocess)*-1,@fechainicio)
	--SET @fechafin = DATEADD(dd,1,@fechainicio)
	--DELETE Summary_UnidadesSinTX WHERE dateinfo BETWEEN DATEADD(MONTH,-1,@fechainicio) and DATEADD(MONTH,-1,@fechafin)

				 INSERT INTO [Summary_UnidadesSinTX_Diaria] (dateinfo, ingenioText,mobileid	,ingenio ,	tipoplan ,	companyid	,compania,	subflota	,estado ,
				placa ,	alias ,	dispositivo	 ,tipodispositivo ,	imei ,	
				icc	,	lineacelular,		dategps,dateserver,diasDif	 ,ubicacion ,estadoactual,				
				diagnostico,ticketid  ,fechaultimagestion , comentarios,responsable,plataforma)
				
				select  dateadd(HOUR,-6,getdate()), CASE 
				WHEN ingenio = 292 THEN 'EL ANGEL ' 
				WHEN  ingenio = 89 THEN 'CASSA' 
				WHEN  ingenio = 297 THEN 'CHAPARRASTIQUE '
				WHEN  ingenio = 1177 THEN 'CEMEX, S.A. DE C.V'
				WHEN  ingenio = 977 THEN 'JIBOA ' 
				WHEN  ingenio = 685 THEN 'Distribución OPL' 
				ELSE 'Sin Empresa' END  as ingenioText,mobileid,ingenio,tipoplan,companyid,compania,subflota,estado,
				placa,alias,dispositivo,tipodispositivo,imei,icc,lineacelular
				,convert(varchar(50),FechaUltimaTX,120)fechaUltimaTX,convert(varchar(50),dateserver,120)dateserver,datediff(DD,FechaUltimaTX,getdate())diasDif,ubicacion,estadoactual,diagnostico,ticketid,convert(varchar(50),fechaultimagestion,120)fechaultimagestion,comentarios,responsable,1
				from @unidadessinx
				--SELECT  * FROM Summary_UnidadesSinTX

				--=====================================================================================================================================================
				


				declare @unidadessinxBlueFenyx table (mobileid	int,ingenio int,	tipoplan varchar(5),	companyid	int,compania varchar(250),	subflota	varchar(250),estado varchar(50),
				placa varchar(25),	alias varchar(150),	dispositivo	 varchar(50),tipodispositivo varchar(50),	imei varchar(50),	
				icc	 varchar(50),	lineacelular varchar(50),		FechaUltimaTX	datetime,		dateserver	datetime ,ubicacion varchar(1000),responsable varchar(250),	
				/*empiecan datos del 192.168.1.5*/
				estadoactual varchar(250),diagnostico varchar(250),ticketid int ,fechaultimagestion datetime, comentarios varchar(max)	)

				insert into @unidadessinxBlueFenyx
--				EXEC (@RunStoredProcSQL) AT [10.0.0.4];
				select lr.mobileid mobileid,
				(select top 1 subf.companyid from [10.0.0.4].[FM_Bluefenyx].dbo.subfleet subf inner join [10.0.0.4].[FM_Bluefenyx].dbo.mobile_subfleet mosu on  mosu.subfleetid=subf.subfleetid and mosu.mobileid=m.mobileid and subf.companyid in (292,89,297,977,1177,685))as ingenio,mx.tipoplan
				,c.companyid as companyid,c.name compania,s.name subflota, mst.name estado ,
				m.plate placa,m.name alias,d.name dispositivo,dt.name tipodispositivo,dx.imei imei,dx.Num_SIM as icc,dx.lineacelular,  dateadd(hh,-6,dategps) as fechaUltimaTX,  dateadd(hh,-6,dateserver) as dateserver,lr.location ubicacion,r.nombre_Resp,null,null,0,null,null
				from [10.0.0.4].[FM_Bluefenyx].dbo.mobile_lastreport lr
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.mobile m on lr.mobileid=m.mobileid 
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.device d on d.deviceid=m.deviceid 
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.deviceex dx on m.deviceid=dx.deviceid
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.mobileex mx on mx.mobileid=m.mobileid
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.mobile_subfleet ms on ms.mobileid=m.mobileid
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.subfleet s on s.subfleetid=ms.subfleetid 
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.company c on c.companyid=s.companyid
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.mobile_company mc on m.mobileid=mc.mobileid and c.companyid=mc.companyid-- and s.companyid=1279
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.devicetype dt on d.devicetypeid=dt.devicetypeid
				inner join [10.0.0.4].[FM_Bluefenyx].dbo.mobile_status mst on mst.mobilestatusid = m.status
				left join [10.0.0.4].[FM_Bluefenyx].dbo.company_responsable cr on cr.Companyid = c.companyid
				left join [10.0.0.4].[FM_Bluefenyx].dbo.responsable r on cr.Responsableid = r.Responsableid
				where dategps < dateadd(mi,-70,getdate()) --and dategps>dateadd(hh,-72,getdate())
				and m.status<>3 and mc.companyid not in (6,200,986) and d.devicetypeid <> 25 
				/*and mc.companyid = 515*/
				order by FechaUltimaTX desc

				--select * from @unidadessinxBlueFenyx
				
				declare @VW_ConsultaTickets__Bluefenyx table (mobileid int 
				,estadoactual varchar(250),
				diagnostico varchar(250),
				ticketid int ,
				fechaultimagestion datetime, 
				comentarios varchar(max) )

				insert into @VW_ConsultaTickets__Bluefenyx
				select uxx.mobileid, vwt.estadoactual,vwt.diagnostico,vwt.ticketid,vwt.fechaultimagestion,null
				from soporte.dbo.VW_ConsultaTickets vwt 
				inner join @unidadessinxBlueFenyx uxx on vwt.MobileID = uxx.MobileID
				
				/*WHERE uxx.MobileID 
				IN (SELECT ms.mobileid FROM [10.0.0.4].[FleetManager].dbo.mobile_subfleet ms
				INNER JOIN [10.0.0.4].[FleetManager].dbo.subfleet s ON ms.subfleetid = s.subfleetid
				WHERE s.companyid = 515)*/
				group by  uxx.mobileid, vwt.estadoactual,vwt.diagnostico,vwt.ticketid,vwt.fechaultimagestion
				order by mobileid,FechaUltimaGestion --desc

				--select * from @VW_ConsultaTickets__Bluefenyx

				declare @ticketidBluefenyx int,@estadoBluefenyx varchar(250), @diagBluefenyx varchar(250) 
				declare @comentBluefenyx varchar(max), @fechagestBluefenyx datetime, @mobileidBluefenyx int, @mobileidBluefenyxant int , @fechagestBluefenyxant datetime
				set @mobileidBluefenyxant = 0

				DECLARE CurSinTXTickets CURSOR FOR 
				select ticketid, estadoactual, diagnostico,fechaultimagestion,mobileid from @VW_ConsultaTickets__Bluefenyx 
				OPEN CurSinTXTickets
				FETCH NEXT FROM CurSinTXTickets INTO @ticketidBluefenyx ,@estadoBluefenyx , @diagBluefenyx, @fechagestBluefenyx, @mobileidBluefenyx 
				WHILE @@fetch_status = 0
				BEGIN
					if(@mobileidBluefenyxant = @mobileidBluefenyx)
					begin						
						if(@fechagestBluefenyx > @fechagestBluefenyxant)
						begin				
							set @comentBluefenyx = (select top 1 comentarios from soporte.dbo.detalleticket  where ticketid = @ticketidBluefenyx  and Fecha = @fechagestBluefenyx)
							update @unidadessinxBlueFenyx set comentarios = @comentBluefenyx,estadoactual=@estadoBluefenyx,diagnostico=@diagBluefenyx,ticketid = @ticketidBluefenyx,fechaultimagestion = @fechagestBluefenyx where mobileid = @mobileidBluefenyx
							set @fechagestBluefenyxant = @fechagestBluefenyx
						end
					end	
					else
					begin
						set @comentBluefenyx = (select top 1 comentarios from soporte.dbo.detalleticket  where ticketid = @ticketidBluefenyx  and Fecha = @fechagestBluefenyx)
						update @unidadessinxBlueFenyx set comentarios = @comentBluefenyx,estadoactual=@estadoBluefenyx,diagnostico=@diagBluefenyx,ticketid = @ticketidBluefenyx,fechaultimagestion = @fechagestBluefenyx where mobileid = @mobileidBluefenyx
						set @fechagestBluefenyxant = @fechagestBluefenyx
					end				
					set @mobileidBluefenyxant = @mobileidBluefenyx
				FETCH NEXT FROM CurSinTXTickets INTO @ticketidBluefenyx ,@estadoBluefenyx , @diagBluefenyx, @fechagestBluefenyx, @mobileidBluefenyx 
				END
				CLOSE CurSinTXTickets
				DEALLOCATE CurSinTXTickets
				
				 INSERT INTO [Summary_UnidadesSinTX_Diaria] (dateinfo, ingenioText,mobileid	,ingenio ,	tipoplan ,	companyid	,compania,	subflota	,estado ,
				placa ,	alias ,	dispositivo	 ,tipodispositivo ,	imei ,	
				icc	,	lineacelular,		dategps,dateserver,diasDif	 ,ubicacion ,estadoactual,				
				diagnostico,ticketid  ,fechaultimagestion , comentarios,responsable,plataforma)
				
				select  dateadd(DAY,-2,getdate()), CASE 
				WHEN ingenio = 914 THEN 'ILC S.A. de C.V.' 
				ELSE 'Sin Empresa' END  as ingenioText,mobileid,ingenio,tipoplan,companyid,compania,subflota,estado,
				placa,alias,dispositivo,tipodispositivo,imei,icc,lineacelular
				,convert(varchar(50),FechaUltimaTX,120)fechaUltimaTX,convert(varchar(50),dateserver,120)dateserver,datediff(DD,FechaUltimaTX,getdate())diasDif,ubicacion,estadoactual,diagnostico,ticketid,convert(varchar(50),fechaultimagestion,120)fechaultimagestion,comentarios,responsable,2
				from @unidadessinxBlueFenyx

				


END
--SELECT  * FROM company WHERE [name] LIKE '%%'