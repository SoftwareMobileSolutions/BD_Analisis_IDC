-- =============================================
-- Author:		ARMANDO VILLAVICENCIO
-- Create date: 27-05-2022
-- Description:	Summary de jobs diarios
-- =============================================
--EXEC [BI_ObtenerSummaryBitacora]
CREATE PROCEDURE [dbo].[BI_ObtenerSummaryBitacora]
--@bandera INT --1 Datos generales 2--Implementaciones
AS
BEGIN

				SELECT DATEADD(HOUR,-6,GETDATE()) AS dateinfo, (u.nombre + ' ' + u.apellido) as nombre, al.actividadlogid, al.actividadid, act.actividad, al.temaid,
				t.tema, al.fechainicio, al.fechafin,DATEDIFF(MINUTE,al.fechainicio, al.fechafin)AS difminutos,l.lugarid,im.Implementacion, CASE WHEN im.Implementacion IS NULL THEN 'Operativo' ELSE 'Implementación'END operacion, 
				CASE	WHEN l.lugar IS NULL THEN 'No Aplica' ELSE l.lugar END	AS lugar,
				al.comentarios, al.companyid,
				c.name cliente, al.horaderegistro, al.ultimamodificacion
				FROM [10.0.0.5].[Bitacora].[dbo].[actividadlog] al
				INNER JOIN [10.0.0.5].[Bitacora].[dbo].actividad act ON al.actividadid = act.actividadid
				INNER JOIN [10.0.0.5].[Bitacora].[dbo].tema t ON al.temaid = t.temaid
				INNER JOIN [10.0.0.5].[Bitacora].[dbo].cliente c ON al.companyid = c.companyid
				LEFT JOIN [10.0.0.5].[Bitacora].[dbo].lugar l ON al.lugarid = l.lugarid
				LEFT JOIN [10.0.0.5].[Bitacora].[dbo].usuario u ON al.userid = u.userid
				LEFT JOIN [10.0.0.5].[Bitacora].[dbo].[Implementaciones] im ON im.id = al.idImplementacion
				left join [10.0.0.5].[Bitacora].[dbo].[ImplementacionEstado] ie on im.EstadoID = ie.id
				left join [10.0.0.5].[Bitacora].[dbo].[Periodicidad] p on im.PeriodicidadID = p.id
				left join [10.0.0.5].[Bitacora].[dbo].[TipoImplementacion] til on til.id = im.TipoImplementacionID
				WHERE al.fechainicio  > DATEADD(year,-1,GETDATE())
			/*
			IF @bandera = 1 
			BEGIN
				SELECT (u.nombre + ' ' + u.apellido) as Nombre, al.actividadlogid, al.actividadid, act.actividad, al.temaid,
				t.tema, al.fechainicio, al.fechafin,l.lugarid,im.Implementacion,
				CASE	WHEN l.lugar IS NULL THEN 'No Aplica' ELSE l.lugar END	AS lugar,
				al.comentarios, al.companyid,
				c.name cliente, al.horaderegistro, al.ultimamodificacion
				FROM [10.0.0.5].[Bitacora].[dbo].[actividadlog] al
				INNER JOIN [10.0.0.5].[Bitacora].[dbo].actividad act ON al.actividadid = act.actividadid
				INNER JOIN [10.0.0.5].[Bitacora].[dbo].tema t ON al.temaid = t.temaid
				INNER JOIN [10.0.0.5].[Bitacora].[dbo].cliente c ON al.companyid = c.companyid
				LEFT JOIN [10.0.0.5].[Bitacora].[dbo].lugar l ON al.lugarid = l.lugarid
				LEFT JOIN [10.0.0.5].[Bitacora].[dbo].usuario u ON al.userid = u.userid
				LEFT JOIN [10.0.0.5].[Bitacora].[dbo].[Implementaciones] im ON im.id = al.idImplementacion
				left join [10.0.0.5].[Bitacora].[dbo].[ImplementacionEstado] ie on im.EstadoID = ie.id
				left join [10.0.0.5].[Bitacora].[dbo].[Periodicidad] p on im.PeriodicidadID = p.id
				left join [10.0.0.5].[Bitacora].[dbo].[TipoImplementacion] til on til.id = im.TipoImplementacionID


			END
			ELSE
			BEGIN
				SELECT (u.nombre + ' ' + u.apellido) as NombreCompleto, al.actividadlogid, al.actividadid, act.actividad, al.temaid,
				t.tema, al.fechainicio, al.fechafin,
				l.lugarid,
				CASE
					WHEN l.lugar IS NULL THEN 'No Aplica'
					ELSE l.lugar
				END
				AS lugar, 2 estado, 'Finalizada' estadoTxt, al.comentarios, al.companyid,
				c.name cliente, al.colorid, al.horaderegistro, al.ultimamodificacion, al.isAllDay, al.BackColor
				FROM [10.0.0.5].[Bitacora].[dbo].[actividadlog] al
				INNER JOIN [10.0.0.5].[Bitacora].[dbo].actividad act ON al.actividadid = act.actividadid
				INNER JOIN [10.0.0.5].[Bitacora].[dbo].tema t ON al.temaid = t.temaid
				INNER JOIN [10.0.0.5].[Bitacora].[dbo].cliente c ON al.companyid = c.companyid
				LEFT JOIN [10.0.0.5].[Bitacora].[dbo].lugar l ON al.lugarid = l.lugarid
				LEFT JOIN [10.0.0.5].[Bitacora].[dbo].usuario u ON al.userid = u.userid
			END 
			*/
END

