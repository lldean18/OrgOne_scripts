#!/bin/bash
# 6/5/26

# script to convert the dorado bam file from basecalling to fq format for assembly

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=10g
#SBATCH --time=12:00:00
#SBATCH --job-name=bam2fastq
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
cd /share/deepseq/org_one/SNT052/SUP_basecalls
module load samtools-uoneasy/1.18-GCC-12.3.0

# convert the bam files to fastq format
# -O output qulaity tags if they exist
# -t output RG, BC and QT tags to the FASTQ header line
# then pipe to gzip so that the file is properly compressed for flye to run on it later
samtools bam2fq -O -t --threads 23 turtle_SUP.bam | gzip > turtle_SUP.fastq.gz

# cleanup env
module unload samtools-uoneasy/1.18-GCC-12.3.0


