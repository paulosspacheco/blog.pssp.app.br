@echo off
:: ===========================================================
:: Projeto: CopyToGDriver
:: Script: Run_Uninstaller.bat
:: Função: Executa o desinstalador PowerShell (CopyToGDriver_UnInstaller.ps1)
:: Autor: Paulo SSPacheco + ChatGPT (GPT-5)
:: Versão: 2.1.1
:: ===========================================================

chcp 65001 >nul
color 0C
title CopyToGDriver Uninstaller (Windows - Git Bash)

echo ======================================================
echo 🧹 Iniciando desinstalação CopyToGDriver (Windows / Git Bash)
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
:: Procurar o desinstalador PowerShell na mesma pasta
:: -----------------------------------------------------------
set "UNINSTALLER_PATH=%SCRIPT_DIR%\CopyToGDriver_UnInstaller.ps1"

if not exist "%UNINSTALLER_PATH%" (
    echo ❌ Desinstalador não encontrado em:
    echo %UNINSTALLER_PATH%
    echo.
    pause
    exit /b 1
)

echo 🔍 Desinstalador localizado em:
echo %UNINSTALLER_PATH%
echo.

:: -----------------------------------------------------------
:: Confirmar intenção do usuário
:: -----------------------------------------------------------
set /p CONFIRM="Tem certeza que deseja desinstalar o CopyToGDriver? (s/N): "
if /I not "%CONFIRM%"=="S" (
    echo ❎ Operação cancelada.
    pause
    exit /b 0
)

:: -----------------------------------------------------------
:: Executar com privilégios administrativos
:: -----------------------------------------------------------
echo 🧩 Solicitando permissões de administrador...
set "CMDLINE=-ExecutionPolicy Bypass -NoProfile -File \"%UNINSTALLER_PATH%\""

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
echo ✅ Desinstalação concluída (se não houve erros acima)
echo ======================================================
echo.
pause
exit /b 0
