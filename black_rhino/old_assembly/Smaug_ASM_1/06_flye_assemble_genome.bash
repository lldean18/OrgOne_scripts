#!/bin/bash
# Laura Dean
# 1/12/23

#SBATCH --partition=LocalQ
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --tasks-per-node=24
#SBATCH --mem=30g
#SBATCH --time=168:00:00
#SBATCH --job-name=flye
#SBATCH --output=/home/mbzlld/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

# set variables
spp_dir=/data/test_data/org_one/black_rhino # data directory for your species

## create a conda environment and install the software you want
#conda create --name assembly_tools -c conda-forge -c bioconda -c anaconda bam2fastx hifiasm purge_dups ragtag flye

# activate the conda environment
conda activate assembly_tools

## install blobtools2 since only the old version seemed to be available on Conda
#pip install blobtoolkit

# # assemble your genome from fastq files (using all pass and fail reads)
# flye \
# --threads 24 \
# -o $spp_dir/black_rhino_asm_002 \
# --nano-hq $spp_dir/fastq_files/Rhino.pass.fastq.gz $spp_dir/fastq_files/Rhino.fail.fastq.gz


# assemble your genome from fastq files (using only pass reads)
flye \
--threads 24 \
-o $spp_dir/Rhino_asm_PASSonly \
--nano-hq $spp_dir/fastq_files/Rhino.pass.fastq.gz


# deactivate the conda environment
conda deactivate

