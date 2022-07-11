CREATE TABLE [dbo].[paradasMartinez] (
    [id]         INT           IDENTITY (1, 1) NOT NULL,
    [Subflota]   VARCHAR (200) NULL,
    [Vehiculo]   VARCHAR (200) NULL,
    [Placa]      VARCHAR (200) NULL,
    [FechaInico] DATETIME      NULL,
    [FechaFin]   DATETIME      NULL,
    [ubicacion]  VARCHAR (MAX) NULL,
    [Minutos]    INT           NULL,
    [Referencia] VARCHAR (200) NULL,
    [Latitude]   REAL          NULL,
    [longitude]  REAL          NULL
);

