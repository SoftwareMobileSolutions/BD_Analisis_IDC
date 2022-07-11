-- =============================================
-- Author:		JAIME BELTRAN
-- Create date: 02-12-2010
-- Description:	Calcular el consumo por compañia o por todos los automoviles
-- =============================================
-- Modificado por: FERNANDO MENDEZ
-- Date:	05-06-2022
-- Description:	Se prepara doble bandera, y se agrega validacion para no tomar device SMSTRACKING
-- =============================================
--DECLARE @dateiniI as DATETIME,
--		@datefinI as DATETIME,
--		@plataformaBandera AS INT 
--SET @dateiniI=convert(varchar,dateadd(DAY,-2,getdate()),112) + ' 06:00'
--SET @datefinI=convert(varchar,dateadd(DAY,-1,getdate()),112) + ' 06:00'
--EXEC [Analisis_IDC].[dbo].[SP_Reporte_ConsumoIDC] @dateiniI, @datefinI, 0, 0, 0,2


CREATE PROCEDURE SP_Reporte_ConsumoIDC 
	-- Add the parameters for the stored procedure here
	@dateini as DATETIME,
	@datefin as DATETIME,
	@opcionid as INT,
	@companyid as INT,
	@deviceid as INT,
	@plataformaBandera AS INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
DECLARE @mobileid INT,
		@ConteoDias INT,
		@FechaFin DATETIME,
		@FinishDate DATETIME,
		@Devicetypeid INT,
		@ProU INT,
		@ProT INT

SET @FinishDate = getdate()
SET @FechaFin = DATEADD(hh,DATEPART(hh,@FinishDate)*-1,@FinishDate)
SET @FechaFin = DATEADD(mi,DATEPART(mi,@FinishDate)*-1,@FechaFin)
SET @FechaFin = DATEADD(ss,DATEPART(ss,@FinishDate)*-1,@FechaFin)
SET @FechaFin = DATEADD(ms,DATEPART(ms,@FinishDate)*-1,@FechaFin)

IF @datefin < @FechaFin
	BEGIN
		SET @FechaFin=@datefin
	END

SET @ConteoDias=DATEDIFF(dd,@dateini,@FechaFin)+1

CREATE TABLE [#mobile_summary_temporal](
[mobileid] [INT] NULL,
[sumcountlogip] [INT] NULL,
[countlogipU] [INT] NULL,
[countlogipT] [INT] NULL,
[CountDC] [INT] NULL,
[CountTramasEsp][INT] NULL,
[dateinfo] [DATETIME] NULL
)
CREATE TABLE [#reporte](
[Compania] VARCHAR(128),
[Mobileid] INT,
[Nombre_auto] VARCHAR(50),
[Placa] VARCHAR(50),
[Dispositivo] VARCHAR(50),
[Sumatoria_Consumo] REAL,
[Consumo_Esperado] REAL,
[Consumo_Esperado_Recorrido] REAL
)

IF (@plataformaBandera = 1)
BEGIN
IF @opcionid=0
	BEGIN

		DECLARE mobile_cursor CURSOR FOR 
		SELECT mobileid
		FROM [10.0.0.5].[FleetManager].[dbo].mobile 
		WHERE status<>3 AND deviceid NOT IN (
		SELECT d.deviceid FROM [10.0.0.5].[FleetManager].dbo.device d 
		INNER JOIN [10.0.0.5].[FleetManager].dbo.devicetype dt ON D.deviceid = D.deviceid WHERE dt.devicetypeid = 25)
	END
ELSE
	BEGIN
		IF @opcionid=1
			BEGIN
				DECLARE mobile_cursor CURSOR FOR 
				SELECT m.mobileid
				FROM [10.0.0.5].[FleetManager].[dbo].mobile as m inner join [10.0.0.5].[FleetManager].[dbo].mobile_company as mc on m.mobileid=mc.mobileid
				WHERE m.status<>3 and mc.companyid=@companyid
			END
		ELSE
			BEGIN
				IF @opcionid=2
					BEGIN
						DECLARE mobile_cursor CURSOR FOR 
						SELECT mobileid
						FROM [10.0.0.5].[FleetManager].[dbo].mobile 
						WHERE deviceid in (SELECT deviceid from [10.0.0.5].[FleetManager].[dbo].device where deviceid=@deviceid)						
					END
			END
	END
OPEN mobile_cursor
	
FETCH NEXT FROM mobile_cursor 
INTO @mobileid 
	
