#!/bin/bash
# Laura Dean
# file prep for input to genespace to make a nice synteny plot


source $HOME/.bash_profile

# set variables
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome.fa
annotation=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0r1.0.2.gff

# load software
conda activate gffread

# convert the gff file to bed format for input to genespace
# this command seems to retain only the genes anyway so no need for further filtering
gffread \
$annotation \
--bed \
-o ${assembly%.*}_genes.bed


# generate protein fasta file as this is also required as input to genespace
# -S flag uses * instead of . for stop codon translation
gffread \
$annotation \
-S \
-g $assembly \
-y ${assembly%.*}_proteins.fasta

# unload software
conda deactivate

# remove the files it generates that I don't want cluttering up my github repo!
rm -r intermediate_files/
rm unmapped_features.txt


