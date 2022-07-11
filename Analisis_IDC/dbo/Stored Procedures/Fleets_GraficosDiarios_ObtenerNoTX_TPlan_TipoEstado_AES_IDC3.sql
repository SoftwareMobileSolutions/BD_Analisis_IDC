/*
	/******************************************************************************************************
    Modificado por:		Fernando Mendez
    Fecha Modificado:   20/06/2022
    Descripción:	    Se agregan logica para que tome los estados de VW_ConsultaTickets y no de la tabla Bitacora_Mobile_Estados
    *******************************************************************************************************/ 
	
	el parametro @zona puede ser
	1-oriente
	2-occidente
	3-central
*/

--EXEC Fleets_GraficosDiarios_ObtenerNoTX_TPlan_TipoEstado_AES_IDC3 '20220701 00:00:00','20220704 23:59:59',1036 


CREATE PROCEDURE [dbo].[Fleets_GraficosDiarios_ObtenerNoTX_TPlan_TipoEstado_AES_IDC3]
	@companyid as INT,
	@fechainicio datetime,
	@fechafin datetime

	--@zona int 
AS
BEGIN

  --declare  @table_TP TABLE (mobileid int)

  --DECLARE @estadoDefault VARCHAR(50) SET @estadoDefault =  (SELECT cde.nombre FROM [10.0.0.4].FM_Bluefenyx.dbo.ClasesDeEstados cde WHERE cde.estadoid = 1)

	--Se insertan los vehiculos que puede visualizar el usuario
		--insert into @table_TP(mobileid)
		--select m.mobileid 
		--from [10.0.0.4].FM_Bluefenyx.dbo.mobile m 
		--inner join [10.0.0.4].FM_Bluefenyx.dbo.mobile_company mc on m.mobileid = mc.mobileid 
		--inner join [10.0.0.4].FM_Bluefenyx.dbo.mobile_zonaAES ma on ma.mobileid=m.mobileid
		--WHERE mc.companyid = @companyid and m.status <> 3 and ma.zona=@zona
		--order by m.mobileid

	--Se insertan los vehiculos de la zona Oriente 
	    declare  @OrienteZone TABLE (mobileid int)
		insert into @OrienteZone(mobileid)
		select m.mobileid 
		from [10.0.0.4].FM_Bluefenyx.dbo.mobile m 
		inner join [10.0.0.4].FM_Bluefenyx.dbo.mobile_company mc on m.mobileid = mc.mobileid 
		inner join [10.0.0.4].FM_Bluefenyx.dbo.mobile_zonaAES ma on ma.mobileid=m.mobileid
		WHERE mc.companyid = @companyid and m.status <> 3 and ma.zona=1
		order by m.mobileid

	--Se insertan los vehiculos de la zona Occidente 
	    declare  @OccidenteZone TABLE (mobileid int)
		insert into @OccidenteZone(mobileid)
		select m.mobileid 
		from [10.0.0.4].FM_Bluefenyx.dbo.mobile m 
		inner join [10.0.0.4].FM_Bluefenyx.dbo.mobile_company mc on m.mobileid = mc.mobileid 
		inner join [10.0.0.4].FM_Bluefenyx.dbo.mobile_zonaAES ma on ma.mobileid=m.mobileid
		WHERE mc.companyid = @companyid and m.status <> 3 and ma.zona=2
		order by m.mobileid

	--Se insertan los vehiculos de la zona Oriente 
	    declare  @CentralZone TABLE (mobileid int)
		insert into @CentralZone(mobileid)
		select m.mobileid 
		from [10.0.0.4].FM_Bluefenyx.dbo.mobile m 
		inner join [10.0.0.4].FM_Bluefenyx.dbo.mobile_company mc on m.mobileid = mc.mobileid 
		inner join [10.0.0.4].FM_Bluefenyx.dbo.mobile_zonaAES ma on ma.mobileid=m.mobileid
		WHERE mc.companyid = @companyid and m.status <> 3 and ma.zona=3
		order by m.mobileid
	
	
	--Datos para Oriente
		SELECT s.name as subflota, m.plate as placa, m.name as alias,ISNULL(v.EstadoActual,'En uso') estado,
		convert(varchar(20), dateadd(hh,timezone, ml.dategps),120) as fechagps,
		convert(varchar(20),dateadd(hh,timezone,ml.dateserver),120) as fechaservidor,
		ml.location 'última ubicación',' ' as 'Estado Actual'
		FROM [10.0.0.4].FM_Bluefenyx.dbo.mobileLastReport AS ML
		INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile m on ml.mobileid = m.mobileid
		INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.subfleet s on ml.subfleetid = s.subfleetid
		LEFT JOIN  [10.0.0.4].FM_Bluefenyx.dbo.Bitacora_Mobile_Estados bme ON ML.mobileid = bme.mobileid
		LEFT JOIN  [10.0.0.4].FM_Bluefenyx.dbo.MobileEx me ON ML.mobileid = me.mobileid
		left join (select mobileid, estadoactual from [soporte].dbo.VW_ConsultaTickets  v 
		where fechacierre is null) v on m.mobileid = v.mobileid
		WHERE m.mobileid in (select mobileid from @OrienteZone)
		and s.companyid=@companyid and datediff(mi,ML.dategps,getdate())>=  70
		ORDER BY 5 DESC

	--Datos para Occidente
		SELECT s.name as subflota, m.plate as placa, m.name as alias,ISNULL(v.EstadoActual,'En uso') estado,
		convert(varchar(20), dateadd(hh,timezone, ml.dategps),120) as fechagps,
		convert(varchar(20),dateadd(hh,timezone,ml.dateserver),120) as fechaservidor,
		ml.location 'última ubicación',' ' as 'Estado Actual'
		FROM [10.0.0.4].FM_Bluefenyx.dbo.mobileLastReport AS ML
		INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile m on ml.mobileid = m.mobileid
		INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.subfleet s on ml.subfleetid = s.subfleetid
		LEFT JOIN  [10.0.0.4].FM_Bluefenyx.dbo.Bitacora_Mobile_Estados bme ON ML.mobileid = bme.mobileid
		LEFT JOIN  [10.0.0.4].FM_Bluefenyx.dbo.MobileEx me ON ML.mobileid = me.mobileid
		left join (select mobileid, estadoactual from [soporte].dbo.VW_ConsultaTickets  v 
		where fechacierre is null) v on m.mobileid = v.mobileid
		WHERE m.mobileid in (select mobileid from @OccidenteZone)
		and s.companyid=@companyid and datediff(mi,ML.dategps,getdate())>=  70
		ORDER BY 5 DESC

	 --Datos para Oriente
		SELECT s.name as subflota, m.plate as placa, m.name as alias,ISNULL(v.EstadoActual,'En uso') estado,
		convert(varchar(20), dateadd(hh,timezone, ml.dategps),120) as fechagps,
		convert(varchar(20),dateadd(hh,timezone,ml.dateserver),120) as fechaservidor,
		ml.location 'última ubicación',' ' as 'Estado Actual'
		FROM [10.0.0.4].FM_Bluefenyx.dbo.mobileLastReport AS ML
		INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile m on ml.mobileid = m.mobileid
		INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.subfleet s on ml.subfleetid = s.subfleetid
		LEFT JOIN  [10.0.0.4].FM_Bluefenyx.dbo.Bitacora_Mobile_Estados bme ON ML.mobileid = bme.mobileid
		LEFT JOIN  [10.0.0.4].FM_Bluefenyx.dbo.MobileEx me ON ML.mobileid = me.mobileid
		left join (select mobileid, estadoactual from [soporte].dbo.VW_ConsultaTickets  v 
		where fechacierre is null) v on m.mobileid = v.mobileid
		WHERE m.mobileid in (select mobileid from @CentralZone)
		and s.companyid=@companyid and datediff(mi,ML.dategps,getdate())>=  70
		ORDER BY 5 desc
END

-- exec Fleets_GraficosDiarios_ObtenerNoTX_TPlan_TipoEstado_AES_IDC2 '20220628','20220705',1036,3





