CREATE TABLE [dbo].[puertos_detalle] (
    [id]     INT          IDENTITY (1, 1) NOT NULL,
    [commid] VARCHAR (50) NULL,
    [puerto] INT          NOT NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

