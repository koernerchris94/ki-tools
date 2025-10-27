import os
from docx2pdf import convert
from PyPDF2 import PdfMerger

# Alle .docx-Dateien im aktuellen Verzeichnis finden
docx_files = [f for f in os.listdir() if f.endswith(".docx")]

# .docx → .pdf konvertieren
for docx in docx_files:
    convert(docx)

# Alle erzeugten PDFs sammeln
pdf_files = [f.replace(".docx", ".pdf") for f in docx_files]

# PDFs zusammenfügen
merger = PdfMerger()
for pdf in pdf_files:
    merger.append(pdf)

# Ergebnis speichern
merger.write("merged_output.pdf")
merger.close()
