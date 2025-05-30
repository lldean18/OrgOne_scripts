#!/bin/bash
# Laura Dean
# 21/3/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40g
#SBATCH --time=168:00:00
#SBATCH --job-name=Black_lemur_backup
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# load the Rclone module
module load rclone-uon/1.65.0

# Copy all of the files from your folder on Augusta to a folder on sharepoint
rclone --transfers 1 --checkers 1 --bwlimit 100M --checksum copy /share/StickleAss/OrgOne/black_and_white_ruffed_lemur OrgOne:black_and_white_ruffed_lemur

# and check that the two folders are identical
rclone check --one-way /share/StickleAss/OrgOne/black_and_white_ruffed_lemur OrgOne:black_and_white_ruffed_lemur

# unload the rclone module
module unload rclone-uon/1.65.0


