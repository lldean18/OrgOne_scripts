#!/bin/bash
# 15/6/26

# script to generate tar archives for the snake-necked turtle for ENA submission

#SBATCH --job-name=tar_archive
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=14:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set up env
cd /share/deepseq/org_one

# make tar archive for each barcode for the pod5 files from the twelve
tar -czf /gpfs01/home/mbzlld/data/OrgOne/turtle/chelodina_mccordi_mccordi_pod5s.tar.gz \
 SNT052/20260428_1505_1E_PBG22653_beadde09/pod5 

# generate md5sums
md5sum /gpfs01/home/mbzlld/data/OrgOne/turtle/chelodina_mccordi_mccordi_pod5s.tar.gz > /gpfs01/home/mbzlld/data/OrgOne/turtle/chelodina_mccordi_mccordi_pod5s.md5

# check the gzip integrity of the file
gzip -t /gpfs01/home/mbzlld/data/OrgOne/turtle/chelodina_mccordi_mccordi_pod5s.tar.gz



