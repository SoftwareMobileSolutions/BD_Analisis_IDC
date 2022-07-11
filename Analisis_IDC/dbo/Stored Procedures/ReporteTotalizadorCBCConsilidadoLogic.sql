-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE ReporteTotalizadorCBCConsilidadoLogic 
	-- Add the parameters for the stored procedure here
@companyid as INT
,@fechaini as DATETIME
,@fechafin AS DATETIME

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

IF (@companyid = 35)
BEGIN
	select distinct s.[name] as Subflota,m.name as Alias, m.plate as Placa, pc.CodRuta,
	(case WHEN msp.Refidini = 0 THEN '' else (case when msp.Fechainiprodplantel >msp.Fechafinprodplantel then 'Sin salida plantel' else Convert(varchar(19),dateadd(hh,d.timezone,msp.Fechainiprodplantel),120) end) end) 'Hora salida plantel', 
	(case WHEN msp.Refidini = 0 THEN 'Sin salida de plantel' else (case when msp.Tiporefidini = 1 THEN (select namezone from [10.0.0.9].[FleetManager].[dbo].geozone where id = msp.Refidini) else (select Nombre from [10.0.0.9].[FleetManager].[dbo].Points where id = msp.Refidini) end)end) 'Referencia inicio',
	(case WHEN msp.Refidfin = 0 THEN '' else (case when msp.Fechainiprodplantel >msp.Fechafinprodplantel then '' else Convert(varchar(19),dateadd(hh,d.timezone,msp.Fechafinprodplantel),120) end) end) 'Hora llegada plantel',
	(case WHEN msp.Refidfin = 0 THEN 'Sin llegada a plantel' else (case when msp.Tiporefidfin = 1 THEN (select namezone from [10.0.0.9].[FleetManager].[dbo].geozone where id = msp.Refidfin) else (select Nombre from [10.0.0.9].[FleetManager].[dbo].Points where id = msp.Refidfin) end)end) 'Referencia fin'
	,(case when msp.Fechainiprodplantel >msp.Fechafinprodplantel then '' else dbo.fn_formatoHoraMS(datediff(SECOND,msp.Fechainiprodplantel,msp.Fechafinprodplantel)) end) as 'Tiempo fuera plantel'
	from [10.0.0.9].[FleetManager].[dbo].mobile_summaryPlantel msp
	inner join [10.0.0.9].[FleetManager].[dbo].mobile m on m.mobileid = msp.mobileid
	inner join [10.0.0.9].[FleetManager].[dbo].mobile_subfleet ms on ms.mobileid = m.mobileid
	inner join [10.0.0.9].[FleetManager].[dbo].subfleet s on s.subfleetid = ms.subfleetid
	inner JOIN [10.0.0.9].[FleetManager].[dbo].device d on d.deviceid = m.deviceid
	LEFT JOIN [10.0.0.5].FleetManager.dbo.PlanificacionCABCORP pc ON pc.mobileid = msp.mobileid AND pc.fecha = msp.dateinfo
	where s.companyid = @companyid and m.status <> 3 and msp.dateinfo BETWEEN @fechaini and @fechafin
	order by Subflota,Alias
END
	
END
