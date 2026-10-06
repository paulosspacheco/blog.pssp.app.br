@echo off
chcp 65001 >nul
title CopyToGDriver Installer

echo ======================================================
echo 🚀 Instalando CopyToGDriver (Windows)
echo ======================================================

setlocal
set "CUR_DIR=%~dp0"

if exist "%CUR_DIR%CopyToGDriver_PlatformInstaller.ps1" (
    echo 🧩 Executando instalador PowerShell...
    powershell -NoProfile -ExecutionPolicy Bypass -File "%CUR_DIR%CopyToGDriver_PlatformInstaller.ps1"
) else (
    echo ❌ ERRO: Instalador PowerShell não encontrado.
    echo Caminho esperado: %CUR_DIR%CopyToGDriver_PlatformInstaller.ps1
    pause
    exit /b 1
)

echo.
echo ✅ Instalação concluída.
pause
yToGDriver_PlatformInstaller.ps1"
