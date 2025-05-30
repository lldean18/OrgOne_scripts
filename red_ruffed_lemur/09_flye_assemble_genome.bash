#!/bin/bash
# Laura Dean
# 16/5/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=361g
#SBATCH --time=168:00:00
#SBATCH --job-name=red_lemur_flye
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

# set variables
species=red_ruffed_lemur # set the species
wkdir=/gpfs01/home/mbzlld/data/OrgOne/${species} # set the working directory

# # generate the list of fastq files and paste them after the --nano-hq flag below
#fastqs=$(find $wkdir/basecalls -type f -name '*.fastq.gz') # set the full fastq file name and further path
fastqs=$wkdir/basecalls/red_ruffed_lemur_simplex.fastq.gz # the merged simplex reads

## create a conda environment and install the software you want
#conda create --name flye -c conda-forge -c bioconda flye

# activate the conda environment
conda activate flye

# assemble your genome from fastq files (using all pass and fail reads)
flye \
--threads 96 \
--iterations 5 \
-o $wkdir/${species}_flye_asm \
--nano-hq $fastqs


# deactivate the conda environment
conda deactivate

