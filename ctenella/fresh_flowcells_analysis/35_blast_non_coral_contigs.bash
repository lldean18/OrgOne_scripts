#!/bin/bash
# 18/6/26

# script to blast the non coral contigs from the ctenella assembly

#SBATCH --job-name=blast_non_coral_contigs
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=40:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
source $HOME/.bash_profile
conda activate blast
cd /gpfs01/home/mbzlld/data/ctenella/metagenome


# blast each contig from the not coral assembly to hopefully ID symbionts
blastn \
  -query ONTasm.bp.p_ctg_NOT_Scleractinia.fasta \
  -db /gpfs01/home/mbzlld/data/databases/nt \
  -max_target_seqs 1 \
  -max_hsps 1 \
  -outfmt "6 qseqid sseqid stitle pident length evalue bitscore" \
  -out top_blast_hits.tsv



conda deactivate





