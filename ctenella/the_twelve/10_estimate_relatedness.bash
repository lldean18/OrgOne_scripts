#!/bin/bash
# 9/4/26

# code to estimate relatedness between the twelve ctenella samples


# setup env
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants
module load vcftools-uoneasy/0.1.16-GCC-12.3.0


# estimate relatedness based on the method of Yang et al, Nature Genetics 2010 (doi:10.1038/ng.608)
vcftools \
--gzvcf the_twelve_snps_0.5maf_nopartialcalls_nomissing.vcf.gz \
--relatedness

# estimate relatedness based on the method of Manichaikul et al., BIOINFORMATICS 2010 (doi:10.1093/bioinformatics/btq559)
vcftools \
--gzvcf the_twelve_snps_0.5maf_nopartialcalls_nomissing.vcf.gz \
--relatedness2


