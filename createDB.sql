USE [master]
GO
  IF NOT EXISTS(SELECT * FROM sys.databases WHERE name = 'AzureStorageEmulatorDb510')
  BEGIN
    CREATE DATABASE [AzureStorageEmulatorDb510] ON  PRIMARY 
    ( NAME = N'AzureStorageEmulatorDb510_Data', FILENAME = N'C:\data\AzureStorageEmulatorDb510.mdf' , SIZE = 167872KB , MAXSIZE = UNLIMITED, FILEGROWTH = 16384KB )
     LOG ON 
    ( NAME = N'AzureStorageEmulatorDb510_Log', FILENAME = N'C:\data\AzureStorageEmulatorDb510_log.ldf' , SIZE = 2048KB , MAXSIZE = 2048GB , FILEGROWTH = 16384KB )
  END
  GO