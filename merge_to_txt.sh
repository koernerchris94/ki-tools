#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/alles.txt"
> "$OUTPUT_FILE"

find "$SCRIPT_DIR" -type f \
  -not -path '*/node_modules/*' \
  -not -path '*/.git/*' \
  -not -path '*/dist/*' \
  -not -path '*/build/*' \
  \( \
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
  -name "*.yml" \
  -name "*.prisma" -o \
  -name "*.lock" -o \
  -name "*.yaml" -o \
  -name "LICENSE" -o \
  -name "Dockerfile" -o \
  -name "*.mjs" -o \
  -name "*.cjs" \
\) ! -name "alles.txt" -print0 | while IFS= read -r -d '' file; do
  echo "=== $file ===" >> "$OUTPUT_FILE"
  cat "$file" >> "$OUTPUT_FILE"
  echo -e "\n" >> "$OUTPUT_FILE"
done
