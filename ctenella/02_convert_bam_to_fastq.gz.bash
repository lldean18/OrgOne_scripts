#!/bin/bash
# Laura Dean
# 26/11/25
# for running on the UoN HPC Ada

# Script to convert basecalled bam files to fastq.gz

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=10g
#SBATCH --time=12:00:00
#SBATCH --job-name=bam2fastq
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set variables
bam=/gpfs01/home/mbzlld/data/ctenella/basecalls/SUP_calls.bam

# load modules
module load samtools-uoneasy/1.18-GCC-12.3.0

# write the name of the file being converted
echo "converting reads from $bam"

# check how many reads are in the bam file or files you want to convert
samtools flagstat $bam

# convert the bam files to fastq format
# -O output quality tags if they exist
# -t output RG, BC and QT tags to the FASTQ header line
# then pipe to gzip so that the file is properly compressed for flye to run on it later
samtools bam2fq \
-O \
-t \
--threads 23 \
$bam | gzip > ${bam%.*}.fastq.gz

# unload modules
module unload samtools-uoneasy/1.18-GCC-12.3.0

