#!/bin/bash
# Laura Dean
# 6/2/26

# script to install and use kraken2 to classify reads or contings from ctenella sequencing

#SBATCH --job-name=kraken2
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


##  # download the standard database (did with tmux & srun)
##  cd /gpfs01/home/mbzlld/data/ctenella/kraken2/database
##  wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20240112.tar.gz
##  tar -xvzf k2_standard_20240112.tar.gz
##  
##  # download the core_nt database (did with tmux & srun)
##  cd /gpfs01/home/mbzlld/data/databases/core_nt
##  wget https://genome-idx.s3.amazonaws.com/kraken/k2_core_nt_20251015.tar.gz
##  tar -xvzf k2_core_nt_20251015.tar.gz


#conda create --name kraken2 bioconda::kraken2
source $HOME/.bash_profile
conda activate kraken2

# set variables
DBNAME=/gpfs01/home/mbzlld/data/databases/core_nt/k2_core_nt_20251015
to_classify=


# run kraken2 to classify reads or assembly contigs




