#!/bin/bash
# 10/8/26

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=40g
#SBATCH --time=24:00:00
#SBATCH --job-name=rclone_lizard
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load the software
module load rclone-uon/1.65.2

# copy a directory called cats from the HPC to MySite
rclone --transfers 4 --checkers 4 --bwlimit 100M --checksum --max-depth 1 copy \
/share/deepseq/laura/lizard/fastqs ctenella:gallotia_intermedia/fastqs

# Check the directory has copied successfully
rclone check --one-way --max-depth 1 /share/deepseq/laura/lizard/fastqs ctenella:gallotia_intermedia/fastqs

# unload the software
module unload rclone-uon/1.65.2




