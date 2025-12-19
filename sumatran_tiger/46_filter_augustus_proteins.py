#!/usr/bin/env python3
from collections import defaultdict
from Bio import SeqIO

# -------------------------
# Input files
# -------------------------
GFF_FILE = "ONTasm.bp.p_ctg_100kb_3.gff"
PROTEIN_FASTA = "ONTasm.bp.p_ctg_100kb_3.faa"
OUTPUT_FASTA = "ONTasm.bp.p_ctg_100kb_3_filtered.faa"

# -------------------------
# Step 1: count exons per gene from GFF
# -------------------------
exon_counts = defaultdict(int)

with open(GFF_FILE, 'r') as gff:
    for line in gff:
        if line.startswith("#"):
            continue
        parts = line.strip().split('\t')
        if len(parts) < 9:
            continue
        feature_type = parts[2]
        if feature_type.lower() == "exon":
            # extract gene ID from attributes (adjust if your ID tag is different)
            attrs = parts[8].split(';')
            gene_id = None
            for attr in attrs:
                if attr.startswith("ID="):
                    gene_id = attr.replace("ID=","")
                    break
                elif attr.startswith("Parent="):
                    gene_id = attr.replace("Parent=","")
            if gene_id:
                exon_counts[gene_id] += 1

# -------------------------
# Step 2: filter protein sequences
# -------------------------
with open(OUTPUT_FASTA, 'w') as out_fh:
    for record in SeqIO.parse(PROTEIN_FASTA, "fasta"):
        prot_id = record.id.split()[0]  # remove description after space
        cds_len = len(record.seq)
        n_exons = exon_counts.get(prot_id, 1)  # default to 1 if missing

        # KEEP if >=2 exons OR CDS >= 300 aa
        if n_exons >= 2 or cds_len >= 300:
            SeqIO.write(record, out_fh, "fasta")

print("Filtered proteins written to:", OUTPUT_FASTA)
