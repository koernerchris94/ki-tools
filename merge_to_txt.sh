for file in *; do
  # Überspringe alles.txt und Verzeichnisse
  if [[ "$file" == "alles.txt" || ! -f "$file" ]]; then
    continue
  fi

  echo "=== $file ===" >> alles.txt
  cat "$file" >> alles.txt
  echo -e "\n" >> alles.txt
done
