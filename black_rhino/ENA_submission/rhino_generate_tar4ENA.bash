#!/bin/bash
# Laura Dean
# 28/3/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=10g
#SBATCH --time=48:00:00
#SBATCH --job-name=rhino_tar
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

species=black_rhino

# there are2 runs for submission for this species = P1 and P2

# move to the directory containing the pod5 files to be tarred
cd /share/StickleAss/OrgOne/$species/pod5_files






# create a compressed tar archive of each promethion run
tar -cvzf ${species}_P1_pod5s.tar.gz ./Black_Rhino_P1

# create md5 checksums
md5sum ${species}_P1_pod5s.tar.gz > ${species}_P1_pod5s.md5






# create a compressed tar archive of each promethion run
tar -cvzf ${species}_P2_pod5s.tar.gz ./Black_rhino_P2

# create md5 checksums
md5sum ${species}_P2_pod5s.tar.gz > ${species}_P2_pod5s.md5




