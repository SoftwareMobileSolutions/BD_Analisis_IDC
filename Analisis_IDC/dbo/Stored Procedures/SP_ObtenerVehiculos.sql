-- =============================================
-- Author:		FERNANDO MENDEZ
-- Create date: 2022-04-13
-- Description:	Procedimiento para devolver los vehículos activos con su nombre de subflota
-- =============================================

CREATE PROCEDURE  [dbo].[SP_ObtenerVehiculos]
	-- Add the parameters for the stored procedure here
@companyid int

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@companyid = 35)
		BEGIN
			select m.mobileid,m.[name] Alias,m.plate Placa, s.[name] Subflota
			from [10.0.0.9].[FleetManager].[dbo].mobile m 
			inner join [10.0.0.9].[FleetManager].[dbo].mobile_subfleet ms on m.mobileid=ms.mobileid
			inner join [10.0.0.9].[FleetManager].[dbo].subfleet s on s.subfleetid=ms.subfleetid and s.companyid=@companyid
			where m.status<>3 --and m.mobileid not in (2638,5099)
			group by m.mobileid,m.[name],m.plate,s.[name]
			order by s.[name],m.[name]
		END
	ELSE IF(@companyid = 899)
		BEGIN
			select m.mobileid,m.[name] Alias,m.plate Placa, s.[name] Subflota
			from [10.0.0.9].[FleetManager].[dbo].mobile m 
			inner join [10.0.0.9].[FleetManager].[dbo].mobile_subfleet ms on m.mobileid=ms.mobileid
			inner join [10.0.0.9].[FleetManager].[dbo].subfleet s on s.subfleetid=ms.subfleetid and s.companyid=@companyid
			where m.status<>3 
			group by m.mobileid,m.[name],m.plate,s.[name]
			order by s.[name],m.[name]
		END

	ELSE IF(@companyid = 1031)
		BEGIN
			select m.mobileid,m.[name] Alias,m.plate Placa, s.[name] Subflota
			from [10.0.0.4].[FM_BlueFenyx].[dbo].mobile m 
			inner join [10.0.0.4].[FM_BlueFenyx].[dbo].mobile_subfleet ms on m.mobileid=ms.mobileid
			inner join [10.0.0.4].[FM_BlueFenyx].[dbo].subfleet s on s.subfleetid=ms.subfleetid and s.companyid=@companyid
			where m.status<>3 --and m.mobileid not in (2638,5099)
			group by m.mobileid,m.[name],m.plate,s.[name]
			order by s.[name],m.[name]
		END
	ELSE 
	select m.mobileid,m.[name] Alias,m.plate Placa, s.[name] Subflota
	from [10.0.0.9].[FleetManager].[dbo].mobile m 
	inner join [10.0.0.9].[FleetManager].[dbo].mobile_subfleet ms on m.mobileid=ms.mobileid
	inner join [10.0.0.9].[FleetManager].[dbo].subfleet s on s.subfleetid=ms.subfleetid and s.companyid=@companyid
	where m.status<>3 --and m.mobileid not in (2638,5099)
	group by m.mobileid,m.[name],m.plate,s.[name]
	order by s.[name],m.[name]


END
