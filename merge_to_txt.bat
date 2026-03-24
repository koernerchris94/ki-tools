@echo off
:: UTF-8 Codepage setzen, damit Umlaute und Sonderzeichen korrekt verarbeitet werden
chcp 65001 >nul

set "SCRIPT_DIR=%~dp0"
:: Backslash am Ende entfernen, um saubere relative Pfade zu berechnen
if "%SCRIPT_DIR:~-1%"=="\" set "SCRIPT_DIR=%SCRIPT_DIR:~0,-1%"

set "OUTPUT_FILE=%SCRIPT_DIR%\alles.txt"
:: Ausgabedatei leeren/anlegen
type nul > "%OUTPUT_FILE%"

set "TMP_FILE=%TEMP%\filelist_%RANDOM%.txt"
type nul > "%TMP_FILE%"

:: 1. Dateien rekursiv finden, bestimmte Ordner und Ausgabedatei direkt ausschließen
for /f "delims=" %%F in ('dir /s /b /a-d "%SCRIPT_DIR%" ^| findstr /v /i /c:"\node_modules\\" /c:"\.git\\" /c:"\dist\\" /c:"\build\\" /c:"\alles.txt"') do (
    call :CheckFile "%%F"
)

goto :ProcessFiles

:CheckFile
set "FULL_PATH=%~1"
set "EXT=%~x1"
set "NAME=%~nx1"
set "MATCH=0"

:: Überprüfung auf erlaubte Dateiendungen (.gitignore und .dockerignore werden in Batch als Endungen erkannt)
for %%A in (.tex .cls .conf .css .dockerignore .gitignore .html .ini .js .json .jsx .md .py .ts .tsx .txt .vb .vbproj .xml .yml .prisma .lock .yaml .mjs .cjs) do (
    if /I "%EXT%"=="%%A" set "MATCH=1"
)
:: Überprüfung auf exakte Dateinamen ohne Endung
if /I "%NAME%"=="LICENSE" set "MATCH=1"
if /I "%NAME%"=="Dockerfile" set "MATCH=1"

if "%MATCH%"=="1" (
    :: Delayed Expansion kurz aktivieren, um Sonderzeichen in Pfaden abzusichern
    setlocal enabledelayedexpansion
    echo !FULL_PATH!>> "%TMP_FILE%"
    endlocal
)
exit /b

:ProcessFiles
:: Gefundene Dateien alphabetisch sortieren
set "SORTED_TMP=%TEMP%\filelist_sorted_%RANDOM%.txt"
sort "%TMP_FILE%" /o "%SORTED_TMP%"

:: 2. Strukturverzeichnis erstellen
echo ^<directory_structure^>>> "%OUTPUT_FILE%"
for /f "usebackq delims=" %%F in ("%SORTED_TMP%") do (
    set "FULL_PATH=%%F"
    setlocal enabledelayedexpansion
    :: Relativen Pfad berechnen
    set "REL_PATH=!FULL_PATH:%SCRIPT_DIR%\=!"
    :: Backslashes in Slashes umwandeln (entspricht dem Linux/Bash-Verhalten)
    set "REL_PATH=!REL_PATH:\=/!"
    echo - !REL_PATH!>> "%OUTPUT_FILE%"
    endlocal
)
echo ^</directory_structure^>>> "%OUTPUT_FILE%"
echo.>> "%OUTPUT_FILE%"
echo.>> "%OUTPUT_FILE%"

:: 3. Datei-Inhalte anhängen
echo ^<file_contents^>>> "%OUTPUT_FILE%"
for /f "usebackq delims=" %%F in ("%SORTED_TMP%") do (
    set "FULL_PATH=%%F"
    setlocal enabledelayedexpansion
    set "REL_PATH=!FULL_PATH:%SCRIPT_DIR%\=!"
    set "REL_PATH=!REL_PATH:\=/!"
    echo === !REL_PATH! ===>> "%OUTPUT_FILE%"
    endlocal
    
    :: Dateiinhalt anfügen
    type "%%F" >> "%OUTPUT_FILE%"
    
    :: Zeilenumbrüche zur Trennung
    echo.>> "%OUTPUT_FILE%"
    echo.>> "%OUTPUT_FILE%"
)
echo ^</file_contents^>>> "%OUTPUT_FILE%"

:: Temporäre Dateien aufräumen
del "%TMP_FILE%"
del "%SORTED_TMP%"

echo Datei erfolgreich erstellt: %OUTPUT_FILE%
pause