USE [master]
GO
  IF EXISTS(SELECT * FROM sys.databases WHERE name = '$(DB_NAME)')
  BEGIN EXEC sp_detach_db ['$(DB_NAME)'] END;

  CREATE DATABASE ['$(DB_NAME)'] ON  PRIMARY 
  ( NAME = N'$(DB_NAME)_Data', FILENAME = N'$(DB_DATA_DIR)\$(DB_NAME).mdf' )
    LOG ON 
  ( NAME = N'$(DB_NAME)_Log', FILENAME = '$(DB_DATA_DIR)\$(DB_NAME)_log.ldf' )
  GO