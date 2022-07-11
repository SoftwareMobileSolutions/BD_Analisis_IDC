CREATE procedure migrarDeviceex
as

print 'truncate deviceex5'
EXEC [10.0.0.5].[fleetmanager].sys.sp_executesql N'TRUNCATE TABLE dbo.deviceex5'

print 'Insert deviceex5'
insert into [10.0.0.5].[fleetmanager].[dbo].deviceex5 (deviceid,tipoequipoid,Num_SIM,CodEquipo,LineaCelular,SerialEquipo,IMEI,CodCliente,FechaActivacion,FechaExpiracion,activo,vrid,EsReprogramado,Observaciones,TipoServicioID)
select deviceid,tipoequipoid,Num_SIM,CodEquipo,LineaCelular,SerialEquipo,IMEI,CodCliente,FechaActivacion,FechaExpiracion,activo,vrid,EsReprogramado,Observaciones,TipoServicioID from [192.168.1.5].[fleetmanager].[dbo].DEVICEEX

/*SELECT * INTO [10.0.0.5].[fleetmanager].[dbo].deviceex5
FROM  [192.168.1.5].[fleetmanager].[dbo].DEVICEEX;
*/
print 'Update'
/*UPDATE [10.0.0.5].[fleetmanager].[dbo].deviceex 
SET
	--deviceex.tipoequipoid=deviceex5.tipoequipoid,
	deviceex.Num_SIM=deviceex5.Num_SIM,
	deviceex.CodEquipo=deviceex5.CodEquipo,
	deviceex.LineaCelular=deviceex5.LineaCelular,
	deviceex.SerialEquipo=deviceex5.SerialEquipo,
	deviceex.IMEI=deviceex5.IMEI,
	deviceex.CodCliente=deviceex5.CodCliente,
	deviceex.FechaActivacion=deviceex5.FechaActivacion,
	deviceex.FechaExpiracion=deviceex5.FechaExpiracion,
	--deviceex.activo=deviceex5.activo,
	--deviceex.vrid=deviceex5.vrid,
	deviceex.EsReprogramado=deviceex5.EsReprogramado
	--deviceex.Observaciones=deviceex5.Observaciones
FROM
    [10.0.0.5].[fleetmanager].[dbo].deviceex 
INNER JOIN
    [10.0.0.5].[fleetmanager].[dbo].deviceex5
ON
    deviceex.deviceid = deviceex5.deviceid

	*/
--exec migrarDeviceex
-- select * from /*[10.0.0.5].*/[fleetmanager].[dbo].deviceex5

--select * from deviceex where deviceid between 37 and 45

--update deviceex set imei='' where  deviceid between 37 and 45



