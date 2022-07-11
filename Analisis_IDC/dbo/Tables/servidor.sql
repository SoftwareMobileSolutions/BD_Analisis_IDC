CREATE TABLE [dbo].[servidor] (
    [id]           INT           IDENTITY (1, 1) NOT NULL,
    [nombre]       VARCHAR (20)  NOT NULL,
    [descripcion]  VARCHAR (200) NULL,
    [TipoServidor] INT           NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

