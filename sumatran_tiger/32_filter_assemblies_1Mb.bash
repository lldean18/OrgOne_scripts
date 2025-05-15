#!/bin/bash
# Laura Dean
# 2/5/25
# For running on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=2:00:00
#SBATCH --job-name=assem_1Mb_filt
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# load conda & seqtk
source $HOME/.bash_profile
conda activate seqtk


# set variables
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC2/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag/ragtag.scaffold.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag/ragtag.scaffold.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm12/ONTasm.bp.p_ctg_100kb.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm12/finalasm.bp.p_ctg_100kb.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/flye_asm5/assembly_100kb.fasta

# remove sequences shorter than 100kb
seqtk seq -L 3000000 $assembly > ${assembly%.*}_3Mb.fasta


# unload software
conda deactivate


