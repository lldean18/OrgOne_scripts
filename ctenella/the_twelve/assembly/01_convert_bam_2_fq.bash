#!/bin/bash
# 30/3/26

# script for converting bams to fastqs

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=10g
#SBATCH --time=12:00:00
#SBATCH --job-name=bam2fastq
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12

cd /gpfs01/home/mbzlld/data/ctenella/the_twelve
mkdir -p fastqs

CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt

# extract the bam file paths and names from the config file
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)

# load modules
module load samtools-uoneasy/1.18-GCC-12.3.0

# write the name of the file being converted
echo "converting reads from $ind"

# convert the bam files to fastq format
# -O output qulaity tags if they exist
# -t output RG, BC and QT tags to the FASTQ header line
# then pipe to gzip so that the file is properly compressed for flye to run on it later
samtools bam2fq \
-O \
-t \
--threads 23 \
bams/map_sort_barcode${ind}.bam | gzip > fastqs/barcode${ind}.fastq.gz

# unload modules
module unload samtools-uoneasy/1.18-GCC-12.3.0

