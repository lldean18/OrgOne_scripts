#!/bin/bash
# 31/3/26

# script to merge individual level vcf files output by clair3 for the 12 ctenella samples

# setup env
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants
module load bcftools-uoneasy/1.19-GCC-13.2.0


bcftools merge \
*.vcf.gz \
 -Oz \
--threads 16 \
--write-index \
--output merged.vcf.gz
