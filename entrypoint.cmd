@echo off

REM Create and start DB instance
set DB_INSTANCE_NAME=MSSQLLocalDB
SqlLocalDB.exe create %DB_INSTANCE_NAME% -s

set DB_DATA_DIR=C:\data\%DB_INSTANCE_NAME%
set DB_NAME=AzureStorageEmulatorDb510

if not exist "%DB_DATA_DIR%" mkdir %DB_DATA_DIR%

REM If persistent DB data exists restore it, else create a new DB
if exist %DB_DATA_DIR%/%DB_NAME%.mdf (
  echo [debug] previous DB file found. Restoring DB.
  sqlcmd.exe -S "(localdb)\%DB_INSTANCE_NAME%" -i "C:\restore.sql"
) else (
  echo [debug] previous DB file not found. Creating New DB.  
  sqlcmd.exe -S "(localdb)\%DB_INSTANCE_NAME%" -i "C:\init.sql"
)

REM Init and start Emulator 
AzureStorageEmulator.exe init
AzureStorageEmulator.exe start

call %*