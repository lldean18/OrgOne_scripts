#!/bin/bash
# Laura Dean
# 28/2/26

# code to convert fasta format to GFA to view in bandage

source $HOME/.bash_profile
conda create --name gfastats bioconda::gfastats
conda activate gfastats

cd /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4

# convert fasta file to gfa format
gfastats ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb.fasta -o gfa > ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb.gfa

conda deactivate

