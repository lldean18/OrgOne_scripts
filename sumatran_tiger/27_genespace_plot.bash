#!/bin/bash
# Laura Dean
# 14/3/25
# script written for running on the UoN HPC Ada


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
wkdir=~/data/OrgOne/sumatran_tiger/genespace_ours2
wkdir=~/data/OrgOne/sumatran_tiger/genespace_ours3


#########################################################################
# to get my files in order:
# make the file structure required by genespace
mkdir $wkdir
mkdir $wkdir/bed
mkdir $wkdir/peptide

# copy my bed files to the bed folder, stripping all columns after the 4th column when copying
# This was required for the data to load correctly
cut -f1-4 ~/data/OrgOne/sumatran_tiger/raft_hifiasm_asm9/finalasm.bp.p_ctg_liftoff_genes.bed > $wkdir/bed/RaftHifiasmAsm9.bed
cut -f1-4 ~/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb_liftoff_genes.bed > $wkdir/bed/hifiasm10.bed
cut -f1-4 ~/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces_liftoff_genes.bed > $wkdir/bed/LigerHaplome.bed
cut -f1-4 ~/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome_genes.bed > $wkdir/bed/DomesticCat.bed
cut -f1-4 ~/data/OrgOne/sumatran_tiger/sumatran_tiger_flye_asm4/assembly_liftoff_genes.bed > $wkdir/bed/Flye4.bed

# copy my protein fasta files
# currently erroring because there are . characters in the fasta sequence and these aren't allowed by diamond
cp ~/data/OrgOne/sumatran_tiger/raft_hifiasm_asm9/finalasm.bp.p_ctg_proteins.fasta $wkdir/peptide/RaftHifiasmAsm9.fa
cp ~/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb_proteins.fasta $wkdir/peptide/hifiasm10.fa
cp ~/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces_proteins.fasta $wkdir/peptide/LigerHaplome.fa
cp ~/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome_proteins.fasta $wkdir/peptide/DomesticCat.fa
cp ~/data/OrgOne/sumatran_tiger/sumatran_tiger_flye_asm4/assembly_proteins.fasta $wkdir/peptide/Flye4.fa





#########################################################################
# To actually use it
conda activate genespace4
R
library(GENESPACE)





