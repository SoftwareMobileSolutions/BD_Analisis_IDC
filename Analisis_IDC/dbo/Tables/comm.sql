CREATE TABLE [dbo].[comm] (
    [id]          INT            IDENTITY (1, 1) NOT NULL,
    [nombre]      VARCHAR (500)  NOT NULL,
    [puerto]      INT            NOT NULL,
    [baseid]      INT            NOT NULL,
    [servidorid]  INT            NOT NULL,
    [T]           INT            NULL,
    [U]           INT            NULL,
    [descripcion] VARCHAR (1000) NULL,
    [dateinfo]    DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

