CREATE TABLE [dbo].[SMSTools_CM_LogRegistros] (
    [idRegistros] INT           IDENTITY (1, 1) NOT NULL,
    [idUser]      INT           NULL,
    [idActividad] INT           NULL,
    [DateServer]  DATETIME      NULL,
    [Comentario]  VARCHAR (200) NULL,
    [idCompany]   INT           NULL,
    [idEstado]    INT           NULL
);

