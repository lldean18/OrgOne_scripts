#!/usr/bin/env python3

from collections import defaultdict
import re

# -------------------------
# Input files
# -------------------------

## # FOR THE RUN WITH ALL PREDICTED PROTEINS
## AUGUSTUS_GFF = "ONTasm.bp.p_ctg_100kb_3.gff"
## INTERPRO_TSV = "ONTasm.bp.p_ctg_100kb_3_filtered.faa_clean.tsv"
## KEGG_TSV = "ONTasm.bp.p_ctg_100kb_3-ko-annotations-filtered-sighits.tsv"
## BLAST_TSV = "ONTasm.bp.p_ctg_100kb_3-blast-swissprot-tophits.tsv"

## # FOR THE RUN WITH PREDICTED PROTEINS FILTERED SENSIBLY
## AUGUSTUS_GFF = "ONTasm.bp.p_ctg_100kb_3_badrm.gff"
## INTERPRO_TSV = "ONTasm.bp.p_ctg_100kb_3_filtered.faa_clean_badrm.tsv"
## KEGG_TSV = "ONTasm.bp.p_ctg_100kb_3-ko-annotations-filtered-sighits_badrm.tsv"
## BLAST_TSV = "ONTasm.bp.p_ctg_100kb_3-blast-swissprot-tophits-signif_badrm.tsv"

# FOR THE RUN WITH THE SCAFFOLDED ASSEMBLY
AUGUSTUS_GFF = "ragtag.scaffolds_only_augustus_badrm.gff"
INTERPRO_TSV = "ragtag.scaffolds_only_augustus_filtered.faa_clean_badrm.tsv"
KEGG_TSV = "ragtag.scaffolds_only_augustus-ko-annotations-filtered-sighits_badrm.tsv"
BLAST_TSV = "ragtag.scaffolds_only_augustus-blast-swissprot-tophits-signif_badrm.tsv"


# -------------------------
# Parse InterProScan FILTERED TSV
# -------------------------
# Expected columns:
# 1 ProteinID
# 2 Analysis
# 3 Signature
# 4 InterPro
# 5 Description
# 6 GO

ipr = defaultdict(lambda: {
    "InterPro": set(),
    "Pfam": set(),
    "GO": set(),
    "KO_function": set()
})

with open(INTERPRO_TSV) as fh:
    for line in fh:
        cols = line.rstrip().split("\t")
        if len(cols) < 6:
            continue

        protein_id, analysis, sig, ipr_id, desc, go = cols

        if ipr_id.startswith("IPR"):
            ipr[protein_id]["InterPro"].add(ipr_id)

        if analysis == "Pfam" or sig.startswith("PF"):
            ipr[protein_id]["Pfam"].add(sig)

        if go != "-" and go != "":
            for term in go.split(","):
                ipr[protein_id]["GO"].add(term)

# -------------------------
# Parse KEGG TSV
# -------------------------
# Expected columns:
# 1 ProteinID
# 2 KO
# 3 KO_function

with open(KEGG_TSV) as fh:
    next(fh)  # skip header
    for line in fh:
        cols = line.rstrip().split("\t")
        if len(cols) < 3:
            continue

        protein_id = cols[0]
        ko_func = cols[2]

        if ko_func:
            ipr[protein_id]["KO_function"].add(ko_func)

# -------------------------
# Parse BLAST TSV
# -------------------------
blast_hits = {}

with open(BLAST_TSV) as fh:
    for line in fh:
        cols = line.rstrip().split("\t")
        if len(cols) < 2:
            continue
        blast_hits[cols[0]] = cols[1]

# -------------------------
# Parse AUGUSTUS GFF
# -------------------------
genes = {}
gff_lines = []

with open(AUGUSTUS_GFF) as fh:
    for line in fh:
        if line.startswith("#"):
            gff_lines.append(line)
            continue

        parts = line.rstrip().split("\t")
        if len(parts) < 9:
            gff_lines.append(line)
            continue

        attrs = parts[8]
        m = re.search(r'ID=([^;]+)', attrs)
        if m:
            gene_id = m.group(1)
            genes[gene_id] = parts

        gff_lines.append(line)

# -------------------------
# Write merged TSV
# -------------------------
def fmt(values):
    return ",".join(sorted(values)) if values else "-"

with open("merged_annotations.tsv", "w") as out_tsv:
    out_tsv.write(
        "GeneID\tInterPro\tPfam\tGO\tKO_function\tBLAST_hit\n"
    )

    for gene_id in sorted(genes):
        out_tsv.write(
            "\t".join([
                gene_id,
                fmt(ipr[gene_id]["InterPro"]),
                fmt(ipr[gene_id]["Pfam"]),
                fmt(ipr[gene_id]["GO"]),
                fmt(ipr[gene_id]["KO_function"]),
                blast_hits.get(gene_id, "-")
            ]) + "\n"
        )

# -------------------------
# Write merged GFF (UNCHANGED)
# -------------------------
with open("merged_annotations.gff", "w") as out_gff:
    for line in gff_lines:
        out_gff.write(line)

print("Annotation successfully merged")
