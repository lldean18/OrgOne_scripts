#!/bin/bash
# Laura Dean
# 26/3/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=10g
#SBATCH --time=24:00:00
#SBATCH --job-name=spid_monkey_tar
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

species=brown_spider_monkey

# move to the directory containing the pod5 files to be tarred
cd /share/StickleAss/OrgOne/$species

# create a compressed tar archive of each promethion run
tar -cvzf ${species}_P1_pod5s.tar.gz ./pod5_files

# there is just 1 run for submission for this species = P1


# create md5 checksums
md5sum ${species}_P1_pod5s.tar.gz > ${species}_P1_pod5s.md5

