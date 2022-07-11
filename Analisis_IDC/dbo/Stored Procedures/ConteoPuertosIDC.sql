

/*
creado por: Douglas Alfaro
Fecha: 20210225
Descripcion: SP creado que cuenta el numero de equipos por puerto de los comm para Bluefenyx y Fleetmanager del 0.5
*/



create procedure ConteoPuertosIDC @i int -- tiempo de evaluacion atras
as
declare @puertos table (puerto int  ,plataforma int,estado int)
declare @conteo table (puerto int,numDispositivosT int ,numDispositivosU int ,numDispositivos int ,dateinfo datetime)
declare @puerto int 
DECLARE @totalpuertos int,@ndt int,@ndu int, @nd200 int,@nd190 int,@fecha datetime

set @fecha=dateadd(hh,-6,getdate())


insert into @puertos
select puerto,baseid,0 from puertos

while ((select count(*) from @puertos where plataforma=1 and estado=0))>0 -- CONTEO KONTROL
begin 
	set @puerto= (select top 1 puerto from @puertos where plataforma=1 and estado=0)

	select @ndt=count(distinct commid) from [10.0.0.5].[fleetmanager].dbo.logip where direction='R' and dateserver>DATEADD(MI,-@i,GETDATE()) and port=@puerto and type='T'
	select @ndu=count(distinct commid) from [10.0.0.5].[fleetmanager].dbo.logip where direction='R' and dateserver>DATEADD(MI,-@i,GETDATE()) and port=@puerto and type='U'
	select @nd200=count(distinct commid) from [10.0.0.5].[fleetmanager].dbo.logip where direction='R' and dateserver>DATEADD(MI,-@i,GETDATE()) and port=@puerto

	insert into @conteo(puerto,numDispositivosT,numDispositivosU,numDispositivos,dateinfo)
	values (@puerto,@ndt,@ndu,@nd200,@fecha)


	update @puertos set estado=1 where puerto =@puerto
end

while ((select count(*) from @puertos where plataforma=2 and estado=0))>0 -- CONTEO BLUEFENYX
begin 
	set @puerto= (select top 1 puerto from @puertos where plataforma=2 and estado=0)

	select @ndt=count(distinct commid) from [10.0.0.5].[FM_bluefenyx].dbo.logip where direction='R' and dateserver>DATEADD(MI,-@i,GETDATE()) and port=@puerto and type='T'
	select @ndu=count(distinct commid) from [10.0.0.5].[FM_bluefenyx].dbo.logip where direction='R' and dateserver>DATEADD(MI,-@i,GETDATE()) and port=@puerto and type='U'
	select @nd200=count(distinct commid) from [10.0.0.5].[FM_bluefenyx].dbo.logip where direction='R' and dateserver>DATEADD(MI,-@i,GETDATE()) and port=@puerto

	insert into @conteo(puerto,numDispositivosT,numDispositivosU,numDispositivos,dateinfo)
	values (@puerto,@ndt,@ndu,@nd200,@fecha)


	update @puertos set estado=1 where puerto =@puerto
end

insert into puertos_summary(puerto,numDispositivosT,numDispositivosU,numDispositivos,dateinfo)
SELECT puerto,numDispositivosT,numDispositivosU,numDispositivos,dateinfo FROM @conteo

TRUNCATE TABLE puertos_lastreport

insert into puertos_lastreport(puerto,numDispositivosT,numDispositivosU,numDispositivos,dateinfo)
SELECT puerto,numDispositivosT,numDispositivosU,numDispositivos,dateinfo FROM @conteo

--EXEC ConteoPuertosIDC 5
