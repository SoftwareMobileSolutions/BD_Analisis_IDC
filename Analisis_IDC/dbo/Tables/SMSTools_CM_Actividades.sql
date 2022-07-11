CREATE TABLE [dbo].[SMSTools_CM_Actividades] (
    [idActividad]    INT           IDENTITY (1, 1) NOT NULL,
    [NombreActivdad] VARCHAR (75)  NULL,
    [Descripcion]    VARCHAR (250) NULL,
    [idCategoria]    INT           NULL,
    [Periodicidad]   INT           NULL,
    [dias]           VARCHAR (30)  NULL,
    [Turno]          INT           NULL,
    [TiempoEstimado] VARCHAR (100) NULL,
    [Correos]        VARCHAR (250) NULL,
    [Activo]         INT           NULL
);

