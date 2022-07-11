
-- =============================================
-- Autor:		Víctor Fernando Cubías
-- Fecha:		18-06-2015
-- Descripción:	Función que obtiene el equivalente en HH:mm:ss tomando como base
--				el total de segundos enviados. (Desde las 00:00:00 a la fecha a evaluar)
-- =============================================
-- =============================================
-- Autor:		Fernando Mendez
-- Fecha:		13-04-2022
-- Descripción:	Se agrega al server 14 y a la DB Analisis_IDC, Función que obtiene el equivalente en HH:mm:ss tomando como base
-- =============================================
CREATE FUNCTION [dbo].[fn_formatoHoraMS]
(
	@segundos INT
)
returns varchar(8)
AS
BEGIN

	DECLARE @seg int,@min INT,@minutos int,@hora INT,@horaV varchar(2),@minutoV varchar(2),@segundoV varchar(2),
	@formato VARCHAR(8)
	set @seg = @segundos
	set @minutos = @seg / 60
	if @minutos = 0
	begin
		if @seg = 0
		begin			
			set @horaV = '00'
			set @minutoV = '00'
			set @segundoV = '00'			
			
		end
		else
		begin
			set @horaV = '00'
			set @minutoV = '00'
			if @seg < 10
			begin
				set @segundoV = '0'+convert(varchar(2),@seg)
			end
			else
			begin
				set @segundoV = convert(varchar(2),@seg)
			end						
		end
	end
	else
	begin
		set @hora = @minutos/60
		set @seg = @segundos % 60
		
		if @hora = 0
		begin			
			set @horaV = '00'
		end
		else
		begin
			if @hora < 10
			begin
				set @horaV = '0'+convert(varchar(2),@hora)
			end
			else
			begin
				set @horaV = convert(varchar(2),@hora)
			end
		end
		
		if @hora<24
		begin
			set @min = @minutos % 60
			if @min < 10
			begin
				set @minutoV = '0'+convert(varchar(2),@min)
			end
			else
			begin
				set @minutoV = convert(varchar(2),@min)
			end
		
			if @seg < 10
			begin
				set @segundoV = '0'+convert(varchar(2),@seg)
			end
			else
			begin
				set @segundoV = convert(varchar(2),@seg)
			end
		end
		else
		begin
			set @horaV = '23'
			set @minutoV = '59'
			set @segundoV = '59'
		end																											
	end
	set @formato = @horaV+':'+@minutoV+':'+@segundoV
	RETURN @formato				
END




