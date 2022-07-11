CREATE TABLE [dbo].[base] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [servidorid]  INT           NOT NULL,
    [nombre]      VARCHAR (20)  NOT NULL,
    [descripcion] VARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

