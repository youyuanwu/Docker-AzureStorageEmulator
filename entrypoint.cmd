@echo off

REM Create and start DB instance
SqlLocalDB.exe create MSSQLLocalDB -s

REM If persistent DB data exists restore it, else create a new DB
if exist C:\data\AzureStorageEmulatorDb510.mdf (
  echo [debug] previous DB file found. Restoring DB.
  sqlcmd.exe -S "(localdb)\MSSQLLocalDB" -i "C:\restoreDB.sql"
) else (
  echo [debug] previous DB file not found. Creating New DB.  
  sqlcmd.exe -S "(localdb)\MSSQLLocalDB" -i "C:\createDB.sql"
)

REM Init and start Emulator 
AzureStorageEmulator.exe init
AzureStorageEmulator.exe start

call %*