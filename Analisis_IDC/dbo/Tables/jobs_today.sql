CREATE TABLE [dbo].[jobs_today] (
    [Id]          INT           IDENTITY (1, 1) NOT NULL,
    [Stepid]      INT           NULL,
    [Mensaje]     VARCHAR (MAX) NULL,
    [DateInfo]    DATETIME      NULL,
    [RunDuration] TIME (7)      NULL,
    [Run_Status]  VARCHAR (30)  NULL,
    [ServerId]    INT           NULL,
    [JobId]       INT           NULL,
    [Step_Name]   VARCHAR (500) NULL
);

