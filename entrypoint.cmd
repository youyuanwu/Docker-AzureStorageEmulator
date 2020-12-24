@echo off

set DB_INSTANCE_NAME=MSSQLLocalDb
set DB_DATA_DIR=C:\data
set DB_NAME=AzureStorageEmulatorDb510

REM In win server 2019 sqlcmd has permission issue creating files without change permission
echo [entrypoint] Change C:\data permission.
icacls "C:\data" /grant Everyone:M
if not exist "%DB_DATA_DIR%" mkdir %DB_DATA_DIR%

echo [entrypoint] Create and start DB instance %DB_INSTANCE_NAME%.
SqlLocalDB.exe create %DB_INSTANCE_NAME% -s

REM If persistent DB data exists restore it, else create DB with fixed file location
if exist %DB_DATA_DIR%/%DB_NAME%.mdf (
  echo [entrypoint] Previous DB file found. Restoring DB.
  sqlcmd.exe -S "(localdb)\%DB_INSTANCE_NAME%" -i "C:\restore.sql"
) else (
  echo [entrypoint] Previous DB file not found. Creating New DB.  
  sqlcmd.exe -S "(localdb)\%DB_INSTANCE_NAME%" -i "C:\init.sql"
)

REM Init and start Emulator
echo [entrypoint] Init and start AzureStorageEmulator. 
AzureStorageEmulator.exe init
AzureStorageEmulator.exe start

echo [entrypoint] AzureStorageEmulator is started and ready.
call %*