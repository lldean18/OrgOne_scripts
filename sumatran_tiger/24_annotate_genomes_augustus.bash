#!/bin/bash
# Laura Dean
# 10/3/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=augustus_annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=30g
#SBATCH --time=6:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
assembly=



# load software
source $HOME/.bash_profile
#conda create --name augustus -c bioconda augustus=3.2.3
conda activate augustus


augustus [parameters] --species=SPECIES queryfilename






conda deactivate

