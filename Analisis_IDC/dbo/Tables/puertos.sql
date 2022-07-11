CREATE TABLE [dbo].[puertos] (
    [puerto]       INT           NOT NULL,
    [devicetypeid] INT           NULL,
    [baseid]       INT           NOT NULL,
    [T]            INT           NULL,
    [U]            INT           NULL,
    [uso]          VARCHAR (500) NULL,
    PRIMARY KEY CLUSTERED ([puerto] ASC)
);

