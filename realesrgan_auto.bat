@echo off
setlocal EnableExtensions
chcp 65001 >nul
cd /d "%~dp0"

title Real-ESRGAN Drag and Drop (Imagem)

rem =========================
rem Configuracao
rem =========================
set "SCALE=4"
set "MODEL=realesrgan-x4plus"
set "OUT_FORMAT=png"
set "TILE=100"
set "THREADS=1:1:1"

set "REALESRGAN_EXE=%~dp0realesrgan-ncnn-vulkan.exe"
set "MODELS_DIR=%~dp0models"

if not exist "%REALESRGAN_EXE%" (
    echo [ERRO] Nao encontrei: "%REALESRGAN_EXE%"
    pause
    exit /b 1
)

if not exist "%MODELS_DIR%\realesrgan-x4plus.bin" (
    echo [ERRO] Nao encontrei os modelos em: "%MODELS_DIR%"
    pause
    exit /b 1
)

if "%~1"=="" (
    echo Arraste uma ou mais imagens para cima deste .bat.
    echo.
    echo Formatos: jpg jpeg png webp bmp tif tiff
    pause
    exit /b 0
)

echo ============================================
echo Real-ESRGAN - Arrastar e Soltar (Imagem)
echo ============================================
echo.

:loop
if "%~1"=="" goto :done
call :process_image "%~1"
shift
goto :loop

:done
echo.
echo Finalizado.
exit /b 0

:process_image
set "IN_FILE=%~1"
set "EXT=%~x1"
set "BASE=%~dpn1"

if not exist "%IN_FILE%" (
    echo [AVISO] Arquivo nao encontrado: "%IN_FILE%"
    echo.
    exit /b 0
)

if /I "%EXT%"==".jpg"  goto :run
if /I "%EXT%"==".jpeg" goto :run
if /I "%EXT%"==".png"  goto :run
if /I "%EXT%"==".webp" goto :run
if /I "%EXT%"==".bmp"  goto :run
if /I "%EXT%"==".tif"  goto :run
if /I "%EXT%"==".tiff" goto :run

echo [PULADO] Nao e imagem suportada: "%IN_FILE%"
echo.
exit /b 0

:run
set "OUT_FILE=%BASE%_HD.%OUT_FORMAT%"
echo [IMG] "%IN_FILE%"
"%REALESRGAN_EXE%" -i "%IN_FILE%" -o "%OUT_FILE%" -n "%MODEL%" -s %SCALE% -f %OUT_FORMAT% -m "%MODELS_DIR%" -t %TILE% -j %THREADS%
if errorlevel 1 (
    echo [ERRO] Falhou: "%IN_FILE%"
) else (
    echo [OK] "%OUT_FILE%"
)
echo.
exit /b 0
