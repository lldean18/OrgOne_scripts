#!/bin/bash
# Laura Dean
# 24/2/26

# Script to calculate GC content of assembly contigs

#SBATCH --job-name=calculate_GC
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=10g
#SBATCH --time=4:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# setup env
assembly=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_Scleractinia.fasta

source $HOME/.bash_profile
conda activate seqkit


# calculate GC content of reads
seqkit fx2tab --threads 16 --gc --name $assembly > ${assembly}_GC.tsv


conda deactivate





