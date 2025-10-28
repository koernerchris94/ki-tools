import os
import subprocess
import tempfile
import shutil
from PyPDF2 import PdfMerger

# Temporären Ordner für PDFs erstellen
pdf_dir = tempfile.mkdtemp(prefix="pdf_merge_")
print(f"📁 Temporärer Ordner: {pdf_dir}")

# Alle .docx-Dateien im aktuellen Verzeichnis finden
docx_files = [f for f in os.listdir() if f.endswith(".docx")]

# Schritt 1: .docx → .pdf mit LibreOffice
for docx in docx_files:
    print(f"📄 Konvertiere: {docx}")
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
    print(f"➕ Füge hinzu: {pdf}")
    merger.append(pdf_path)

output_path = os.path.join(os.getcwd(), "merged_output.pdf")
merger.write(output_path)
merger.close()

# Schritt 3: Temporären Ordner löschen
shutil.rmtree(pdf_dir)
print(f"\n✅ Fertig! Zusammengeführte PDF: {output_path}")
print(f"🧹 Temporärer Ordner gelöscht.")
