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
#SBATCH --job-name=Rlemur_tar
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

species=red_ruffed_lemur

# # move to the directory containing the pod5 files to be tarred
# cd ~/data/OrgOne/$species/pod5_files/duplex
# # create a compressed tar archive of each promethion run
# tar -cvzf ${species}_duplex_pod5s.tar.gz ./Red_ruffed_lemur_duplex

# for the final 2 files that had 2 runs within 1 promethion name
#srun --partition defq --cpus-per-task 1 --mem 50g --time 12:00:00 --pty bash
cd /gpfs01/home/mbzlld/data/OrgOne/red_ruffed_lemur/pod5_files/duplex/Red_ruffed_lemur_duplex_ns
tar -cvzf ${species}_duplex_ns_222_pod5s.tar.gz ./20230222_1214_2F_PAK98894_6a3ac6e2
tar -cvzf ${species}_duplex_ns_225_pod5s.tar.gz ./20230225_1402_2F_PAK98894_d8bc6d2d




# # move to the directory containing the pod5 files to be tarred
# cd ~/data/OrgOne/$species/pod5_files/simplex
# # create a compressed tar archive of each promethion run
# tar -cvzf ${species}_P1_pod5s.tar.gz ./Red_ruffed_lemur_P1
# tar -cvzf ${species}_sheared_P1_pod5s.tar.gz ./Red_ruffed_lemur_sheared_P1


