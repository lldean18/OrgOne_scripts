from Bio import SeqIO

# Replace 'your_file.fasta' with your actual FASTA filename
fasta_file = "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/ragtag.scaffolds_only.fasta"

# Read and sort the records by sequence length (descending)
sorted_records = sorted(SeqIO.parse(fasta_file, "fasta"), key=lambda r: len(r.seq), reverse=True)

# Print only the headers (record IDs) in order
for record in sorted_records:
    print(record.id)
