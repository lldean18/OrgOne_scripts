#!/bin/bash
# Laura Dean
# 1/12/23

#SBATCH --partition=LocalQ
#SBATCH --nodes=1
#SBATCH --ntasks=24
#SBATCH --tasks-per-node=24
#SBATCH --mem=4g
#SBATCH --time=12:00:00
#SBATCH --job-name=bam2fastq
#SBATCH --output=/home/mbzlld/slurm-%x-%j.out

# set this script up to run as a job but there was a queue so pasted each conversion into a tmux window.

# set variables
spp_dir=/data/test_data/org_one/black_rhino # data directory for your species

# check how many reads are in the bam files you want to convert
samtools flagstat $spp_dir/rhino_sup_epi2me/Rhino.pass.bam
# 4591312
samtools flagstat $spp_dir/rhino_sup_epi2me/Rhino.fail.bam
# 668049


# convert the bam files to fastq format
# -O output qulaity tags if they exist
# -t output RG, BC and QT tags to the FASTQ header line
# then pipe to gzip so that the file is properly compressed for flye to run on it later

# for pass reads
samtools bam2fq \
-O \
-t \
$spp_dir/rhino_sup_epi2me/Rhino.pass.bam | gzip > $spp_dir/fastq_files/Rhino.pass.fastq.gz

# for fail reads
samtools bam2fq \
-O \
-t \
$spp_dir/rhino_sup_epi2me/Rhino.fail.bam | gzip > $spp_dir/fastq_files/Rhino.fail.fastq.gz

