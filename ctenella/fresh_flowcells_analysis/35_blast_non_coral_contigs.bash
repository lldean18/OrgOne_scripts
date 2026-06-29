#!/bin/bash
# 18/6/26

# script to blast the non coral contigs from the ctenella assembly

#SBATCH --job-name=blast_non_coral_contigs
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=180g
#SBATCH --time=160:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
source $HOME/.bash_profile
conda activate blast
cd /gpfs01/home/mbzlld/data/ctenella/metagenome


# blast each contig from the not coral assembly to hopefully ID symbionts
blastn \
  -num_threads 16 \
  -query ONTasm.bp.p_ctg_NOT_Scleractinia.fasta \
  -db /gpfs01/home/mbzlld/data/databases/nt \
  -max_target_seqs 1 \
  -max_hsps 1 \
  -outfmt "6 qseqid sseqid stitle pident length evalue bitscore" \
  -out top_blast_hits.tsv

conda deactivate

echo "blastn finished"

# summarise the number of contigs for each different species
awk -F'\t' '
{ key = $2 "\t" $3
    count[key]++
    if (contigs[key] == "")
        contigs[key] = $1
    else
        contigs[key] = contigs[key] "," $1}
END { print "stitle\tsseqid\tcounts\tcontigs"
    for (k in count) {
        split(k, a, "\t")
        sseqid = a[1]
        stitle = a[2]
        print stitle "\t" sseqid "\t" count[k] "\t" contigs[k]
}}' top_blast_hits.tsv > blast_summary.tsv

echo "script has run to completion"


