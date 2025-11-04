#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OUTPUT_FILE="$SCRIPT_DIR/alles.txt"
> "$OUTPUT_FILE"

find "$SCRIPT_DIR" -type f \( \
  -name "*.md" -o -name "*.py" -o -name "*.txt" -o \
  -name "*.jsx" -o -name "*.css" -o -name "*.js" -o \
  -name "*.ts" -o -name "*.vb" \
\) ! -name "alles.txt" -print0 | while IFS= read -r -d '' file; do
  echo "=== $file ===" >> "$OUTPUT_FILE"
  cat "$file" >> "$OUTPUT_FILE"
  echo -e "\n" >> "$OUTPUT_FILE"
done
