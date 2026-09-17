@echo off
cd /d "%~dp0" || exit /b 1

docker compose stop

exit /b %errorlevel%
