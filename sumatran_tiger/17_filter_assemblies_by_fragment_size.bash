#!/bin/bash
# Laura Dean
# 3/1/25
# For running on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH --job-name=tig_assem_size_filt
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# load software
source $HOME/.bash_profile
conda activate seqtk


# set variables
fasta=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg.fasta


# remove sequences shorter than 100kb
seqtk seq -L 100000 $fasta > ${fasta%.*}_100kb.fasta


# unload software
conda deactivate

