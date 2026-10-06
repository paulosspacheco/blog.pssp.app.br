@echo off
:: ===========================================================
:: Projeto: CopyToGDriver
:: Script: Run_Installer.bat
:: Função: Executa o instalador PowerShell (CopyToGDriver_Installer.ps1)
:: Autor: Paulo SSPacheco + ChatGPT (GPT-5)
:: Versão: 2.1.1
:: Set-ExecutionPolicy Bypass -Scope Process -Force
:: ===========================================================

chcp 65001 >nul
color 0A
title CopyToGDriver Installer (Windows - Git Bash)

echo ======================================================
echo 🚀 Iniciando instalador CopyToGDriver (Windows / Git Bash)
echo ======================================================
echo.

:: -----------------------------------------------------------
:: Detectar PowerShell
:: -----------------------------------------------------------
set "PWSH_PATH="
where powershell.exe >nul 2>&1 && set "PWSH_PATH=powershell.exe"
if not defined PWSH_PATH (
    where pwsh.exe >nul 2>&1 && set "PWSH_PATH=pwsh.exe"
)

if not defined PWSH_PATH (
    echo ❌ ERRO: Nenhuma versão do PowerShell foi encontrada no sistema.
    echo Instale o PowerShell e tente novamente.
    pause
    exit /b 1
)

:: -----------------------------------------------------------
:: Localizar o diretório atual (onde este BAT está)
:: -----------------------------------------------------------
set "SCRIPT_DIR=%~dp0"

:: -----------------------------------------------------------
:: Localizar o instalador PowerShell (duas pastas acima)
:: Estrutura: includes\windows\Run_Installer.bat
:: Sobe duas pastas → raiz → busca o arquivo Installer.ps1
:: -----------------------------------------------------------
set "INSTALLER_PATH=%SCRIPT_DIR%\CopyToGDriver_Installer.ps1"

if not exist "%INSTALLER_PATH%" (
    echo ❌ Instalador não encontrado em:
    echo %INSTALLER_PATH%
    echo Tentando subir duas pastas...
    pushd "%SCRIPT_DIR%\..\.."
    if exist "includes\windows\CopyToGDriver_Installer.ps1" (
        set "INSTALLER_PATH=%cd%\includes\windows\CopyToGDriver_Installer.ps1"
    )
    popd
)

if not exist "%INSTALLER_PATH%" (
    echo ❌ ERRO: Não foi possível localizar CopyToGDriver_Installer.ps1
    echo Certifique-se de que o arquivo está no caminho correto.
    pause
    exit /b 1
)

echo 🔍 Instalador localizado em:
echo %INSTALLER_PATH%
echo.

:: -----------------------------------------------------------
:: Executar com privilégios administrativos
:: -----------------------------------------------------------
echo 🧩 Solicitando permissões de administrador...
set "CMDLINE=-ExecutionPolicy Bypass -NoProfile -File \"%INSTALLER_PATH%\""

:: Verifica se o script já está elevado
net session >nul 2>&1
if %errorLevel% NEQ 0 (
    echo ⚙️ Elevando privilégios...
    powershell -Command "Start-Process %PWSH_PATH% -Verb RunAs -ArgumentList '%CMDLINE%'"
) else (
    echo ✅ Executando com privilégios administrativos já concedidos.
    %PWSH_PATH% %CMDLINE%
)

echo.
echo ======================================================
echo ✅ Instalação concluída (se não houve erros acima)
echo ======================================================
echo.
pause
exit /b 0

