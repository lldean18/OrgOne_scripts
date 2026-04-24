#!/bin/bash
# 23/4/26

# script to remove all sites from the ctenella 13 vcf that are called as non ref in the ref ind


# setup env
source $HOME/.bash_profile
module load bcftools-uoneasy/1.19-GCC-13.2.0
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants


# indetify sites to be removed
bcftools view -s barcoderef the_thirteen_Q30_DP15_SNP_mis1_maf0.1.vcf.gz |
bcftools view -i 'GT!="0/0"' |
bcftools query -f '%CHROM\t%POS\n' > nonref_sites.tsv

# remove those sites from the vcf
bcftools view -T ^nonref_sites.tsv the_thirteen_Q30_DP15_SNP_mis1_maf0.1.vcf.gz \
-Oz -o the_thirteen_Q30_DP15_SNP_mis1_maf0.1_RefRm.vcf.gz


