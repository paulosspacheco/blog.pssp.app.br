@echo off
chcp 65001 >nul
title Build - CopyToGDriver Installer

echo ======================================================
echo 🧱 Iniciando empacotamento CopyToGDriver (Windows)
echo ======================================================

setlocal ENABLEDELAYEDEXPANSION

:: Pasta onde está este build.bat (packagers\windows)
set "BASE_DIR=%~dp0"

:: Raiz do projeto (dois níveis acima de packagers\windows)
for %%I in ("%BASE_DIR%..\..") do set "PROJECT_ROOT=%%~fI"

:: Arquivos do empacotador
set "CONFIG_FILE=%BASE_DIR%CopyToGDriver_7zSFX_Config.txt"
set "SFX_MODULE=%BASE_DIR%7z.sfx"
set "OUTPUT=%BASE_DIR%CopyToGDriver_Setup.exe"
set "TEMP_ARCHIVE=%BASE_DIR%CopyToGDriver.7z"

:: Detectar 7z.exe
set "SEVENZIP_EXE="
if exist "C:\Program Files\7-Zip\7z.exe" set "SEVENZIP_EXE=C:\Program Files\7-Zip\7z.exe"
if exist "C:\Program Files (x86)\7-Zip\7z.exe" set "SEVENZIP_EXE=C:\Program Files (x86)\7-Zip\7z.exe"
if not defined SEVENZIP_EXE if exist "%BASE_DIR%7z.exe" set "SEVENZIP_EXE=%BASE_DIR%7z.exe"

if not defined SEVENZIP_EXE (
    echo ❌ ERRO: 7z.exe não encontrado.
    echo    Procure em:
    echo      C:\Program Files\7-Zip\7z.exe
    echo      ou C:\Program Files (x86)\7-Zip\7z.exe
    pause
    exit /b 1
)

:: Verificações básicas
if not exist "%CONFIG_FILE%" (
    echo ❌ ERRO: Arquivo de configuracao SFX não encontrado:
    echo     %CONFIG_FILE%
    pause
    exit /b 1
)

if not exist "%SFX_MODULE%" (
    echo ❌ ERRO: Modulo SFX 7z.sfx não encontrado em:
    echo     %SFX_MODULE%
    pause
    exit /b 1
)

if not exist "%PROJECT_ROOT%" (
    echo ❌ ERRO: Raiz do projeto não encontrada:
    echo     %PROJECT_ROOT%
    pause
    exit /b 1
)

echo 📂 Raiz do projeto: %PROJECT_ROOT%

:: ------------------------------------------------------
:: 1) Garantir que install.bat estará na raiz do pacote
::    (o SFX vai rodar esse arquivo)
:: ------------------------------------------------------
if not exist "%BASE_DIR%install.bat" (
    echo ❌ ERRO: install.bat não encontrado em:
    echo     %BASE_DIR%install.bat
    pause
    exit /b 1
)

echo 🔗 Copiando install.bat para a raiz do projeto...
copy /Y "%BASE_DIR%install.bat" "%PROJECT_ROOT%\install.bat" >nul

:: ------------------------------------------------------
:: 2) Compactar o projeto em um .7z
::    Excluindo pastas de backup/packagers/dist
:: ------------------------------------------------------
echo 🗜️  Compactando arquivos do projeto...

cd /d "%PROJECT_ROOT%"

"%SEVENZIP_EXE%" a -t7z "%TEMP_ARCHIVE%" * -mx9 ^
    -xr!backup ^
    -xr!packagers ^
    -xr!dist ^
    -xr!*.lpi ^
    -xr!*.lps ^
    -xr!*.lpr >nul

if errorlevel 1 (
    echo ❌ ERRO: Falha ao criar o arquivo .7z
    cd /d "%BASE_DIR%"
    del "%PROJECT_ROOT%\install.bat" >nul 2>&1
    pause
    exit /b 1
)

cd /d "%BASE_DIR%"

:: ------------------------------------------------------
:: 3) Montar o SFX final: SFX + config + payload.7z
:: ------------------------------------------------------
echo 🧩 Criando instalador SFX...

if exist "%OUTPUT%" del "%OUTPUT%" >nul 2>&1

copy /b "%SFX_MODULE%" + "%CONFIG_FILE%" + "%TEMP_ARCHIVE%" "%OUTPUT%" >nul

if exist "%OUTPUT%" (
    echo ✅ Instalador criado com sucesso!
    echo 📦 Arquivo: %OUTPUT%
) else (
    echo ❌ Falha ao gerar instalador final.
    del "%TEMP_ARCHIVE%" >nul 2>&1
    del "%PROJECT_ROOT%\install.bat" >nul 2>&1
    pause
    exit /b 1
)

:: Limpar temporários
del "%TEMP_ARCHIVE%" >nul 2>&1
del "%PROJECT_ROOT%\install.bat" >nul 2>&1

echo.
echo 🚀 Para testar o instalador, execute:
echo     "%OUTPUT%"
echo ======================================================
pause
endlocal

