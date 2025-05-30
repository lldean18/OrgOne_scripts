#!/bin/bash
# Laura Dean
# 10/2/24

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=10g
#SBATCH --time=24:00:00
#SBATCH --job-name=BlLemur_tar
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

species=black_and_white_ruffed_lemur

# move to the directory containing the pod5 files to be tarred
cd /share/StickleAss/OrgOne/$species

# create a compressed tar archive 
tar -cvzf ${species}_pod5s.tar.gz ./pod5_files


