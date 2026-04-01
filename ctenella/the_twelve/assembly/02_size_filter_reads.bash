#!/bin/bash
# 30/3/26

# script to filter the raw ctenella reads to try an assembly with only the larger fragments

#SBATCH --job-name=SizeFilterRawReads
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=12g
#SBATCH --time=6:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12


# setup env
source $HOME/.bash_profile
conda activate seqtk
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/fastqs

CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
echo "slurm array = $SLURM_ARRAY_TASK_ID size filtering raw reads for sample $ind"


# filter reads to >3.5kb or longer
seqtk seq -L 3500 barcode${ind}.fastq.gz | gzip > barcode${ind}_3.5kb.fastq.gz


# unload the software
conda deactivate

