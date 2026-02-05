#!/bin/bash
# Laura Dean
# 4/2/26

# script to install and use kraken2 to remove contaminant / symbiont reads from ctenella reads
# or to classify assembly contigs

#SBATCH --job-name=kraken2
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



#conda create --name kraken2 bioconda::kraken2
source $HOME/.bash_profile
conda activate kraken2
DBNAME=/gpfs01/home/mbzlld/data/ctenella/kraken2/database


# download the libraries I want in my database
kraken2-build --download-library bacteria --db $DBNAME --threads 8


