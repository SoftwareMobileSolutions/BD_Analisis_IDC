CREATE TABLE [dbo].[jobs] (
    [jobid]             INT           IDENTITY (1, 1) NOT NULL,
    [serverid]          INT           NULL,
    [nombre]            VARCHAR (500) NULL,
    [activo]            INT           NULL,
    [promedioEjecucion] INT           NULL
);

