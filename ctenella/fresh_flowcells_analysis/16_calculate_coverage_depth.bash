#!/bin/bash
# Laura Dean
# 23/2/26

# Script to calculate coverage depth

#SBATCH --job-name=depth_calc
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=8:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# set up env
source $HOME/.bash_profile
conda activate samtools1.22

# set variables
bam=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_mapped_raw_reads_Scleractinia.bam


# calculate coverage depth for each contig
samtools depth -a $bam |
awk '{sum[$1]+=$3; count[$1]++} END {for (c in sum) print c, sum[c]/count[c]}' > ${bam%.*}_depth.txt


conda deactivate


