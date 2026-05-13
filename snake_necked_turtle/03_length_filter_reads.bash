#!/bin/bash
# 30/3/26

# script to filter raw reads to try an assembly with only the larger fragments

#SBATCH --job-name=length_filter_reads
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=12g
#SBATCH --time=20:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
source $HOME/.bash_profile
conda activate seqtk
cd /share/deepseq/org_one/SNT052/SUP_basecalls


# filter reads to >3.5kb or longer
seqtk seq -L 3500 turtle_SUP.fastq.gz | gzip > turtle_SUP_3.5kb.fastq.gz


# unload the software
conda deactivate

