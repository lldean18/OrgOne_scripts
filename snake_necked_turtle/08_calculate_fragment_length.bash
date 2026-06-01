#!/bin/bash
# Laura Dean
# 14/5/26

# Script to calculate contig length and save it to a file

#SBATCH --job-name=contig_length
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=4:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# setup env
source $HOME/.bash_profile
conda activate seqkit
cd /share/deepseq/org_one/SNT052/assembly_QC
assembly=/share/deepseq/org_one/SNT052/hifiasm/turtle.bp.p_ctg.fasta


# calculate GC content of reads
seqkit fx2tab --threads 16 --name --length $assembly > $(basename ${assembly})_length.tsv


conda deactivate
