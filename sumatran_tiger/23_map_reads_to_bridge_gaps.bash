#!/bin/bash
# Laura Dean
# 7/3/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=id_gap_spanning_reads
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=150g
#SBATCH --time=36:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# activate software
source $HOME/.bash_profile
conda activate minimap2

reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/simplex_simplex_and_duplex.fastq.gz
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta

# map the raw reads back to our assembly
minimap2 \
-a \
-x map-ont \
-t 48 \
$reads $assembly |
samtools sort - \
-o ${assembly%.*}.bam

# index the bam file
samtools index -bc ${assembly%.*}.bam







# deactivate software
conda deactivate



