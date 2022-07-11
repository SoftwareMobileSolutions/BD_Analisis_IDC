CREATE TABLE [dbo].[Indicadores_Summary] (
    [Id]           INT           IDENTITY (1, 1) NOT NULL,
    [DateServer]   DATETIME      NULL,
    [DateInfo]     DATETIME      NULL,
    [ServidorId]   INT           NULL,
    [IndicadorId]  INT           NULL,
    [Verificacion] SMALLINT      NULL,
    [Descripcion]  VARCHAR (MAX) NULL
);