WHILE (@@FETCH_STATUS = 0) 
	BEGIN
	
	INSERT INTO [#mobile_summary_temporal]([mobileid],[sumcountlogip],[countlogipU],[countlogipT],[CountDC],[dateinfo],[CountTramasEsp])
	select distinct mobileid, sumcountlogip, countlogipu, countlogipt, CountDC, dateinfo, counttramasesp
	from [10.0.0.9].[FleetManager].[dbo].mobile_summary 
	where dateinfo between @dateini and @datefin and mobileid=@mobileid 

	SELECT @devicetypeid=devicetypeid from [10.0.0.5].[FleetManager].[dbo].device where deviceid in (select deviceid from [10.0.0.5].[FleetManager].[dbo].mobile where mobileid=@mobileid)

	IF @devicetypeid=3 
		BEGIN
			SET @ProU =117
			SET @ProT =52
		END
	ELSE
		BEGIN
			IF @devicetypeid=5
				BEGIN
					SET @ProU =98
					SET @ProT =	37	
				END 
			ELSE
				BEGIN
					SET @ProU =68
					SET @ProT =	0		
				END
		END

	INSERT INTO [#reporte] ([Compania],[Mobileid],[Nombre_auto],[Placa],[Dispositivo],[Sumatoria_Consumo],[Consumo_Esperado],[Consumo_Esperado_Recorrido])
	SELECT c.name, @mobileid, m.name, m.plate, d.name, (SUM(ISNULL(mst.sumcountlogip,0))+ SUM(ISNULL(mst.countlogipU,0))*28 + SUM(ISNULL(mst.countlogipT,0))*120 + SUM(ISNULL(mst.CountDC,0))/2*176) as suma, @ConteoDias*0.10 as Valoresp, (SUM(ISNULL(counttramasesp,0))*@ProU+ SUM(ISNULL(counttramasesp,0))*28 + @ConteoDias*@ProT*96 + @ConteoDias*96*120 + @ConteoDias*96*176/2) as Recorrido_Esperado
	FROM [#mobile_summary_temporal] as mst inner join [10.0.0.5].[FleetManager].[dbo].mobile as m on mst.mobileid=m.mobileid 
	inner join [10.0.0.5].[FleetManager].[dbo].mobile_company as mc on mc.mobileid=m.mobileid inner join [10.0.0.5].[FleetManager].[dbo].company as c on c.companyid=mc.companyid
	inner join [10.0.0.5].[FleetManager].[dbo].device as d on d.deviceid=m.deviceid group by c.name, m.name, m.plate, d.name
	
	DELETE FROM [#mobile_summary_temporal]

	FETCH NEXT FROM mobile_cursor 
	INTO @mobileid
	END			
CLOSE mobile_cursor
DEALLOCATE mobile_cursor 

	SELECT r.Compania,r.Mobileid,r.Nombre_auto,r.Placa,r.Dispositivo,de.LineaCelular,CONVERT(DECIMAL(10,2),r.Sumatoria_Consumo/1024/1024)as 
	Sumatoria_Consumo, CONVERT(DECIMAL(10,2),r.Consumo_Esperado) as Consumo_Esperado, CONVERT(DECIMAL(10,2),r.Consumo_Esperado_Recorrido/1024/1024) as Consumo_Esperado_Recorrido 
	FROM [#reporte] as r 
	inner join [10.0.0.5].[FleetManager].[dbo].mobile as m on r.mobileid=m.mobileid 
	inner join [10.0.0.5].[FleetManager].[dbo].deviceex as de on m.deviceid=de.deviceid 
	order by Sumatoria_Consumo desc
END--@plataformaBandera=1

ELSE 
BEGIN
IF @opcionid=0
	BEGIN

		DECLARE mobile_cursor CURSOR FOR 
		SELECT mobileid
		FROM [10.0.0.4].[FM_Bluefenyx].[dbo].mobile 
		WHERE status<>3 AND deviceid NOT IN (
		SELECT d.deviceid FROM [10.0.0.4].[FM_BlueFenyx].dbo.device d 
		INNER JOIN [10.0.0.4].[FM_BlueFenyx].dbo.devicetype dt ON D.deviceid = D.deviceid WHERE dt.devicetypeid = 25)
	END
ELSE
	BEGIN
		IF @opcionid=1
			BEGIN
				DECLARE mobile_cursor CURSOR FOR 
				SELECT m.mobileid
				FROM [10.0.0.4].[FM_Bluefenyx].[dbo].mobile as m inner join [10.0.0.4].[FM_Bluefenyx].[dbo].mobile_company as mc on m.mobileid=mc.mobileid
				WHERE m.status<>3 and mc.companyid=@companyid
			END
		ELSE
			BEGIN
				IF @opcionid=2
					BEGIN
						DECLARE mobile_cursor CURSOR FOR 
						SELECT mobileid
						FROM [10.0.0.4].[FM_Bluefenyx].[dbo].mobile 
						WHERE deviceid in (SELECT deviceid from [10.0.0.4].[FM_Bluefenyx].[dbo].device where deviceid=@deviceid)						
					END
			END
	END
OPEN mobile_cursor
	
FETCH NEXT FROM mobile_cursor 
INTO @mobileid 
	
WHILE (@@FETCH_STATUS = 0) 
	BEGIN
	
	INSERT INTO [#mobile_summary_temporal]([mobileid],[sumcountlogip],[countlogipU],[countlogipT],[CountDC],[dateinfo],[CountTramasEsp])
	select distinct mobileid, sumcountlogip, countlogipu, countlogipt, CountDC, dateinfo, counttramasesp
	from [10.0.0.4].[FM_Bluefenyx].[dbo].mobile_summary 
	where dateinfo between @dateini and @datefin and mobileid=@mobileid 

	SELECT @devicetypeid=devicetypeid from [10.0.0.4].[FM_Bluefenyx].[dbo].device where deviceid in (select deviceid from [10.0.0.4].[FM_Bluefenyx].[dbo].mobile where mobileid=@mobileid)

	IF @devicetypeid=3 
		BEGIN
			SET @ProU =117
			SET @ProT =52
		END
	ELSE
		BEGIN
			IF @devicetypeid=5
				BEGIN
					SET @ProU =98
					SET @ProT =	37	
				END 
			ELSE
				BEGIN
					SET @ProU =68
					SET @ProT =	0		
				END
		END

	INSERT INTO [#reporte] ([Compania],[Mobileid],[Nombre_auto],[Placa],[Dispositivo],[Sumatoria_Consumo],[Consumo_Esperado],[Consumo_Esperado_Recorrido])
	SELECT c.name, @mobileid, m.name, m.plate, d.name, (SUM(ISNULL(mst.sumcountlogip,0))+ SUM(ISNULL(mst.countlogipU,0))*28 + SUM(ISNULL(mst.countlogipT,0))*120 + SUM(ISNULL(mst.CountDC,0))/2*176) as suma, @ConteoDias*0.10 as Valoresp, (SUM(ISNULL(counttramasesp,0))*@ProU+ SUM(ISNULL(counttramasesp,0))*28 + @ConteoDias*@ProT*96 + @ConteoDias*96*120 + @ConteoDias*96*176/2) as Recorrido_Esperado
	FROM [#mobile_summary_temporal] as mst inner join [10.0.0.4].[FM_Bluefenyx].[dbo].mobile as m on mst.mobileid=m.mobileid 
	inner join [10.0.0.4].[FM_Bluefenyx].[dbo].mobile_company as mc on mc.mobileid=m.mobileid inner join [10.0.0.4].[FM_Bluefenyx].[dbo].company as c on c.companyid=mc.companyid
	inner join [10.0.0.4].[FM_Bluefenyx].[dbo].device as d on d.deviceid=m.deviceid group by c.name, m.name, m.plate, d.name
	
	DELETE FROM [#mobile_summary_temporal]

	FETCH NEXT FROM mobile_cursor 
	INTO @mobileid
	END			
CLOSE mobile_cursor
DEALLOCATE mobile_cursor 

	SELECT r.Compania,r.Mobileid,r.Nombre_auto,r.Placa,r.Dispositivo,de.LineaCelular,CONVERT(DECIMAL(10,2),r.Sumatoria_Consumo/1024/1024)as 
	Sumatoria_Consumo, CONVERT(DECIMAL(10,2),r.Consumo_Esperado) as Consumo_Esperado, CONVERT(DECIMAL(10,2),r.Consumo_Esperado_Recorrido/1024/1024) as Consumo_Esperado_Recorrido 
	FROM [#reporte] as r 
	inner join [10.0.0.4].[FM_Bluefenyx].[dbo].mobile as m on r.mobileid=m.mobileid 
	inner join [10.0.0.4].[FM_Bluefenyx].[dbo].deviceex as de on m.deviceid=de.deviceid 
	order by Sumatoria_Consumo desc
END--ELSE

END--SP
