#!/bin/bash
# Laura Dean
# 19/3/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=361g
#SBATCH --time=168:00:00
#SBATCH --job-name=black_lemur_flye
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

# set variables
species=black_and_white_ruffed_lemur # set the species
wkdir=/share/StickleAss/OrgOne/${species} # set the working directory

# # generate the list of fastq files and paste them after the --nano-hq flag below
# find $wkdir/basecalls -type f -name '*.fastq.gz' # set the full fastq file name and further path

## create a conda environment and install the software you want
#conda create --name flye -c conda-forge -c bioconda flye

# activate the conda environment
conda activate flye

# assemble your genome from fastq files (using all pass and fail reads)
flye \
--threads 96 \
--iterations 5 \
-o $wkdir/${species}_asm \
--nano-hq /share/StickleAss/OrgOne/black_and_white_ruffed_lemur/basecalls/Black_and_whilte_ruffed_lemur_P1/20230207_1523_2D_PAG66041_46ee3ae4/pod5_fail/SUPlatest_calls.fastq.gz /share/StickleAss/OrgOne/black_and_white_ruffed_lemur/basecalls/Black_and_whilte_ruffed_lemur_P1/20230207_1523_2D_PAG66041_46ee3ae4/pod5_pass/SUPlatest_calls.fastq.gz


# deactivate the conda environment
conda deactivate

