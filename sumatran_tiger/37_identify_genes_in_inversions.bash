#!/bin/bash
# Laura Dean
# 1/10/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=ID_genes_in_inversions
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=30g
#SBATCH --time=5:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/inversions
annotation=


# setup environment
source $HOME/.bash_profile
conda activate bedtools
cd $wkdir

# find the inversion regions
awk -F'\t' '$11=="INV"' $wkdir/Ref_Asm_syri.out > $wkdir/Ref_Asm_syri_INV.out

bedtools intersect -a annotation.gff3 -b regions.bed -wa > region.gff




