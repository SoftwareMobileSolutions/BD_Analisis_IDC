-- =============================================
-- Author:		Fernando Mendez
-- Create date: 2022-05-24
-- Description:	Retorna los usuarios de utilerias a Company Tecnologia (6) con Profileid (4)
-- =============================================
-- EXEC usuariosUtilerias
CREATE PROCEDURE [dbo].[usuariosUtilerias]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	--Creando tablas usuariosSMS, companyUsuariosSMS
	DECLARE  @usuarios as TABLE (dateinfo datetime,[userid] INT,[profileid] INT,[firstname] VARCHAR(50),[lastname] VARCHAR(50),[login] VARCHAR(50),[password] VARCHAR(50),[mailnotification] VARCHAR(50),[usertypeid] VARCHAR(50),[activo] INT,plataforma INT )	
	DECLARE  @compayusuarios AS TABLE (dateinfo DATETIME,[name] VARCHAR(50),[login] VARCHAR(50),[companyid] INT,[userid] INT,plataforma int)
	

	--Agregando datos a las tablas
	--INSERT INTO @usuarios (dateinfo,[userid],[profileid],[firstname],[lastname],[login],[password],[mailnotification],[usertypeid],[activo],plataforma)
	--SELECT GETDATE(),[userid],[profileid],[firstname],[lastname],[login],[password],[mailnotification],[usertypeid],[activo],1 FROM [10.0.0.5].[FleetManager].[dbo].[user] u WHERE userid IN (653,4959,5132,4014,1054,5052,6880,6665,5052,6666,6668,6669,6670,6671,6672,6673,6842,6883)
	--union	
	--SELECT GETDATE(),[userid],[profileid],[firstname],[lastname],[login],[password],[mailnotification],[usertypeid],[activo],2 FROM [10.0.0.4].[FM_Bluefenyx].[dbo].[user] WHERE userid  IN (653,3957,4375,4449,4450,4451,4452,4453,4454,4455,4849,4457,4818,4867)  ORDER BY userid ASC

	--INSERT INTO @compayusuarios (dateinfo,[name],[login],[companyid],[userid],plataforma)
	--SELECT GETDATE(),c.[name],U.[login],uc.companyid,uc.userid,1 FROM [10.0.0.5].[FleetManager].[dbo].user_company uc INNER JOIN [10.0.0.5].[FleetManager].[dbo].company c ON uc.companyid = c.companyid INNER JOIN [10.0.0.5].[FleetManager].[dbo].[user] u ON uc.userid = u.userid WHERE uc.userid IN (653,4959,5132,4014,1054,5052,6880,6665,5052,6666,6668,6669,6670,6671,6672,6673,6842,6883)
	--union
	--SELECT GETDATE(),c.[name],U.[login],uc.companyid,uc.userid,2 FROM [10.0.0.4].[FM_Bluefenyx].[dbo].user_company uc INNER JOIN [10.0.0.4].[FM_Bluefenyx].[dbo].company c ON uc.companyid = c.companyid INNER JOIN [10.0.0.4].[FM_Bluefenyx].[dbo].[user] u ON uc.userid = u.userid WHERE uc.userid IN (653,3957,4375,4449,4450,4451,4452,4453,4454,4455,4849,4457,4818,4867) ORDER BY userid ASC

	--Modificando el valor de companyid a 6 para el loa usuarios de Kontrol que estan en otra company 
	--UPDATE [10.0.0.5].[FleetManager].[dbo].user_company set companyid = 6 WHERE userid IN (653,4959,5132,4014,1054,5052,6880,6665,5052,6666,6668,6669,6670,6671,6672,6673,6842,6883)

	--Modificando el valor de companyid a 6 para el loa usuarios de Bluefenyx que estan en otra company 
	UPDATE [10.0.0.4].[FM_Bluefenyx].[dbo].user_company set companyid = 6 where userid IN (653,3957,4375,4449,4450,4451,4452,4453,4454,4455,4849,4457,4818,4867)  

	--Modificando el valor de profileid = 4 para los demas usuariosKontrol
	--UPDATE [10.0.0.5].[FleetManager].[dbo].[user] SET profileid = 4 WHERE userid = 6668
	--Modificando el valor de profileid = 4 para los demas usuariosBluefenyx
	UPDATE [10.0.0.4].[FM_Bluefenyx].[dbo].[user] SET profileid = 4 WHERE userid = 4452 


	--Enviando notificacion de resumen usuarios SMS
	--INSERT INTO FleetManager.dbo.[notification]([to],[subject],[body],[MailFormat])
	--VALUES('fernando.mendez@sms-open.com','Usuarios SMS', 'usuarios en company 6','text/html');

END

---SELECT * FROM [10.0.0.4].[FM_Bluefenyx].[dbo].[user] u WHERE userid IN (653,3957,4375,4449,4450,4451,4452,4453,4454,4455,4849,4457,4818,4867) 
