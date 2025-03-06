#!/bin/bash
# Laura Dean
# 8/3/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=50g
#SBATCH --time=12:00:00
#SBATCH --job-name=tig_dup_extract
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-10

# set variables
species=sumatran_tiger
wkdir=/gpfs01/home/mbzlld/data/OrgOne/$species # set the working directory
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/${species}_bam_dup_extract_array_config.txt # set the name of the config file

##### GENERATE THE ARRAY CONFIG FILE #####
# # generate list of file paths for the array config
# cd $wkdir/basecalls
# # list all directories containing bam files & write to config file
# find . -type f -name '*.bam' | sort -u > ${config%.*}_tmp.txt
# # retain only the lines that contain the word duplex
# sed -i '/duplex/!d' ${config%.*}_tmp.txt
# # add the start of the filepath to the config file (bc we cd'd to only get tiger, it only prints from there)
# sed -i "s/[.]/\/gpfs01\/home\/mbzlld\/data\/OrgOne\/$species\/basecalls/" ${config%.*}_tmp.txt
# # add array numbers to config file
# awk '{print NR,$0}' ${config%.*}_tmp.txt > $config
# rm ${config%.*}_tmp.txt # remove the temp file


##### PERFORM TASK #####
# get array variable from config file
bam=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)

# load modules
module load samtools-uoneasy/1.18-GCC-12.3.0

# # extract duplex reads from bam files
# samtools view \
# --tag dx:1 \
# --threads 48 \
# -O bam \
# --write-index \
# --output ${bam%.*}_duplex.bam \
# $bam

# extract simplex reads from bam files
samtools view \
--tag dx:0 \
--tag dx:-1 \
--threads 48 \
-O bam \
--write-index \
--output ${bam%.*}_simplex.bam \
$bam



