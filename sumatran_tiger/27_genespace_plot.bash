#!/bin/bash
# Laura Dean
# 14/3/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=genespace
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=1:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# install and load software
source $HOME/.bash_profile
# ok trying a fourth time from scratch
# first ran: conda config --remove channels defaults
# this removed some silly conflict warning. Then ran:
conda create --name genespace4 orthofinder=2.5.5 mcscanx r-base=4.4.1 r-devtools r-BiocManager bioconductor-biostrings -y
conda activate genespace4
R
devtools::install_github("jtlovell/GENESPACE")
BiocManager::install("rtracklayer")
library(GENESPACE)
# install was successful :)



# set variables
wkdir=~/data/OrgOne/sumatran_tiger/genespace_ours



#########################################################################
# to get my files in order:
# make the file structure required by genespace
mkdir $wkdir/bed
mkdir $wkdir/peptide

# copy my bed files to the bed folder, stripping all columns after the 4th column when copying
# This was required for the data to load correctly
cut -f1-4 ~/data/OrgOne/sumatran_tiger/raft_hifiasm_asm9/finalasm.bp.p_ctg_liftoff_genes.bed > $wkdir/bed/RaftHifiasmAsm9.bed
cut -f1-4 ~/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb_liftoff_genes.bed > $wkdir/bed/hifiasm10.bed

# copy my protein fasta files
# currently erroring because there are . characters in the fasta sequence and these aren't allowed by diamond
cp ~/data/OrgOne/sumatran_tiger/raft_hifiasm_asm9/finalasm.bp.p_ctg_proteins.fasta $wkdir/peptide/RaftHifiasmAsm9.fa
cp ~/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb_proteins.fasta $wkdir/peptide/hifiasm10.fa


# To actually use it
conda activate genespace4
R
library(GENESPACE)





