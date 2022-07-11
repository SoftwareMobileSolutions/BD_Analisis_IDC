
CREATE procedure [dbo].[check_jobs]
as


	create table #resultados9  (nombre varchar(100),run_date varchar(50),run_duration varchar(50),run_status varchar(50))
	
	declare @job table (i int identity(1,1),serverid int,nombre varchar(100))
	insert into @job select serverid,nombre from jobs 
	
	declare @server table (i int,nombre varchar (500))
	insert into @server(i,nombre)select distinct serverid,s.nombre from jobs j inner join servidor s on s.id=j.serverid
	delete @server where nombre='10.0.0.3'
	create table #resultadosJob  (id int identity(1,1),serverid int , server varchar(20),nombre varchar(100),run_date varchar(50),run_duration varchar(50),run_status varchar(50))
	declare @query varchar(500), @j varchar(500),@n int
	DECLARE @RunStoredProcSQL VARCHAR(1000);
	while ((select count(*) from @server)>0)
	begin
		declare @s varchar(20),@si int
		set @s=(select top 1 nombre from @server )
		set @si=(select top 1 i from @server where nombre=@s)
		
		while((select count(*) from @job where serverid=@si )>0)
		begin
			set @j=(select top 1 nombre from @job where serverid=@si)
			set @query=('insert into #resultadosJob(nombre,run_date,run_duration,run_status) EXEC ['+@s+'].[fleetmanager].[dbo].SP_ConsultarHistorialJob0 '+@j)
			
			SET @RunStoredProcSQL = '[fleetmanager].[dbo].SP_ConsultarHistorialJob0 '''+@j+'''';

			if(@si=1)--0.3
			begin
			--insert into #resultadosJob(nombre,run_date,run_duration,run_status)
			insert into jobs_today(nombre,rundate,runduration,status)
			EXEC (@RunStoredProcSQL) AT [10.0.0.3];
			end

			if(@si=2)--0.5
			begin
			--insert into #resultadosJob(nombre,run_date,run_duration,run_status)
			EXEC (@RunStoredProcSQL) AT [10.0.0.5];
			end

			
			if(@si=4)--0.9
			begin
			--insert into #resultadosJob(nombre,run_date,run_duration,run_status)
			EXEC (@RunStoredProcSQL) AT [10.0.0.9];
			end

			if(@si=8)--1.5
			begin
			--insert into #resultadosJob(nombre,run_date,run_duration,run_status)
			EXEC (@RunStoredProcSQL) AT [192.168.1.5];
			end

			print @query
			--execute(@query)
			set @n=(select max(id) from #resultadosJob )
			update #resultadosJob set serverid=@si , server= @s where id=@n
			delete from @job where nombre=@j and serverid=@si
		end

		delete from @server where nombre=@s

	end

	select * From #resultadosJob


	--exec  check_jobs
	/*

DECLARE @RunStoredProcSQL VARCHAR(1000);
declare @s varchar(20);
set @s='10.0.0.5'
SET @RunStoredProcSQL = '[fleetmanager].[dbo].SP_ConsultarHistorialJob0 BorrarToday';
--SELECT @RunStoredProcSQL --Debug
EXEC (@RunStoredProcSQL) AT [@s];
Print 'Procedure Executed';*/

--select * from servidor