@echo off
REM Pull latest changes from git
git pull
if %ERRORLEVEL% neq 0 (
    echo Error occurred during git pull.
    exit /b %ERRORLEVEL%
)


REM Build and upload using PlatformIO
C:\Users\ankua\.platformio\penv\Scripts\pio.exe run -t upload
if %ERRORLEVEL% neq 0 (
    echo Error occurred during PlatformIO upload.
    exit /b %ERRORLEVEL%
)

REM Show git diff
git diff
if %ERRORLEVEL% neq 0 (
    echo Error occurred during git diff.
    exit /b %ERRORLEVEL%
)

REM Start arduino-cli monitor
C:\Users\ankua\Desktop\arduino\arduino-cli.exe monitor -p COM5
if %ERRORLEVEL% neq 0 (
    echo Error occurred while starting arduino-cli monitor.
    exit /b %ERRORLEVEL%
)
