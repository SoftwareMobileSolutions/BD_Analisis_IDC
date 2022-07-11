-- =============================================
-- Author:		Armando Villavicencio
-- Create date: 27/04/202
-- Description: Obtener analisis de puertos de [10.0.0.5].FleetManager y  [10.0.0.4].FM_Bluefenyx
-- =============================================
CREATE PROCEDURE [dbo].[SP_Summary_Puertos]

AS
BEGIN

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