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
#SBATCH --job-name=tig_assem_size_filt
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# load conda & seqtk
source $HOME/.bash_profile
conda activate seqtk


# set variables
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm11/ONTasm.bp.p_ctg
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm12/ONTasm.bp.p_ctg
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm10/finalasm.bp.p_ctg
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/sumatran_tiger_flye_asm4/assembly
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome_split_contigs
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_scaff_only_names_split_contigs
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm12/finalasm.bp.p_ctg.fasta
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/flye_asm5/assembly.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm13/ONTasm.bp.p_ctg.fasta

# remove sequences shorter than 100kb
seqtk seq -L 100000 $assembly > ${assembly%.*}_100kb.fasta
#seqtk seq -L 100000 $assembly > ${assembly%.*}_100kb.fasta


# unload software
conda deactivate


# activate gfatools
#conda create --name gfatools -y gfatools
conda activate gfatools


# remove sequences shorter than 100kb from the gfa file
gfatools view -l 100000 -d $assembly.gfa > ${assembly}_100kb.gfa


# unload software
conda deactivate

