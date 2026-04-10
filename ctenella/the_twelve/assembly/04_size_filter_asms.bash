#!/bin/bash
# 10/4/26

# script to filter the ctenella twelve assemblies to remove small contigs

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=2:00:00
#SBATCH --job-name=assem_size_filt
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12

# setup config
CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)

# load conda & seqtk
source $HOME/.bash_profile
conda activate seqtk

# set variables
assembly=/gpfs01/home/mbzlld/data/ctenella/the_twelve/assemblies/barcode${ind}/barcode${ind}_ONTasm.bp.p_ctg.fasta

# remove sequences shorter than 100kb
seqtk seq -L 100000 $assembly > ${assembly%.*}_100kb.fasta

# unload software
conda deactivate

