/*
===========================================================================
Armando Villavicencio
2022 - 05 - 03 
Obtencion de reportes para Power BI
===========================================================================
*/
CREATE PROCEDURE [dbo].[BI_ObtenerSummaryReportes]
AS 
BEGIN
	SET LANGUAGE 'Spanish'
		select 'Bluefenyx' AS Plataforma ,rex.reporteid,c.companyid, c.name Compañia, rex.nombrereporte Reporte,   /*convert(varchar, rex.fechacreacion, 120)*/  
		(convert(varchar, DATEADD(HOUR,-6,rex.FechaCreacion) , 120) )'Fecha Creación',
		DATEADD(HOUR,-6,rex.FechaUltimaEjecucion) 'Ultima Ejecución', DATEADD(HOUR,-6,rex.FechaSiguienteEjecucion) 'Siguiente Ejecución',
		case rex.periodicidad when 1 then 'Diario' when 2 then 'Semanal' when 3 then 'Quincenal' when 4 then 'Mensual' when 6 then 'Trimestral'   end Periodicidad,
		case rex.periodicidad when 1 then '' when 2 then DATENAME(dw,rex.FechaReporte) ELSE '' end Día , rex.correos 'Correos Destino',
		CASE rex.Activo WHEN 1 THEN 'Activo'WHEN 2 THEN 'Ventana' WHEN 3 THEN 'Proceso IDC' ELSE 'Inactivo' END AS Estado,ISNULL(r.Nombre_Resp,'Sin Responsable') AS Responsable
		,REX.ConexionSQL	
		from  [10.0.0.5].[FleetManager].[dbo].reporteautomaticoexcel rex 
		 left JOIN [10.0.0.4].[FM_BlueFenyx].[dbo].Company_responsable cr ON rex.Companyid = cr.Companyid
		  left JOIN  [10.0.0.4].[FM_BlueFenyx].[dbo].Responsable r ON cr.Responsableid = r.Responsableid
		INNER join [10.0.0.4].[FM_BlueFenyx].[dbo].company c on rex.companyid=c.companyid 
		WHERE rex.ConexionSQL LIKE '%FM_Bluefenyx%'
	UNION
		select 'Kontrol' AS Plataforma ,rex.reporteid,c.companyid, c.name Compañia, rex.nombrereporte Reporte,   /*convert(varchar, rex.fechacreacion, 120)*/  
		(convert(varchar, DATEADD(HOUR,-6,rex.FechaCreacion) , 120) )'Fecha Creación',
		DATEADD(HOUR,-6,rex.FechaUltimaEjecucion) 'Ultima Ejecución', DATEADD(HOUR,-6,rex.FechaSiguienteEjecucion) 'Siguiente Ejecución',
		case rex.periodicidad when 1 then 'Diario' when 2 then 'Semanal' when 3 then 'Quincenal' when 4 then 'Mensual' when 6 then 'Trimestral'   end Periodicidad,
		case rex.periodicidad when 1 then '' when 2 then DATENAME(dw,rex.FechaReporte) ELSE '' end Día , rex.correos 'Correos Destino',
		CASE rex.Activo WHEN 1 THEN 'Activo'WHEN 2 THEN 'Ventana' WHEN 3 THEN 'Proceso IDC'  ELSE 'Inactivo' END AS Estado,ISNULL(r.Nombre_Resp,'Sin Responsable') AS Responsable
		,REX.ConexionSQL
		from  [10.0.0.5].[FleetManager].[dbo].reporteautomaticoexcel rex 
		 left JOIN [10.0.0.5].[FleetManager].[dbo].Company_responsable cr ON rex.Companyid = cr.Companyid
		  left JOIN  [10.0.0.5].[FleetManager].[dbo].Responsable r ON cr.Responsableid = r.Responsableid
		INNER join [10.0.0.5].[FleetManager].[dbo].company c on rex.companyid=c.companyid 
		WHERE rex.ConexionSQL LIKE '%FleetManager%'

END

-- ingenios , 