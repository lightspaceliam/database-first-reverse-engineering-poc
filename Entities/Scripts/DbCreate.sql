USE master;
GO
IF DB_ID(N'DbFirstReverseEngineering') IS NOT NULL
	DROP DATABASE DbFirstReverseEngineering;
GO

CREATE DATABASE DbFirstReverseEngineering
COLLATE SQL_Latin1_General_CP1_CI_AS;