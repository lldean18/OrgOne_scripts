#!/bin/bash
# Laura Dean
# 10/12/25
# script written for running on the UoN HPC Ada

# script to polish a genome assembly using dorado polish

#SBATCH --job-name=dorado_polish
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=361g
#SBATCH --time=168:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# ran the script twice. For dorado aligner I used
# --cpus-per-task=49
# --mem=180g
# --time=80:00:00
# this step actually completed in 10 mins and used 55G max memory

# for dorado polish I used
# --cpus-per-task=96
# --mem=361g
# --time=168:00:00


# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/dorado_polish
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta # in fasta or fastq format
reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_extracted_duplex_duplex.bam # in fastq or bgzipped fastq format

# setup env
cd $wkdir
source $HOME/.bash_profile
conda activate samtools1.22

# Hashing out this bit as it completed sucessfully once already
# # Align reads to a reference using dorado aligner, sort and index
# dorado aligner $assembly $reads | samtools sort --threads 92 > aligned_reads.bam
# samtools index aligned_reads.bam

# Call consensus
dorado polish aligned_reads.bam $assembly --RG 88c80469a5386fd52e4b9cc875650f868f7566f8_dna_r10.4.1_e8.2_400bps_sup@v4.1.0 > polished_assembly.fasta

conda deactivate



