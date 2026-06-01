#!/bin/bash
# Laura Dean
# 1/6/26

# script to assemble the mitochondrial genome with flye
# using reads that map to the mitogenome of a closely related species
# run on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=100g
#SBATCH --time=48:00:00
#SBATCH --job-name=assemble_mitogenome
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set up env
source $HOME/.bash_profile
conda activate flye
# updated flye to the latest version for this v2.9.6
cd /share/deepseq/org_one/SNT052/mitogenome

# assemble mitogenome with flye
flye \
--threads 8 \
--out-dir flye_mito_asm_2 \
--nano-raw mito_reads_miniprot.fastq.gz \
--genome-size 17k


# deactivate software
conda deactivate
