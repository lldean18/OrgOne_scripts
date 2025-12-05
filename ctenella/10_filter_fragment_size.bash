#!/bin/bash
# Laura Dean
# 9/1/25
# For running on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=2:00:00
#SBATCH --job-name=assem_size_filt
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# load conda & seqtk
source $HOME/.bash_profile
conda activate seqtk


# set variables
assembly=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm1/ONTasm.bp.p_ctg.fasta

# remove sequences shorter than 100kb
seqtk seq -L 100000 $assembly > ${assembly%.*}_100kb.fasta
#seqtk seq -L 100000 $assembly > ${assembly%.*}_100kb.fasta


# unload software
conda deactivate


