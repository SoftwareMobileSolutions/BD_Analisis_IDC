CREATE TABLE [dbo].[SMSTools_CM_Registros] (
    [idRegistros] INT           IDENTITY (1, 1) NOT NULL,
    [idUser]      INT           NULL,
    [idActividad] INT           NULL,
    [DateServer]  DATETIME      NULL,
    [Comentario]  VARCHAR (200) NULL,
    [idCompany]   INT           NULL,
    [idEstado]    INT           NULL
);

