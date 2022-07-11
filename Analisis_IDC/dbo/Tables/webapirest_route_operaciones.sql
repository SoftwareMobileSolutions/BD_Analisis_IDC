CREATE TABLE [dbo].[webapirest_route_operaciones] (
    [id]          INT           IDENTITY (1, 1) NOT NULL,
    [operacionid] VARCHAR (25)  NOT NULL,
    [idwroute]    INT           NOT NULL,
    [sentencia]   VARCHAR (MAX) NOT NULL,
    [aplicacion]  VARCHAR (100) NULL,
    [modulo]      VARCHAR (100) NULL,
    [descripcion] VARCHAR (MAX) NULL,
    CONSTRAINT [PK_webapirest_route_operaciones] PRIMARY KEY CLUSTERED ([operacionid] DESC)
);

