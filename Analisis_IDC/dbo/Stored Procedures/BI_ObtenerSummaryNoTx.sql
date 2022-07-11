
CREATE PROCEDURE [dbo].[BI_ObtenerSummaryNoTx]
AS 
BEGIN
    SELECT
  dateinfo
 ,ingenioText
 ,sust.mobileid
 ,ingenio
 ,sust.tipoplan
 ,sust.companyid
 ,compania
 ,subflota
 ,estado
 ,placa
 ,alias
 ,dispositivo
 ,tipodispositivo
 ,imei
 ,icc
 ,lineacelular
 ,FechaUltimaTX
 ,diasDif
 ,ubicacion
  ,CASE when responsable IS NULL AND plataforma = 2 THEN 'Lorena Flores'  WHEN plataforma = 1 THEN responsable   END as responsable
 ,estadoactual
 ,diagnostico
 ,ticketid
 ,fechaultimagestion
 ,comentarios
 ,CASE when plataforma = 1 THEN 'Kontrol' when plataforma = 2 THEN 'Bluefenyx' else '-' END AS plataforma
   ,CASE when  lr.dategps < dateadd(mi,-70,getdate()) THEN 'Sin Transmisión' ELSE 'Transmitiendo' END AS 'EstadoUnidades'	
  FROM Analisis_IDC.dbo.Summary_UnidadesSinTX sust
  INNER JOIN [10.0.0.5].FleetManager.dbo.mobileLastReport lr ON  sust.mobileid = lr.mobileid
  WHERE plataforma = 1 

  UNION
    SELECT
   dateinfo
 ,ingenioText
 ,sust.mobileid
 ,ingenio
 ,sust.tipoplan
 ,sust.companyid
 ,compania
 ,subflota
 ,estado
 ,placa
 ,alias
 ,dispositivo
 ,tipodispositivo
 ,imei
 ,icc
 ,lineacelular
 ,FechaUltimaTX
 ,diasDif
 ,ubicacion
  ,CASE when responsable IS NULL AND plataforma = 2 THEN 'Lorena Flores'  WHEN plataforma = 1 THEN responsable   END as responsable
 ,estadoactual
 ,diagnostico
 ,ticketid
 ,fechaultimagestion
 ,comentarios
 ,CASE when plataforma = 1 THEN 'Kontrol' when plataforma = 2 THEN 'Bluefenyx' else '-' END AS plataforma
   ,CASE when  lr.dategps < dateadd(mi,-70,getdate()) THEN 'Sin Transmisión' ELSE 'Transmitiendo' END AS 'EstadoUnidades'	
  FROM Analisis_IDC.dbo.Summary_UnidadesSinTX sust
  INNER JOIN [10.0.0.4].FM_BlueFenyx.dbo.mobileLastReport lr ON  sust.mobileid = lr.mobileid
  WHERE plataforma = 2  

  
END

