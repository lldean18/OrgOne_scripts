#!/bin/bash
# 9/4/26

# code to estimate relatedness between the twelve ctenella samples


# setup env
module load vcftools-uoneasy/0.1.16-GCC-12.3.0
mkdir -p /gpfs01/home/mbzlld/data/ctenella/the_twelve/relatedness
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/relatedness


# estimate relatedness based on the method of Yang et al, Nature Genetics 2010 (doi:10.1038/ng.608)
vcftools \
--gzvcf /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants/the_thirteen_Q30_DP10_SNP_mis1_maf0.1.vcf.gz \
--relatedness

# estimate relatedness based on the method of Manichaikul et al., BIOINFORMATICS 2010 (doi:10.1093/bioinformatics/btq559)
vcftools \
--gzvcf /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants/the_thirteen_Q30_DP10_SNP_mis1_maf0.1.vcf.gz \
--relatedness2


