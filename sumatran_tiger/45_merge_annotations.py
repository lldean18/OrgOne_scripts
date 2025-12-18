#!/usr/bin/env python3

from collections import defaultdict
import re

# -------------------------
# Input files
# -------------------------
AUGUSTUS_GFF = "ONTasm.bp.p_ctg_100kb_3.gff"
INTERPRO_GFF = "ONTasm.bp.p_ctg_100kb_3_filtered.faa_clean.gff3"
KEGG_TSV = "ONTasm.bp.p_ctg_100kb_3-ko-annotations-filtered-sighits.tsv"
BLAST_TSV = "ONTasm.bp.p_ctg_100kb_3-blast-swissprot-tophits.tsv"

# -------------------------
# Parse InterProScan GFF3
# -------------------------
ipr = defaultdict(lambda: {
    "InterPro": set(),
    "Pfam": set(),
    "GO": set(),
    "Pathway": set()
})

with open(INTERPRO_GFF) as fh:
    for line in fh:
        if line.startswith("#"):
            continue

        cols = line.rstrip().split("\t")
        if len(cols) < 9:
            continue

        protein_id = cols[0]
        attr = cols[8]

        # InterPro IDs
        for ipr_id in re.findall(r"InterPro:(IPR\d+)", attr):
            ipr[protein_id]["InterPro"].add(ipr_id)

        # Pfam (Name=PFxxxxx)
        pfam = re.search(r"Name=(PF\d+)", attr)
        if pfam:
            ipr[protein_id]["Pfam"].add(pfam.group(1))

        # GO terms
        for go in re.findall(r"GO:(\d+)", attr):
            ipr[protein_id]["GO"].add(f"GO:{go}")

        # Reactome pathways
        for path in re.findall(r"Reactome:([^\",]+)", attr):
            ipr[protein_id]["Pathway"].add(path)

# -------------------------
# Parse KofamScan TSV
# -------------------------
kegg = {}

with open(KEGG_TSV) as fh:
    header = next(fh)
    for line in fh:
        gene_id, ko_id, ko_func = line.rstrip().split("\t")
        if ko_id != "NA":
            kegg[gene_id] = ko_id

# -------------------------
# Parse BLAST (best hit only)
# -------------------------
blast = {}

with open(BLAST_TSV) as fh:
    for line in fh:
        cols = line.rstrip().split("\t")
        query = cols[0]
        subject = cols[1]
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

        # Extract gene_id and transcript_id
        m_gene = re.search(r'gene_id "([^"]+)"', attr)
        m_tx = re.search(r'transcript_id "([^"]+)"', attr)

        if m_gene:
            gene_id = m_gene.group(1)
        if m_tx:
            protein_id = m_tx.group(1)

        if protein_id:
            ip = ipr.get(protein_id, {})
            ko = kegg.get(protein_id, "-")
            blast_hit = blast.get(protein_id, "-")

            extra = []

            if ip.get("InterPro"):
                extra.append("InterPro=" + ",".join(sorted(ip["InterPro"])))
            if ip.get("Pfam"):
                extra.append("Pfam=" + ",".join(sorted(ip["Pfam"])))
            if ip.get("GO"):
                extra.append("GO=" + ",".join(sorted(ip["GO"])))
            if ko != "-":
                extra.append(f"KO={ko}")
            if ip.get("Pathway"):
                extra.append("Pathway=" + ",".join(sorted(ip["Pathway"])))
            if blast_hit != "-":
                extra.append(f"BLAST_hit={blast_hit}")

            if extra:
                cols[8] += ";" + ";".join(extra)

            if protein_id not in seen_proteins:
                summary_rows.append([
                    gene_id or "-",
                    protein_id,
                    blast_hit,
                    ",".join(sorted(ip.get("InterPro", []))),
                    ",".join(sorted(ip.get("Pfam", []))),
                    ",".join(sorted(ip.get("GO", []))),
                    ko,
                    ",".join(sorted(ip.get("Pathway", []))),
                    blast_hit
                ])
                seen_proteins.add(protein_id)

        out_gff.write("\t".join(cols) + "\n")

out_gff.close()

# -------------------------
# Write summary table
# -------------------------
with open("annotation_summary.tsv", "w") as out:
    out.write(
        "GeneID\tProteinID\tDescription\tInterPro\tPfam\tGO\tKO\tPathway\tBLAST_hit\n"
    )
    for row in summary_rows:
        out.write("\t".join(row) + "\n")

print("✔ Annotation successfully merged")
