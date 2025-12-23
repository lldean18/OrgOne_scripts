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
    "Description": set(),
    "InterPro": set(),
    "Pfam": set(),
    "GO": set(),
    "Pathway": set()   # kept for compatibility (unused)
})

with open(INTERPRO_TSV) as fh:
    for line in fh:
        cols = line.rstrip().split("\t")
        if len(cols) < 6:
            continue

        protein_id, analysis, sig, ipr_id, desc, go = cols

        if desc and desc != "-":
            ipr[protein_id]["Description"].add(desc)

        if ipr_id.startswith("IPR"):
            ipr[protein_id]["InterPro"].add(ipr_id)

        if analysis == "Pfam" or sig.startswith("PF"):
            ipr[protein_id]["Pfam"].add(sig)

        if go and go != "-":
            for term in go.split(","):
                if term.startswith("GO:"):
                    ipr[protein_id]["GO"].add(term)

# -------------------------
# Parse KofamScan TSV
# -------------------------
# Expected columns:
# 1 ProteinID
# 2 KO
# 3 KO_function

kegg = {}

with open(KEGG_TSV) as fh:
    next(fh)  # skip header
    for line in fh:
        cols = line.rstrip().split("\t")
        if len(cols) < 3:
            continue

        protein_id, ko_id, ko_func = cols[0], cols[1], cols[2]

        if ko_id != "NA":
            kegg[protein_id] = (ko_id, ko_func)
        else:
            kegg[protein_id] = ("-", "-")

# -------------------------
# Parse BLAST (best hit only)
# -------------------------
blast = {}

with open(BLAST_TSV) as fh:
    for line in fh:
        cols = line.rstrip().split("\t")
        if len(cols) < 2:
            continue
        query, subject = cols[0], cols[1]
        if query not in blast:
            blast[query] = subject

# -------------------------
# Process Augustus GFF
# -------------------------
summary_rows = []
seen_proteins = set()

out_gff = open("annotated.gff3", "w")

with open(AUGUSTUS_GFF) as fh:
    for line in fh:
        if line.startswith("#"):
            out_gff.write(line)
            continue

        cols = line.rstrip().split("\t")
        if len(cols) < 9:
            out_gff.write(line)
            continue

        attr = cols[8]

        gene_id = None
        protein_id = None

        m_gene = re.search(r'gene_id "([^"]+)"', attr)
        m_tx = re.search(r'transcript_id "([^"]+)"', attr)

        if m_gene:
            gene_id = m_gene.group(1)
        if m_tx:
            protein_id = m_tx.group(1)

        if protein_id:
            ip = ipr.get(protein_id, {})
            ko_id, ko_func = kegg.get(protein_id, ("-", "-"))
            blast_hit = blast.get(protein_id, "-")

            extra = []

            if ip.get("InterPro"):
                extra.append("InterPro=" + ",".join(sorted(ip["InterPro"])))
            if ip.get("Pfam"):
                extra.append("Pfam=" + ",".join(sorted(ip["Pfam"])))
            if ip.get("GO"):
                extra.append("GO=" + ",".join(sorted(ip["GO"])))
            if ko_id != "-":
                extra.append(f"KO={ko_id}")
            if blast_hit != "-":
                extra.append(f"BLAST_hit={blast_hit}")

            if extra:
                cols[8] += ";" + ";".join(extra)

            if protein_id not in seen_proteins:
                summary_rows.append([
                    gene_id or "-",
                    protein_id,
                    ",".join(sorted(ip.get("Description", []))) or "-",
                    ",".join(sorted(ip.get("InterPro", []))) or "-",
                    ",".join(sorted(ip.get("Pfam", []))) or "-",
                    ",".join(sorted(ip.get("GO", []))) or "-",
                    ko_id or "-",
                    ko_func or "-",
                    blast_hit or "-"
                ])
                seen_proteins.add(protein_id)

        out_gff.write("\t".join(cols) + "\n")

out_gff.close()

# -------------------------
# Write summary table
# -------------------------
with open("annotation_summary.tsv", "w") as out:
    out.write(
        "GeneID\tProteinID\tDescription\tInterPro\tPfam\tGO\tKO\tKO_function\tBLAST_hit\n"
    )
    for row in summary_rows:
        out.write("\t".join(row) + "\n")

print("Annotation successfully merged")
