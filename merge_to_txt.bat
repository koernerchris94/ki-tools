@echo off
REM UTF-8 Codepage setzen
chcp 65001 >nul

set "SCRIPT_DIR=%~dp0"
REM Backslash am Ende entfernen
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "OUTPUT_FILE=%SCRIPT_DIR%\alles.txt"
type nul > "%OUTPUT_FILE%"

set "TMP_FILE=%TEMP%\filelist_%RANDOM%.txt"
type nul > "%TMP_FILE%"

REM 1. Dateien finden
for /f "delims=" %%F in ('dir /s /b /a-d "%SCRIPT_DIR%" ^| findstr /v /i /c:"\node_modules\\" /c:"\.git\\" /c:"\dist\\" /c:"\build\\" /c:"\alles.txt"') do (
    call :CheckFile "%%F"
)

goto :ProcessFiles

:CheckFile
set "FULL_PATH=%~1"
set "EXT=%~x1"
set "NAME=%~nx1"
set "MATCH=0"

REM Überprüfung Dateiendungen
for %%A in (.tex .cls .conf .css .dockerignore .gitignore .html .ini .js .json .jsx .md .py .ts .tsx .txt .vb .vbproj .xml .yml .prisma .lock .yaml .mjs .cjs) do (
    if /I "%EXT%"=="%%A" set "MATCH=1"
)
REM Überprüfung Dateinamen
if /I "%NAME%"=="LICENSE" set "MATCH=1"
if /I "%NAME%"=="Dockerfile" set "MATCH=1"

if "%MATCH%"=="1" (
    setlocal enabledelayedexpansion
    >>"%TMP_FILE%" echo !FULL_PATH!
    endlocal
)
exit /b

:ProcessFiles
REM Sortieren
set "SORTED_TMP=%TEMP%\filelist_sorted_%RANDOM%.txt"
sort "%TMP_FILE%" /o "%SORTED_TMP%"

REM 2. Strukturverzeichnis erstellen
>>"%OUTPUT_FILE%" echo ^<directory_structure^>
for /f "usebackq delims=" %%F in ("%SORTED_TMP%") do (
    set "FULL_PATH=%%F"
    setlocal enabledelayedexpansion
    set "REL_PATH=!FULL_PATH:%SCRIPT_DIR%\=!"
    set "REL_PATH=!REL_PATH:\=/!"
    >>"%OUTPUT_FILE%" echo - !REL_PATH!
    endlocal
)
>>"%OUTPUT_FILE%" echo ^</directory_structure^>
>>"%OUTPUT_FILE%" echo.
>>"%OUTPUT_FILE%" echo.

REM 3. Datei-Inhalte anhängen
>>"%OUTPUT_FILE%" echo ^<file_contents^>
for /f "usebackq delims=" %%F in ("%SORTED_TMP%") do (
    set "FULL_PATH=%%F"
    setlocal enabledelayedexpansion
    set "REL_PATH=!FULL_PATH:%SCRIPT_DIR%\=!"
    set "REL_PATH=!REL_PATH:\=/!"
    >>"%OUTPUT_FILE%" echo === !REL_PATH! ===
    endlocal
    
    type "%%F" >> "%OUTPUT_FILE%"
    
    >>"%OUTPUT_FILE%" echo.
    >>"%OUTPUT_FILE%" echo.
)
>>"%OUTPUT_FILE%" echo ^</file_contents^>

del "%TMP_FILE%"
del "%SORTED_TMP%"

echo Datei erfolgreich erstellt: %OUTPUT_FILE%
pause