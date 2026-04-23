# 2>nul & @goto :windows_part

# ==========================================
# BASH-SEKTION (Für Linux / macOS)
# ==========================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/alles.txt"
> "$OUTPUT_FILE"

# Temporäre Datei anlegen, um die Dateiliste sicher zwischenzuspeichern
TMP_FILE=$(mktemp)

echo "Lese Dateien und Ordner aus (Linux/macOS)..."

# 1. Dateien finden (PFEILSCHNELL dank -prune) und in temporäre Datei schreiben
find "$SCRIPT_DIR" \
  \( \
     -name "node_modules" -o \
     -name ".git" -o \
     -name ".idea" -o \
     -name ".vscode" -o \
     -name ".next" -o \
     -name "dist" -o \
     -name "build" -o \
     -name "venv" -o \
     -name "coverage" \
  \) -prune \
  -o -type f \( \
    -name "*.json" -o -name "*.xml" -o -name "*.yaml" -o -name "*.yml" -o \
    -name "*.toml" -o -name "*.ini" -o -name "*.conf" -o -name "*.dockerignore" -o \
    -name "*.gitignore" -o -name "Dockerfile" -o -name "LICENSE" -o \
    -name "README.md" -o -name "CHANGELOG.md" -o -name "*.html" -o \
    -name "*.css" -o -name "*.scss" -o -name "*.sass" -o -name "*.less" -o \
    -name "*.svg" -o -name "*.js" -o -name "*.jsx" -o -name "*.mjs" -o \
    -name "*.cjs" -o -name "*.ts" -o -name "*.tsx" -o -name "*.mts" -o \
    -name "*.cts" -o -name "*.vue" -o -name "*.svelte" -o -name "*.py" -o \
    -name "*.php" -o -name "*.go" -o -name "*.java" -o -name "*.cs" -o \
    -name "*.sh" -o -name "*.sql" -o -name "*.prisma" -o -name "*.graphql" -o \
    -name "*.vb" -o -name "*.vbproj" -o -name "*.txt" -o -name "*.lock" -o \
    -name "*.tex" -o -name "*.cls" -o -name "*.bib" -o -name "*.csv" -o \
    -name "*.wsdl" -o -name "*.xsd" -o -name "*.ps1" \
  \) ! -name "alles.txt" -print0 > "$TMP_FILE"

# Gefundene Dateien alphabetisch sortieren (sichert Konsistenz zwischen Struktur und Inhalt)
sort -z -o "$TMP_FILE" "$TMP_FILE"

# 2. Strukturverzeichnis erstellen (KI-optimiert)
echo "<directory_structure>" >> "$OUTPUT_FILE"
while IFS= read -r -d '' file; do
  # Relativen Pfad berechnen
  rel_path="${file#$SCRIPT_DIR/}"
  echo "- $rel_path" >> "$OUTPUT_FILE"
done < "$TMP_FILE"
echo -e "</directory_structure>\n\n" >> "$OUTPUT_FILE"

# 3. Datei-Inhalte anhängen
echo "<file_contents>" >> "$OUTPUT_FILE"
while IFS= read -r -d '' file; do
  rel_path="${file#$SCRIPT_DIR/}"
  echo "=== $rel_path ===" >> "$OUTPUT_FILE"
  cat "$file" >> "$OUTPUT_FILE"
  echo -e "\n" >> "$OUTPUT_FILE"
done < "$TMP_FILE"
echo "</file_contents>" >> "$OUTPUT_FILE"

# Temporäre Datei aufräumen
rm "$TMP_FILE"

echo "Fertig! (Gespeichert in $OUTPUT_FILE)"
exit 0


# ==========================================
# BATCH-SEKTION (Für Windows)
# ==========================================
:windows_part
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

echo Lese Dateien und Ordner aus (Windows)...

REM 1. Dateien finden (Ordner-Ausschlüsse aktualisiert für Performance)
for /f "delims=" %%F in ('dir /s /b /a-d "%SCRIPT_DIR%" ^| findstr /v /i /c:"\node_modules\\" /c:"\.git\\" /c:"\.idea\\" /c:"\.vscode\\" /c:"\.next\\" /c:"\dist\\" /c:"\build\\" /c:"\venv\\" /c:"\coverage\\" /c:"\alles.txt"') do (
    call :CheckFile "%%F"
)

goto :ProcessFiles

:CheckFile
set "FULL_PATH=%~1"
set "EXT=%~x1"
set "NAME=%~nx1"
set "MATCH=0"

REM Überprüfung Dateiendungen (Erweiterte Liste, synchronisiert mit Bash)
for %%A in (.json .xml .yaml .yml .toml .ini .conf .dockerignore .gitignore .html .css .scss .sass .less .svg .js .jsx .mjs .cjs .ts .tsx .mts .cts .vue .svelte .py .php .go .java .cs .sh .sql .prisma .graphql .vb .vbproj .txt .lock .tex .cls .bib .csv .wsdl .xsd .ps1) do (
    if /I "%EXT%"=="%%A" set "MATCH=1"
)

REM Überprüfung Dateinamen (Exakte Treffer ohne Endung oder spezielle Dateien)
if /I "%NAME%"=="Dockerfile" set "MATCH=1"
if /I "%NAME%"=="LICENSE" set "MATCH=1"
if /I "%NAME%"=="README.md" set "MATCH=1"
if /I "%NAME%"=="CHANGELOG.md" set "MATCH=1"

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

echo Fertig! (Gespeichert in %OUTPUT_FILE%)
pause
exit /b
