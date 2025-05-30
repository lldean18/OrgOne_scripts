#!/bin/bash


#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=40g
#SBATCH --time=24:00:00
#SBATCH --job-name=RMOrgOneBackup
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbzlld@exmail.nottingham.ac.uk


# load the Rclone module
module load rclone-uon/1.47.0


# Copy all of the files from your folder on Augusta to a folder on sharepoint
rclone --transfers 1 --checkers 1 --bwlimit 100M --checksum copy /share/StickleAss/OrgOne/roloway_monkey "OrgOne:roloway_monkey"

# and check that the two folders are identical
rclone check --one-way --verbose /share/StickleAss/OrgOne/roloway_monkey "OrgOne:roloway_monkey"

# unload the rclone module
module unload rclone-uon/1.47.0


