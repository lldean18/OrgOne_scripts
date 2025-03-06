#!/bin/bash
# Laura Dean
# 23/4/24
# for running on Ada

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=168:00:00
#SBATCH --job-name=tig_flye3
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

# set variables
species=sumatran_tiger # set the species
wkdir=/gpfs01/home/mbzlld/data/OrgOne/${species} # set the working directory
try=3

# prepare the input file variables
# note that some of the files are just .fastq rather than .fastq.gz now because they had to be decompressed for shasta input
duplex=$(find $wkdir/basecalls -type f -name '*all_duplex.fastq.gz') # set the list of duplex input files
simplex=$(find $wkdir/basecalls/sumatran_tiger_P1 $wkdir/basecalls/sumatran_tiger_P2 $wkdir/basecalls/sumatran_tiger_P3 $wkdir/basecalls/sumatran_tiger_P4 -type f -name '*calls.fastq*') # set the list of simplex input files (only the simplex that didn't come from duplex)

## create a conda environment and install the software you want
#conda create --name flye -c conda-forge -c bioconda flye

# activate the conda environment
conda activate flye

# assemble your genome from fastq files (using all pass and fail reads)
flye \
--threads 96 \
--iterations 5 \
-o $wkdir/${species}_flye_asm${try} \
--nano-corr $simplex $duplex

# deactivate the conda environment
conda deactivate

