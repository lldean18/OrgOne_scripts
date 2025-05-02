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
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC2/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag/ragtag.scaffold.fasta

# remove sequences shorter than 100kb
seqtk seq -L 1000000 $assembly > ${assembly%.*}_1Mb.fasta


# unload software
conda deactivate


