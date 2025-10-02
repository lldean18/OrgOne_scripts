#!/bin/bash
# Laura Dean
# 1/10/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=ID_genes_in_inversions
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=5g
#SBATCH --time=1:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/inversions
annotation=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/ragtag.scaffolds_only_liftoff.gff

# setup environment
source $HOME/.bash_profile
conda activate bedtools
cd $wkdir





## find the inversion regions then manually enter the ones you're interested
## in into a bed file called inversion_coords.bed
#awk -F'\t' '$11=="INV"' $wkdir/Ref_Asm_syri.out > $wkdir/Ref_Asm_syri_INV.out

# find the genes in those inversion regions
#bedtools intersect -a $annotation -b inversion_coords.bed -wa > inversion_genes.gff

conda deactivate


# select just the genes from the output
awk -F'\t' '$3=="gene"' inversion_genes.gff > inversion_genes_only.gff



