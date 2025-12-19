#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/alles.txt"
> "$OUTPUT_FILE"

find "$SCRIPT_DIR" -type f \( \
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
  -name "*.yml" \
\) ! -name "alles.txt" -print0 | while IFS= read -r -d '' file; do
  echo "=== $file ===" >> "$OUTPUT_FILE"
  cat "$file" >> "$OUTPUT_FILE"
  echo -e "\n" >> "$OUTPUT_FILE"
done
