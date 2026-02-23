#!/bin/bash
# Laura Dean
# 23/2/26
# script written for running on the UoN HPC Ada

# script to filter the bam of mapped reads to retain only the contigs in the filtered asm

#SBATCH --job-name=filter_bam
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=34
#SBATCH --mem=50g
#SBATCH --time=24:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# activate software
source $HOME/.bash_profile
conda activate minimap2

# set variables
bam=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_mapped_raw_reads.bam
filtered_asm=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_Scleractinia.fasta

# extract the contig names from the filtered asm
grep "^>" $filtered_asm | sed 's/^>//' > ${filtered_asm%.*}_contig_names.txt
#grep "^>" $filtered_asm | sed 's/^>//' | sed '/ *//' > ${filtered_asm%.*}_contig_names.txt


# filter the bam file to retain only reads in the filtered asm
samtools view -b $bam $(cat ${filtered_asm%.*}_contig_names.txt) > ${bam%.*}_Scleractinia.bam

# index the filtered bam
samtools index ${bam%.*}_Scleractinia.bam

conda deactivate
