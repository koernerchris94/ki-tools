#!/bin/bash

# Verzeichnis, in dem das Skript liegt
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Zielpfad für alles.txt
OUTPUT_FILE="$SCRIPT_DIR/alles.txt"

# Leere oder erstelle alles.txt im Skriptverzeichnis
> "$OUTPUT_FILE"

# Durchsuche backend/ nach passenden Dateien
find "$SCRIPT_DIR/backend" -type f \( -name "*.md" -o -name "*.py" -o -name "*.txt" \) ! -name "alles.txt" | while read -r file; do
  echo "=== $file ===" >> "$OUTPUT_FILE"
  cat "$file" >> "$OUTPUT_FILE"
  echo -e "\n" >> "$OUTPUT_FILE"
done
