#!/bin/bash
# Laura Dean
# 6/3/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=10g
#SBATCH --time=12:00:00
#SBATCH --job-name=tig_bam2fastq
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-34

# set variables
species=sumatran_tiger
wkdir=/gpfs01/home/mbzlld/data/OrgOne/$species # set the working directory
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/${species}_bam_convert_array_config.txt # set the name of the config file


##### GENERATE THE ARRAY CONFIG FILE #####
# # generate list of file paths for the array config
# cd $wkdir/basecalls
# # list all directories containing bam files & write to config file
# find . -type f -name '*.bam' | sort -u > ${config%.*}_tmp.txt
# # add the start of the filepath to the config file (bc we cd'd to only get tiger, it only prints from there)
# sed -i "s/[.]/\/gpfs01\/home\/mbzlld\/data\/OrgOne\/$species\/basecalls/" ${config%.*}_tmp.txt
# # add array numbers to config file
# awk '{print NR,$0}' ${config%.*}_tmp.txt > $config
# rm ${config%.*}_tmp.txt # remove the temp file

# extract the bam file paths and names from the config file
bam=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)

# load modules
module load samtools-uoneasy/1.18-GCC-12.3.0

# write the name of the file being converted
echo "converting reads from $bam"

# check how many reads are in the bam file or files you want to convert
samtools flagstat $bam

# convert the bam files to fastq format
# -O output qulaity tags if they exist
# -t output RG, BC and QT tags to the FASTQ header line
# then pipe to gzip so that the file is properly compressed for flye to run on it later
samtools bam2fq \
-O \
-t \
--threads 23 \
$bam | gzip > ${bam%.*}.fastq.gz

# unload modules
module unload samtools-uoneasy/1.18-GCC-12.3.0

