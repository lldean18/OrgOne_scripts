#!/bin/bash
# 1/4/26

# script to filter merged variants for the 12 ctenella samples

#SBATCH --job-name=filter_variants
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=6g
#SBATCH --time=10:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
source $HOME/.bash_profile
module load bcftools-uoneasy/1.19-GCC-13.2.0
module load vcftools-uoneasy/0.1.16-GCC-12.3.0
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants


# change half calls to missing
bcftools +setGT the_thirteen.bcf -Ob -o the_thirteen_nhc.bcf -- -t ./x -n .

# filter for quality and depth (trying a few depth filters)
bcftools filter -e 'QUAL<30 || DP<10' the_thirteen_nhc.bcf -Oz --threads 16 -o the_thirteen_Q30_DP10.vcf.gz
bcftools filter -e 'QUAL<30 || DP<15' the_thirteen_nhc.bcf -Oz --threads 16 -o the_thirteen_Q30_DP15.vcf.gz
bcftools filter -e 'QUAL<30 || DP<20' the_thirteen_nhc.bcf -Oz --threads 16 -o the_thirteen_Q30_DP20.vcf.gz

# filter to retain only biallelic snps
bcftools view -v snps -m2 -M2 the_thirteen_Q30_DP10.vcf.gz -Oz --threads 16 -o the_thirteen_Q30_DP10_SNP.vcf.gz
bcftools view -v snps -m2 -M2 the_thirteen_Q30_DP15.vcf.gz -Oz --threads 16 -o the_thirteen_Q30_DP15_SNP.vcf.gz
bcftools view -v snps -m2 -M2 the_thirteen_Q30_DP20.vcf.gz -Oz --threads 16 -o the_thirteen_Q30_DP20_SNP.vcf.gz

# filter for missingness and minor allele frequency
vcftools --gzvcf the_thirteen_Q30_DP10_SNP.vcf.gz --max-missing 0.9 --maf 0.05 --recode --stdout |
bgzip > the_thirteen_Q30_DP10_SNP_mis0.9_maf0.05.vcf.gz
vcftools --gzvcf the_thirteen_Q30_DP15_SNP.vcf.gz --max-missing 0.9 --maf 0.05 --recode --stdout |
bgzip > the_thirteen_Q30_DP15_SNP_mis0.9_maf0.05.vcf.gz
vcftools --gzvcf the_thirteen_Q30_DP20_SNP.vcf.gz --max-missing 0.9 --maf 0.05 --recode --stdout |
bgzip > the_thirteen_Q30_DP20_SNP_mis0.9_maf0.05.vcf.gz

# filter for total missingness
vcftools --gzvcf the_thirteen_Q30_DP10_SNP_mis0.9_maf0.05.vcf.gz --max-missing 1 --recode --stdout |
bgzip > the_thirteen_Q30_DP10_SNP_mis1_maf0.05.vcf.gz
vcftools --gzvcf the_thirteen_Q30_DP15_SNP_mis0.9_maf0.05.vcf.gz --max-missing 1 --recode --stdout |
bgzip > the_thirteen_Q30_DP15_SNP_mis1_maf0.05.vcf.gz
vcftools --gzvcf the_thirteen_Q30_DP20_SNP_mis0.9_maf0.05.vcf.gz --max-missing 1 --recode --stdout |
bgzip > the_thirteen_Q30_DP20_SNP_mis1_maf0.05.vcf.gz

# filter for MAF 0.1
vcftools --gzvcf the_thirteen_Q30_DP10_SNP.vcf.gz --max-missing 1 --maf 0.1 --recode --stdout |
bgzip > the_thirteen_Q30_DP10_SNP_mis1_maf0.1.vcf.gz
vcftools --gzvcf the_thirteen_Q30_DP15_SNP.vcf.gz --max-missing 1 --maf 0.1 --recode --stdout |
bgzip > the_thirteen_Q30_DP15_SNP_mis1_maf0.1.vcf.gz
vcftools --gzvcf the_thirteen_Q30_DP20_SNP.vcf.gz --max-missing 1 --maf 0.1 --recode --stdout |
bgzip > the_thirteen_Q30_DP20_SNP_mis1_maf0.1.vcf.gz

# remove the reference individual from the vcf we want to use for tree building
bcftools view -s "^barcoderef" the_thirteen_Q30_DP10_SNP_mis1_maf0.1.vcf.gz -Oz -o the_twelve_Q30_DP10_SNP_mis1_maf0.1.vcf.gz



module unload bcftools-uoneasy/1.19-GCC-13.2.0
module unload vcftools-uoneasy/0.1.16-GCC-12.3.0

