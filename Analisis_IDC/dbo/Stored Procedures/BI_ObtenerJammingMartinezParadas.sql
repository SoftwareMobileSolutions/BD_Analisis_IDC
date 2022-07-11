/*
===========================================================================
Armando Villavicencio
2022 - 05 - 03 
Obtencion de reportes para Power BI
===========================================================================
*/
CREATE PROCEDURE [dbo].[BI_ObtenerJammingMartinezParadas]
AS 
BEGIN
SELECT * FROM paradasMartinez m
	DECLARE @RunStoredProcSQL VARCHAR(max);
				SET @RunStoredProcSQL ='declare @minutos int 
	set @minutos = -30
	SELECT DISTINCT s.name Subflota, M.[name] Vehiculo, M.plate Placa,
	DATEADD(HOUR,-6,dategpsini) FechaInico,DATEADD(HOUR,-6,dategpsend) FechaFin,sl.location as ubicacion,
	DATEDIFF(ss,dategpsini,dategpsend)/30 as Minutos,
	case when referencetype = -1 THEN ''----[  Fuera de Referencia  ]----'' WHEN referencetype = 1 THEN (SELECT TOP 1 namezone from geozone where id = referenceid) else (select TOP 1 nombre from points where id = referenceid) end Referencia,
	
	sl.latitude as Latitude,sl.longitude  as Longitude
	from status_logstops sls 
inner join status_log sl on sl.mobileid = sls.mobileid and sl.dategps = sls.dategpsini 
INNER JOIN mobile M ON sls.mobileid = M.mobileid
INNER JOIN mobile_company mc ON m.mobileid = mc.mobileid
INNER JOIN company c ON mc.companyid = c.companyid 
INNER JOIN mobile_subfleet ms ON M.mobileid = ms.mobileid 
INNER JOIN subfleet s ON ms.subfleetid = s.subfleetid
INNER JOIN Geozonebycompany gbc ON gbc.companyid = c.companyid
INNER JOIN Geozone g ON gbc.geozoneid = g.ID
	WHERE sls.mobileid IN (SELECT M.mobileid FROM mobile M INNER JOIN mobile_company mc ON M.mobileid = mc.mobileid WHERE mc.companyid = 458 AND M.status<>3)
	and sls.dategpsini > dateadd(day,-1,getdate())
	and referencetype = -1 	
	ORDER BY FechaInico DESC'
	--INSERT INTO paradasMartinez
EXEC (@RunStoredProcSQL) AT [10.0.0.5];

/*
		DECLARE @RunStoredProcSQL VARCHAR(max);
				SET @RunStoredProcSQL ='SELECT mobile.plate,sl.* FROM status_log sl 
	INNER JOIN mobile ON sl.mobileid = mobile.mobileid
	WHERE sl.mobileid IN (SELECT DISTINCT mobileid FROM status_log sl 
	WHERE sl.statusid IN (21) AND sl.dategps > DATEADD(DAY,-30,getdate()))
	and sl.dategps > DATEADD(DAY,-7,getdate())
	ORDER BY sl.dategps DESC '
		EXEC (@RunStoredProcSQL) AT [10.0.0.5];*/
END

-- ingenios , 
