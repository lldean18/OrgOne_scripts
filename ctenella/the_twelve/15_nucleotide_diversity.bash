#!/bin/bash
# 26/6/26

# script to calculate nucleotide diversity

#SBATCH --job-name=calculate_pi
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=4:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
module load vcftools-uoneasy/0.1.16-GCC-12.3.0
module load bcftools-uoneasy/1.18-GCC-13.2.0
mkdir -p /gpfs01/home/mbzlld/data/ctenella/the_twelve/nucleotide_diversity
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/nucleotide_diversity



# calculate nucleotide diversity across all samples in 100kb windows
vcftools \
    --gzvcf ../variants/the_twelve_Q30_DP10_SNP_mis1_maf0.1.vcf.gz \
    --window-pi 10000 \
    --out nucleotide_diversity_10kb_winds



# cleanup env
module unload vcftools-uoneasy/0.1.16-GCC-12.3.0
module unload bcftools-uoneasy/1.18-GCC-13.2.0

