#!/bin/bash
# 1/4/26

# script to filter merged variants for the 12 ctenella samples

#SBATCH --job-name=filter_variants
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=6g
#SBATCH --time=1:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
source $HOME/.bash_profile
module load bcftools-uoneasy/1.19-GCC-13.2.0
module load vcftools-uoneasy/0.1.16-GCC-12.3.0
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants


###  # filter for quality and depth
###  bcftools filter \
###    -e 'QUAL<30 || DP<10' \
###    the_twelve.bcf \
###    -Oz \
###    --threads 16 \
###    -o the_twelve_filtered.vcf.gz

###  # filter to retain only biallelic snps
###  bcftools view \
###    -v snps \
###    -m2 -M2 \
###    the_twelve_filtered.vcf.gz \
###    -Oz \
###    -o the_twelve_snps.vcf.gz
###  
###  # filter for missingness and minor allele frequency
###  vcftools \
###    --gzvcf the_twelve_snps.vcf.gz \
###    --max-missing 0.9 \
###    --maf 0.05 \
###    --recode --stdout | bgzip > the_twelve_snps_0.9missing_0.5maf.vcf.gz

###  # change half calls to missing
###  bcftools +setGT the_twelve_snps_0.9missing_0.5maf.vcf.gz -- -t ./x -n . | bgzip > the_twelve_snps_0.9missing_0.5maf_nopartialcalls.vcf.gz

# filter for total missingness
vcftools \
  --gzvcf the_twelve_snps.vcf.gz \
  --max-missing 1 \
  --recode --stdout | bgzip > the_twelve_snps_0.5maf_nopartialcalls_nomissing.vcf.gz

# filter for MAF 0.1
vcftools \
  --gzvcf the_twelve_snps_0.5maf_nopartialcalls_nomissing.vcf.gz \
  --maf 0.1 \
  --recode --stdout | bgzip > the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz



module unload bcftools-uoneasy/1.19-GCC-13.2.0
module unload vcftools-uoneasy/0.1.16-GCC-12.3.0

