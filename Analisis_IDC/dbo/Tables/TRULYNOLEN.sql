CREATE TABLE [dbo].[TRULYNOLEN] (
    [Orden]        INT             NULL,
    [Subflota]     VARCHAR (50)    NULL,
    [Alias]        VARCHAR (50)    NULL,
    [Placa]        VARBINARY (MAX) NULL,
    [Referencia]   VARCHAR (50)    NULL,
    [Hora_ingreso] DATETIME2 (7)   NULL,
    [Hora_salida]  DATETIME2 (7)   NULL,
    [tiempo]       VARCHAR (50)    NULL,
    [lati]         VARCHAR (50)    NULL,
    [long]         VARCHAR (50)    NULL,
    [lat_s]        VARCHAR (50)    NULL,
    [long_s]       VARCHAR (50)    NULL
);

