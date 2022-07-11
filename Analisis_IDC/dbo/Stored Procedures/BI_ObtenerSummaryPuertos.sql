-- =============================================
-- Author:		Armando Villavicencio
-- Create date: 27/04/202
-- Description: Obtener analisis de puertos de [10.0.0.5].FleetManager y  [10.0.0.4].FM_Bluefenyx
-- =============================================
/*
=============================================Power BI=============================================
let
    Origen = Json.Document(Web.Contents("https://bluefenyx.com/wapiidc/query/smsdadaadmin/4811a970b1ee42edc719c9675e757313/IDC_ObtenerPuertos/1")),
    #"Convertida en tabla" = Table.FromList(Origen, Splitter.SplitByNothing(), null, null, ExtraValues.Error),
    #"Se expandió Column1" = Table.ExpandRecordColumn(#"Convertida en tabla", "Column1", {"DateInfo", "Unidades", "Port","puertoText", "baseid", "base", "serverid", "servidor"}, {"DateInfo", "Unidades", "Port","puertoText" , "baseid", "base", "serverid", "servidor"}),
    #"Tipo cambiado" = Table.TransformColumnTypes(#"Se expandió Column1",{{"DateInfo", type datetime}, {"Unidades", Int64.Type}, {"Port", Int64.Type}, {"puertoText", type text},  {"baseid", Int64.Type}, {"base", type text}, {"serverid", Int64.Type}, {"servidor", type text}})
in
    #"Tipo cambiado"
====================================================================================================================================================================================
*/
--EXEC BI_ObtenerSummaryPuertos 1
CREATE PROCEDURE [dbo].[BI_ObtenerSummaryPuertos]
@bandera int
AS
BEGIN

IF @bandera = 0
begin
	SELECT  c.companyid,c.name company,m.mobileid,m.plate,m.name alias , D.deviceid,D.devicetypeid,D.name commid,dt.name devicetype,ml.latitude,ml.longitude,ml.dategps,ml.dateserver,
	dex.puerto,CONVERT(VARCHAR(25),dex.puerto) AS puertoText,dex.puertoFechaAct,1 baseid,'FleetManager' base , 2 serverid , '10.0.0.5' servidor
	FROM [10.0.0.5].FleetManager.dbo.deviceEx dex
	INNER JOIN [10.0.0.5].FleetManager.dbo.device d ON dex.deviceid = d.deviceid
	INNER JOIN [10.0.0.5].FleetManager.dbo.mobile m ON d.deviceid = m.deviceid
	INNER JOIN [10.0.0.5].FleetManager.dbo.mobile_lastreport ml  ON m.mobileid = ml.mobileid
	INNER JOIN [10.0.0.5].FleetManager.dbo.mobile_company mc ON m.mobileid = mc.mobileid
	INNER JOIN [10.0.0.5].FleetManager.dbo.company c ON mc.companyid = c.companyid
	INNER JOIN [10.0.0.5].FleetManager.dbo.devicetype dt on d.devicetypeid = dt.devicetypeid
	WHERE Puerto IS NOT NULL AND PuertoFechaAct > DATEADD(HOUR,-24,getdate())
	UNION
	SELECT  c.companyid,c.name company,m.mobileid,m.plate,m.name alias , D.deviceid,D.devicetypeid,D.name commid,dt.name devicetype,ml.latitude,ml.longitude,ml.dategps,ml.dateserver,
	dex.puerto,CONVERT(VARCHAR(25),dex.puerto) AS puertoText,dex.puertoFechaAct,2 baseid, 'FM_Bluefenyx', 10 serverid, '10.0.0.4' servidor
	FROM [10.0.0.4].FM_Bluefenyx.dbo.deviceEx dex
	INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.device d ON dex.deviceid = d.deviceid
	INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile m ON d.deviceid = m.deviceid
	INNER JOIN [10.0.0.5].FleetManager.dbo.mobile_lastreport ml  ON m.mobileid = ml.mobileid
	INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.mobile_company mc ON m.mobileid = mc.mobileid
	INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.company c ON mc.companyid = c.companyid
	INNER JOIN [10.0.0.4].FM_Bluefenyx.dbo.devicetype dt on d.devicetypeid = dt.devicetypeid
	WHERE Puerto IS NOT NULL AND PuertoFechaAct > DATEADD(HOUR,-24,getdate())
END
ELSE
BEGIN
		select dateadd(hour, datediff(hour, 0, dateserver), 0) as DateInfo ,count(distinct commid) AS Unidades, Port, CONVERT(varchar(10),port) puertoText ,1 baseid,'FleetManager' base , 2 serverid , '10.0.0.5' servidor
		from  [10.0.0.5].FleetManager.dbo.logip WHERE-- port = 1726 	AND	
		dateserver > DATEADD(HOUR,-24,GETDATE()) and direction = 'R'
		and type = 'U' group by dateadd(hour, datediff(hour, 0, dateserver), 0) ,port 				
		UNION	
		select dateadd(hour, datediff(hour, 0, dateserver), 0) as DateInfo ,count(distinct commid) AS Unidades, Port, CONVERT(varchar(10),port) puertoText ,2 baseid, 'FM_Bluefenyx', 10 serverid, '10.0.0.4' servidor
		from   [10.0.0.4].FM_Bluefenyx.dbo.logip WHERE-- port = 1726 		
		dateserver  > DATEADD(HOUR,-24,GETDATE()) and direction = 'R'
		and type = 'U' group by dateadd(hour, datediff(hour, 0, dateserver), 0) ,port 
		ORDER BY DateInfo DESC
		
END


END
/*
version
imei
telefono

*/
/*
SELECT  * FROM [10.0.0.5].FleetManager.dbo.mobile WHERE mobileid = 16452
SELECT  * FROM  [10.0.0.5].FleetManager.dbo.deviceex WHERE deviceid = 19623
SELECT TOP 10 * FROM [192.168.1.5].inventario.dbo.Dispositivo d WHERE d.IMEI ='357042066535858'
exec [192.168.1.5].FleetManager.dbo.[IDC_ListarEquiposConTecnologia]
EXEC [192.168.1.5].FleetManager.dbo.tecnologiaIDC '357042066535858'
*/