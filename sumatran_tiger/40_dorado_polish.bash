#!/bin/bash
# Laura Dean
# 10/12/25
# script written for running on the UoN HPC Ada

# script to polish a genome assembly using dorado polish

#SBATCH --job-name=dorado_polish
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=180g
#SBATCH --time=80:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# ran the script twice. For dorado aligner I used
# --cpus-per-task=48
# --mem=180g
# --time=80:00:00


# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/dorado_polish
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta # in fasta or fastq format
reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_extracted_duplex_duplex.fastq.gz # in fastq or bgzipped fastq format

# setup env
cd $wkdir
source $HOME/.bash_profile
conda activate samtools1.22



# Align reads to a reference using dorado aligner, sort and index
dorado aligner $assembly $reads | samtools sort --threads <num_threads> > aligned_reads.bam
samtools index aligned_reads.bam

# # Call consensus
# dorado polish aligned_reads.bam $assembly > polished_assembly.fasta

conda deactivate



