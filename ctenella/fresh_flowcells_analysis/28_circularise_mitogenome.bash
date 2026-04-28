#!/bin/bash
# Laura Dean
# 12/3/26

# script to circularise the ctenella mitochondrial genome assembly

#SBATCH --job-name=circlator
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# load software
source $HOME/.bash_profile
#conda create -n circlator bioconda::circlator
conda activate circlator

# move to working dir
cd /gpfs01/home/mbzlld/data/ctenella/mitogenome

# circularise the mitogenome and fix the start position
circlator all \
flye_mito_asm_2/assembly.fasta \
mito_reads_miniprot.fastq.gz \
flye_mito_asm_2/circlator


conda deactivate

