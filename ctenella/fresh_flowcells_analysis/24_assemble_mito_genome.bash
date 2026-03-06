#!/bin/bash
# Laura Dean
# 6/3/26

# script to assemble the ctenella mitochondrial genome with flye
# using reads that map to the mitogenome of a closely related species
# run on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=361g
#SBATCH --time=168:00:00
#SBATCH --job-name=assemble_ctenella_mitochondria
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out




# set up env
source $HOME/.bash_profile
conda activate flye
# updated flye to the latest version for this v2.9.6
cd /gpfs01/home/mbzlld/data/ctenella/mitogenome


flye \
--threads 96 \
--out-dir flye_mito_asm \
--nano-raw mito_reads.fastq.gz \
--genome-size 20k

#--nano-hq


# deactivate software
conda deactivate


