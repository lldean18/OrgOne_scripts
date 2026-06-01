#!/bin/bash
# Laura Dean
# 14/5/26

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
cd /share/deepseq/org_one/SNT052/assembly_QC
bam=/share/deepseq/org_one/SNT052/hifiasm/turtle.bp.p_ctg_mapped_reads.bam


# calculate coverage depth for each contig
samtools depth -a $bam |
awk '{sum[$1]+=$3; count[$1]++} END {for (c in sum) print c, sum[c]/count[c]}' > $(basename ${bam%.*})_depth.txt


conda deactivate


