#!/bin/bash
# 1/4/26

# script to generate stats abount genotypes in the 12 ctenella samples

#SBATCH --job-name=variant_stats
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=10g
#SBATCH --time=3:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
source $HOME/.bash_profile
module load bcftools-uoneasy/1.19-GCC-13.2.0
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants

###  # generate info about individuals in vcf
###  bcftools stats \
###  --threads 16 \
###  the_twelve_filtered.vcf.gz > the_twelve_filtered_stats.txt
###  
###  # plot that info
###  plot-vcfstats \
###  -p vcf_plots \
###  the_twelve_filtered_stats.txt
###  
###  conda activate python3.12
###  python3 vcf_plots/plot.py
###  conda deactivate

# this wasnt really what I was after, try a different option

bcftools +counts the_twelve_filtered.vcf.gz > the_twelve_filtered_counts_summary.txt


module unload bcftools-uoneasy/1.19-GCC-13.2.0

