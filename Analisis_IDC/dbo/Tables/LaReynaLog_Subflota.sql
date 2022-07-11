CREATE TABLE [dbo].[LaReynaLog_Subflota] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [consulta]   VARCHAR (MAX) NULL,
    [mobileid]   INT           NULL,
    [subfleetid] INT           NULL,
    [dateinfo]   DATETIME      NULL
);

