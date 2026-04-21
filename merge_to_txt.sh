#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/alles.txt"
> "$OUTPUT_FILE"

# Temporäre Datei anlegen, um die Dateiliste sicher zwischenzuspeichern
TMP_FILE=$(mktemp)

# 1. Dateien finden und null-terminiert in temporäre Datei schreiben
find "$SCRIPT_DIR" -type f \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' \
  \( \
  -name "*.tex" -o \
  -name "*.cls" -o \
  -name "*.conf" -o \
  -name "*.css" -o \
  -name "*.dockerignore" -o \
  -name "*.gitignore" -o \
  -name "*.html" -o \
  -name "*.ini" -o \
  -name "*.js" -o \
  -name "*.json" -o \
  -name "*.jsx" -o \
  -name "*.md" -o \
  -name "*.py" -o \
  -name "*.ts" -o \
  -name "*.tsx" -o \
  -name "*.txt" -o \
  -name "*.vb" -o \
  -name "*.vbproj" -o \
  -name "*.xml" -o \
  -name "*.yml" -o \
  -name "*.prisma" -o \
  -name "*.lock" -o \
  -name "*.yaml" -o \
  -name "LICENSE" -o \
  -name "Dockerfile" -o \
  -name "*.mjs" -o \
  -name "*.cjs" \
  -name "*.wsdl" \
  -name "*.xsd" \
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

echo "Datei erfolgreich erstellt: $OUTPUT_FILE"
