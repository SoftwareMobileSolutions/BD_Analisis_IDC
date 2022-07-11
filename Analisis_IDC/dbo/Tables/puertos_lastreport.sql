CREATE TABLE [dbo].[puertos_lastreport] (
    [id]               INT      IDENTITY (1, 1) NOT NULL,
    [puerto]           INT      NOT NULL,
    [numDispositivosT] INT      NULL,
    [numDispositivosU] INT      NULL,
    [numDispositivos]  INT      NULL,
    [dateinfo]         DATETIME NULL,
    PRIMARY KEY CLUSTERED ([id] ASC)
);

