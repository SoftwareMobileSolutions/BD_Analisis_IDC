-- =============================================
-- Author:		FERNANDO MENDEZ
-- Create date: 13/04/2022
-- Description:	Genera el reporte Totalizador Consolidado (SV,NI,HN)
-- =============================================
CREATE PROCEDURE [dbo].[ReporteTotalizadorCBCConsilidado]
	
	-- Add the parameters for the stored procedure here

    -- EXEC ReporteTotalizadorCBCConsilidado 'C',35,2842,'20220401 00:00:00','20220401 23:59:59','A'
    -- EXEC ReporteTotalizadorCBCConsilidado 'C',899,2483,'20220401 00:00:00','20220401 23:59:59','A'
	
	
	@objecttype		as VARCHAR(25)	-- C company, S subfleet, M mobile
	,@objectid		as INT			-- Id del objeto ya sea companyid, subfleetid o mobileid
	,@userid		as INT			-- Id del usuario
	,@startdate		as varchar(50)	-- Fecha inicio
	,@finishdate	as varchar(50)	-- Fecha fin
	,@tipoplan		varchar(2)		--Tipo de Plan
	--objecttype,objectid,userid,startdate,finishdate,tipoplan
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	--Variables del reporte 
	DECLARE @id			varchar(50)
	DECLARE @grupo		varchar(50)
	DECLARE @subgrupo	varchar(50)
	DECLARE @tipovehiculo varchar(50)
	DECLARE @alias		varchar(50)
	DECLARE @subfleetname varchar(50)
	DECLARE @mobilename varchar(50)
	DECLARE @mobileplate varchar(50)
	DECLARE @monthname	varchar(50)
	DECLARE @maxspeed	float
	DECLARE @distance	float
	DECLARE @timestop	float
	DECLARE @maxtimestop float
	DECLARE @timeproduction float
	DECLARE @timework	float
	DECLARE @timestopproduction float
	DECLARE @gasoline	float
	DECLARE @kmxgalon float
	DECLARE @maxstopon float
	DECLARE @timeon float

	--declarando las tablas para cada pais
	   create table #ReporteTotalizadorSV(
	   idSV varchar(50),
	   grupoSV varchar(50),
	   subgrupoSV varchar(50),
	   tipovehiculoSV varchar(50),
	   aliasSV varchar(50),
	   subfleetnameSV varchar(50),
	   mobilenameSV varchar(50),
	   mobileplateSV varchar(50),
	   monthnameSV varchar(50),
	   maxspeedSV float,
	   distanceSV float,
	   timestopSV float,
	   maxtimestopSV float,
	   timeproductionSV float,
	   timeworkSV float,
	   timestopproductionSV float,
	   gasolineSV float,
	   kmxgalonSV float,
	   maxstoponSV float,
	   timeonSV float)

	   create table #ReporteTotalizadorNI(
	   idNI varchar(50),
	   grupoNI varchar(50),
	   subgrupoNI varchar(50),
	   tipovehiculoNI varchar(50),
	   aliasNI varchar(50),
	   subfleetnameNI varchar(50),
	   mobilenameNI varchar(50),
	   mobileplateNI varchar(50),
	   monthnameNI varchar(50),
	   maxspeedNI float,
	   distanceNI float,
	   timestopNI float,
	   maxtimestopNI float,
	   timeproductionNI float,
	   timeworkNI float,
	   timestopproductionNI float,
	   gasolineNI float,
	   kmxgalonNI float,
	   maxstoponNI float,
	   timeonNI float)


--usuario: cbcsv
--compañia: MARIPOSA EL SALVADOR SA de CV
IF (@objectid = 35 AND @userid = 2842)
	BEGIN
		insert into #ReporteTotalizadorSV
		exec [10.0.0.9].[FleetManager].[dbo].[Fleets_reportMobileSummary_detallado_TPlan] @objecttype,@objectid,@userid,@startdate,@finishdate,@tipoplan


--Genero la informacion de NICARAGUA, YA QUE NECESITO 2 SELECT
	set @objecttype		= 'C'
	set @objectid		= 899  
	set @userid			= 2483

		insert into #ReporteTotalizadorNI
		exec [10.0.0.9].[FleetManager].[dbo].[Fleets_reportMobileSummary_detallado_TPlan] @objecttype,@objectid,@userid,@startdate,@finishdate,@tipoplan


--SELECT #2
select subfleetnameNI,mobilenameNI,mobileplateNI,tipovehiculoNI,monthnameNI,maxspeedNI,distanceNI,timeproductionNI,timeworkNI,maxtimestopNI,timestopproductionNI,timestopNI,gasolineNI,kmxgalonNI 
from #ReporteTotalizadorNI

--SELECT #1
select subfleetnameSV,mobilenameSV,mobileplateSV,tipovehiculoSV,monthnameSV,maxspeedSV,distanceSV,timeproductionSV,timeworkSV,maxtimestopSV,timestopproductionSV,timestopSV,gasolineSV,kmxgalonSV 
from #ReporteTotalizadorSV


	END
ELSE
	BEGIN
--usuario: josmanagua
--compañia: CBC Nicaragua
		IF (@objectid = 899 AND @userid = 2483)
			BEGIN

				insert into #ReporteTotalizadorNI
				exec [10.0.0.9].[FleetManager].[dbo].[Fleets_reportMobileSummary_detallado_TPlan] @objecttype,@objectid,@userid,@startdate,@finishdate,@tipoplan

--Genero la informacion de El Salvador, YA QUE NECESITO 2 SELECT
set @objecttype		= 'C'
set @objectid		= 35  
set @userid			= 2842

				insert into #ReporteTotalizadorSV
				exec [10.0.0.9].[FleetManager].[dbo].[Fleets_reportMobileSummary_detallado_TPlan] @objecttype,@objectid,@userid,@startdate,@finishdate,@tipoplan

--SELECT #2
select subfleetnameNI,mobilenameNI,mobileplateNI,tipovehiculoNI,monthnameNI,maxspeedNI,distanceNI,timeproductionNI,timeworkNI,maxtimestopNI,timestopproductionNI,timestopNI,gasolineNI,kmxgalonNI 
from #ReporteTotalizadorNI

--SELECT #1
select subfleetnameSV,mobilenameSV,mobileplateSV,tipovehiculoSV,monthnameSV,maxspeedSV,distanceSV,timeproductionSV,timeworkSV,maxtimestopSV,timestopproductionSV,timestopSV,gasolineSV,kmxgalonSV 
from #ReporteTotalizadorSV

			END
		ELSE
			BEGIN
				select 'Verifique que los parametros correspondan a CBCSV,CBCNI Y CBCHN'
			END
	END

drop table #ReporteTotalizadorSV
drop table #ReporteTotalizadorNI

END
