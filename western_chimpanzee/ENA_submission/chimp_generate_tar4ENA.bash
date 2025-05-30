#!/bin/bash
# Laura Dean
# 4/3/24
# ror running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=10g
#SBATCH --time=24:00:00
#SBATCH --job-name=chimp_tar
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# move to the directory containing the pod5 files to be tarred
cd /gpfs01/home/mbzlld/data/OrgOne/western_chimpanzee

# # create a compressed tar archive (when I thought I could submit the pod5 files)
# tar -cvzf western_chimpanzee_pod5s.tar.gz ./pod5_files

# now I know I have to submit basecalled fast5 files
tar -cvzf western_chimpanzee_fast5s.tar.gz ./fast5_files/Western_Chimpanzee_P1/20230207_1523_1H_PAM70437_b2fc7302/fast5_pass ./fast5_files/Western_Chimpanzee_P1/20230207_1523_1H_PAM70437_b2fc7302/fast5_fail

