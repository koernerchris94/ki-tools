import os
import subprocess
from PyPDF2 import PdfMerger

# Ordnerpfade
current_dir = os.getcwd()
pdf_dir = os.path.join(current_dir, "pdfs")

# PDF-Zielordner erstellen
os.makedirs(pdf_dir, exist_ok=True)

# Alle .docx-Dateien im aktuellen Verzeichnis finden
docx_files = [f for f in os.listdir(current_dir) if f.endswith(".docx")]

# Schritt 1: .docx → .pdf mit LibreOffice
for docx in docx_files:
    print(f"Konvertiere: {docx}")
    subprocess.run([
        "/Applications/LibreOffice.app/Contents/MacOS/soffice",
        "--headless",
        "--convert-to", "pdf",
        docx,
        "--outdir", pdf_dir
    ])

# Schritt 2: PDFs zusammenfügen
pdf_files = sorted([f for f in os.listdir(pdf_dir) if f.endswith(".pdf")])
merger = PdfMerger()

for pdf in pdf_files:
    pdf_path = os.path.join(pdf_dir, pdf)
    print(f"Füge hinzu: {pdf}")
    merger.append(pdf_path)

output_path = os.path.join(current_dir, "merged_output.pdf")
merger.write(output_path)
merger.close()

print(f"\n✅ Fertig! Zusammengeführte PDF: {output_path}")
