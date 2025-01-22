@echo off

REM Check if .env file exists
IF NOT EXIST .env (
    echo Copying .env.example to .env...
    copy .env.example .env
    echo.
    echo WARNING: Please configure your .env file before running this script!
    echo.
    exit /b 1
)

REM Read components from .env file
for /f "tokens=2 delims==" %%a in ('type .env ^| findstr "DOCKER_USER"') do set DOCKER_USER=%%a
for /f "tokens=2 delims==" %%a in ('type .env ^| findstr "COMPOSE_PROJECT_NAME"') do set COMPOSE_PROJECT_NAME=%%a
set DOCKER_USER=%DOCKER_USER: =%
set COMPOSE_PROJECT_NAME=%COMPOSE_PROJECT_NAME: =%

REM Construct IMAGE_NAME
set IMAGE_NAME=%DOCKER_USER%/%COMPOSE_PROJECT_NAME%-web-api

REM Execute docker build
docker build -t %IMAGE_NAME%:latest -f .docker/aspnet/Dockerfile --build-arg USER_ID=1000 --build-arg GROUP_ID=1000 --build-arg ENVIRONMENT=development .
docker push %IMAGE_NAME%:latest
copy .env .deployment/.env

echo Build completed successfully!