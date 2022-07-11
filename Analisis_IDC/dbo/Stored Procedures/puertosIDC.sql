/*
creado por: Douglas Alfaro
Fecha: 20210225
Descripcion: SP creado para llenar catalogo de puertos
*/

create procedure puertosIDC 
as
declare @puertos table (puerto int ,tipo int ,plataforma int)

insert into @puertos(puerto,tipo,plataforma)
Select distinct port , (select top 1 devicetypeid from [10.0.0.5].[fleetmanager].dbo.device where name=l.CommID) tipo , 1
from  [10.0.0.5].[fleetmanager].dbo.logip l 
where Direction ='R' 
and DateServer >=dateadd(hh,-24,getdate()) 
and (select top 1 devicetypeid from  [10.0.0.5].[fleetmanager].dbo.device where name=l.CommID)  is not null 
and port not in (select puerto from puertos)  order by 1 asc


insert into @puertos(puerto,tipo,plataforma)
Select distinct port , (select top 1 devicetypeid from [10.0.0.5].[FM_bluefenyx].dbo.device where name=l.CommID) tipo , 2
from  [10.0.0.5].[FM_bluefenyx].dbo.logip l 
where Direction ='R' 
and DateServer >=dateadd(hh,-24,getdate()) 
and (select top 1 devicetypeid from  [10.0.0.5].[FM_bluefenyx].dbo.device where name=l.CommID)  is not null 
and port not in (select puerto from puertos)  order by 1 asc


if( ( select count(*) from @puertos)>0)
begin
	insert into puertos (puerto,devicetypeid,baseid)
	select puerto,tipo,plataforma from @puertos

end


-- exec puertosIDC
