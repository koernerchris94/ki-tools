#!/bin/bash

# Verzeichnis, in dem das Skript liegt
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔍 Scanning directory: $SCRIPT_DIR"

# Alle Dateien rekursiv finden, Dateiendungen extrahieren, sortieren und Duplikate entfernen
find "$SCRIPT_DIR" -type f | sed -n 's/.*\.\([a-zA-Z0-9]*\)$/\1/p' | sort -u
