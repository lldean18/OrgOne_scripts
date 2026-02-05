#!/bin/bash
# Laura Dean
# 4/2/26

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=00:30:00
#SBATCH --job-name=assem_size_filt
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# script to filter the raw ctenella reads to try an assembly with only the larger fragments

# setup env
source $HOME/.bash_profile
conda activate seqtk
asm=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg.fasta

# remove sequences shorter than 100kb
seqtk seq -L 100000 $asm > ${asm%.*}_100kb.fasta


# unload the software
conda deactivate


