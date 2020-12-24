ARG BaseImageTag=ltsc2016
FROM mcr.microsoft.com/windows/servercore:${BaseImageTag}
MAINTAINER Boshi Lian <farmer1992@gmail.com>

ENV LOCAL_DB_URL https://download.microsoft.com/download/9/0/7/907AD35F-9F9C-43A5-9789-52470555DB90/ENU/SqlLocalDB.msi
RUN powershell -NoProfile -Command \
        Invoke-WebRequest %LOCAL_DB_URL% -OutFile SqlLocalDB.msi;

RUN msiexec /i SqlLocalDB.msi /qn /norestart IACCEPTSQLLOCALDBLICENSETERMS=YES

ENV AZ_STOR_EMU_URL https://download.visualstudio.microsoft.com/download/pr/87453e3b-79ac-4d29-a70e-2a37d39f2b12/f0e339a0a189a0d315f75a72f0c9bd5e/microsoftazurestorageemulator.msi

RUN powershell -NoProfile -Command \
        Invoke-WebRequest %AZ_STOR_EMU_URL% -TimeoutSec 600 -OutFile MicrosoftAzureStorageEmulator.msi;

RUN msiexec /i MicrosoftAzureStorageEmulator.msi /qn

# install choco
RUN powershell -NoProfile -Command \
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# RUN choco feature disable -n=allowGlobalConfirmation
# install sql cmd
RUN choco install sqlserver-cmdlineutils -y

RUN powershell -NoProfile -Command \
        Remove-Item -Force *.msi;


RUN setx /M AZ_STOR_EMU_HOME "%ProgramFiles(x86)%\Microsoft SDKs\Azure\Storage Emulator"
RUN setx /M PATH "%PATH%;%AZ_STOR_EMU_HOME%"

WORKDIR "C:\Program Files (x86)\Microsoft SDKs\Azure\Storage Emulator"

# have to use nginx as reverse proxy, or 400 bad hostname
#RUN powershell -NoProfile -Command \
#        "(Get-Content .\AzureStorageEmulator.exe.config) -replace 'http://127.0.0.1','http://localhost' | Out-File -Encoding utf8 .\AzureStorageEmulator.exe.config"

RUN powershell -NoProfile -Command \
        "(Get-Content .\AzureStorageEmulator.exe.config) -replace 'http://127.0.0.1:10000/','http://127.0.0.1:20000/' | Out-File -Encoding utf8 .\AzureStorageEmulator.exe.config"; \
        "(Get-Content .\AzureStorageEmulator.exe.config) -replace 'http://127.0.0.1:10001/','http://127.0.0.1:20001/' | Out-File -Encoding utf8 .\AzureStorageEmulator.exe.config"; \
        "(Get-Content .\AzureStorageEmulator.exe.config) -replace 'http://127.0.0.1:10002/','http://127.0.0.1:20002/' | Out-File -Encoding utf8 .\AzureStorageEmulator.exe.config";

# add config to change data storage location
ADD AzureStorageEmulator.5.10.config 'C:\Users\ContainerAdministrator\AppData\Local\AzureStorageEmulator\AzureStorageEmulator.5.10.config'

ADD entrypoint.cmd 'C:\entrypoint.cmd'
ADD createDB.sql 'C:\createDB.sql'
ADD restoreDB.sql 'C:\restoreDB.sql'
# RUN AzureStorageEmulator.exe init

WORKDIR "C:\nginx"

ENV NGX_URL https://nginx.org/download/nginx-1.12.0.zip
RUN powershell -NoProfile -Command \
        Invoke-WebRequest %NGX_URL% -OutFile nginx.zip; \
        Expand-Archive nginx.zip . ;

RUN powershell -NoProfile -Command \
        Copy-Item nginx-*\*.exe . ; \
        Remove-Item -Recurse nginx-* ; \        
        Remove-Item -Force nginx.zip;

RUN powershell -NoProfile -Command \
        mkdir logs ; \
        mkdir temp ;

ADD nginx.conf 'conf\nginx.conf'

EXPOSE 10000 10001 10002

ENTRYPOINT C:\entrypoint.cmd
CMD nginx.exe


