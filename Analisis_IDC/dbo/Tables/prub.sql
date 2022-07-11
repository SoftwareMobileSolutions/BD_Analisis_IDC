CREATE TABLE [dbo].[prub] (
    [id]     INT           NULL,
    [nombre] VARCHAR (MAX) NULL
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER historico_prub 
   ON  prub
   AFTER insert
AS 
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	 DECLARE @id INT, @nombre VARCHAR(max)

	 	declare dato cursor for 
			SELECT
			id,nombre
			from inserted 
	  open dato
	 fetch next from dato into @id ,@nombre
	 while (@@fetch_status=0)
	begin  
	    -- Insert statements for trigger here
	
	--select @id_Otro_software = userid FROM [Bitacora_new].[dbo].[usuario] where [id_Otro_software] = @id_Otro_software

	insert into prub_log (id,nombre)
	values (@id,@nombre)
	fetch next from dato into @id,@nombre
	end    
    close dato
	deallocate dato
    -- Insert statements for trigger here

END
