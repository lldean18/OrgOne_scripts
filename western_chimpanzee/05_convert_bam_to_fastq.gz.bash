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
#SBATCH --job-name=CHIbam2fastq
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load modules
module load samtools-uoneasy/1.18-GCC-12.3.0

# set variables
species=western_chimpanzee # set the species
wkdir=/gpfs01/home/mbzlld/data/OrgOne/${species} # set the working directory
bam=${wkdir}/basecalls/${species}.bam # set the full bam file name and further path

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
$bam | gzip > $wkdir/basecalls/$species.fastq.gz

# unload modules
module unload samtools-uoneasy/1.18-GCC-12.3.0

