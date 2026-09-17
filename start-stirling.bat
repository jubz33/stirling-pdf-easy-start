@echo off
cd /d "%~dp0" || exit /b 1

docker compose up -d
if errorlevel 1 (
    echo Could not start Stirling PDF. Check that Docker Desktop is running.
    pause
    exit /b 1
)

timeout /t 5 /nobreak >nul

start "" http://localhost:8080

exit /b 0
