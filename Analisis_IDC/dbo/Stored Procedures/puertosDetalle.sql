
CREATE procedure puertosDetalle
as

declare @puertos table (puerto int,baseid int )
declare @puerto int

insert into @puertos(puerto,baseid)
select puerto,baseid from puertos 

while((select count(*) from @puertos where baseid=1)>0)
begin
	set @puerto =(select top 1 puerto from @puertos where baseid=1)

	insert into puertos_detalle(commid,puerto)
	select DISTINCT commid, @puerto from [10.0.0.5].[fleetmanager].dbo.logip where Direction='R' and port=@puerto and DateServer >=dateadd(hh,-24,getdate())

	delete from @puertos where puerto=@puerto
end


while((select count(*) from @puertos where baseid=2)>0)
begin
	set @puerto =(select top 1 puerto from @puertos where baseid=2)

	insert into puertos_detalle(commid,puerto)
	select DISTINCT commid, @puerto from [10.0.0.5].[FM_bluefenyx].dbo.logip where Direction='R' and port=@puerto and DateServer >=dateadd(hh,-24,getdate())

	delete from @puertos where puerto=@puerto
end

--EXEC puertosDetalle