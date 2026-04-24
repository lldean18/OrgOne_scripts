#!/bin/bash

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=4
#SBATCH --cpus-per-task=1
#SBATCH --mem=40g
#SBATCH --time=24:00:00
#SBATCH --job-name=rclone_ctenella_bams
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load the software
module load rclone-uon/1.65.2

# copy a directory called cats from the HPC to MySite
rclone --transfers 4 --checkers 4 --bwlimit 100M --checksum copy /gpfs01/home/mbzlld/data/ctenella/the_twelve/bams ctenella:

# Check the directory has copied successfully
rclone check --one-way /gpfs01/home/mbzlld/data/ctenella/the_twelve/bams ctenella:

# unload the software
module unload rclone-uon/1.65.2
