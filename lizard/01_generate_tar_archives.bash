#!/bin/bash
# 02/8/26

# script to generate tar archives for ENA submission

#SBATCH --job-name=tar_archive
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=14:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set up env
cd /share/deepseq/matt/Gallotia_intermedia
mkdir -p /gpfs01/home/mbzlld/data/OrgOne/lizard

# # make tar archive
# tar -czf /gpfs01/home/mbzlld/data/OrgOne/lizard/gallotia_intermedia_pod5s.tar.gz \
# 20260727_1507_3F_PBG20569_84abc30c/pod5 

# generate md5sums
md5sum /gpfs01/home/mbzlld/data/OrgOne/lizard/gallotia_intermedia_pod5s.tar.gz > /gpfs01/home/mbzlld/data/OrgOne/lizard_pod5s.md5

# check the gzip integrity of the file
gzip -t /gpfs01/home/mbzlld/data/OrgOne/lizard/gallotia_intermedia_pod5s.tar.gz



