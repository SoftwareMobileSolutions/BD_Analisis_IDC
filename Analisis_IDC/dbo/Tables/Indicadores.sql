CREATE TABLE [dbo].[Indicadores] (
    [Id]              INT           IDENTITY (1, 1) NOT NULL,
    [Indicador]       VARCHAR (100) NULL,
    [ServidorId]      INT           NULL,
    [DateServer]      DATETIME      NULL,
    [Activo]          INT           NULL,
    [RangoEvaluacion] INT           NULL,
    [Descripcion]     VARCHAR (MAX) NULL,
    [TipoIndicador]   INT           NULL,
    [BDConexion]      VARCHAR (100) NULL
);

