CREATE TABLE [dbo].[ReportesServer] (
    [idreporte]    INT           IDENTITY (1, 1) NOT NULL,
    [Nombre]       VARCHAR (60)  NULL,
    [Servidor]     INT           NULL,
    [HoraLocal]    VARCHAR (15)  NULL,
    [HoraServidor] VARCHAR (15)  NULL,
    [Company]      VARCHAR (25)  NULL,
    [Periodicidad] INT           NULL,
    [Ubicacion]    VARCHAR (200) NULL,
    [Registro]     VARCHAR (200) NULL,
    [Plataforma]   INT           NULL,
    [Descripcion]  VARCHAR (200) NULL,
    [Activo]       INT           NULL
);

