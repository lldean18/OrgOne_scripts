#!/bin/bash
# Laura Dean
# 5/3/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40g
#SBATCH --time=168:00:00
#SBATCH --job-name=ChimpBackup
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbzlld@exmail.nottingham.ac.uk


# load the Rclone module
module load rclone-uon/1.65.0

# Copy all of the files from your folder on Augusta to a folder on sharepoint
rclone --transfers 1 --checkers 1 --bwlimit 100M --checksum copy ~/data/OrgOne/western_chimpanzee OrgOne:western_chimpanzee

# and check that the two folders are identical
rclone check --one-way ~/data/OrgOne/western_chimpanzee OrgOne:western_chimpanzee

# unload the rclone module
module unload rclone-uon/1.65.0

