#!/bin/bash
# 1/4/26

# script to generate stats abount genotypes in the 12 ctenella samples

# setup env
source $HOME/.bash_profile
module load bcftools-uoneasy/1.19-GCC-13.2.0
conda activate r
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants

###################################
### VENN DIAGRAM OF SNP SHARING ###
###################################

# extract SNP info from vcf for 3 key inds
bcftools view -s barcode22 -v snps the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz |
bcftools query -i 'GT!="0/0" && GT!="./."' -f '%CHROM:%POS\n' \
> barcode22_snps.txt

bcftools view -s barcode17 -v snps the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz |
bcftools query -i 'GT!="0/0" && GT!="./."' -f '%CHROM:%POS\n' \
> barcode17_snps.txt

bcftools view -s barcode23 -v snps the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz |
bcftools query -i 'GT!="0/0" && GT!="./."' -f '%CHROM:%POS\n' \
> barcode23_snps.txt

bcftools view -s barcode29 -v snps the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz |
bcftools query -i 'GT!="0/0" && GT!="./."' -f '%CHROM:%POS\n' \
> barcode29_snps.txt

bcftools view -s barcode30 -v snps the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz |
bcftools query -i 'GT!="0/0" && GT!="./."' -f '%CHROM:%POS\n' \
> barcode30_snps.txt

# plot the venn diagram in r
R
s1 <- scan("barcode29_snps.txt", what = character())
s2 <- scan("barcode17_snps.txt", what = character())
s3 <- scan("barcode30_snps.txt", what = character())
library(VennDiagram)
venn.plot <- venn.diagram(
  x = list(barcode29 = s1, barcode17 = s2, barcode30 = s3),
  filename = NULL,
  fill = c("skyblue", "pink", "lightgreen"),
  alpha = 0.5, cex = 1.5, cat.cex = 1.2)
jpeg("snp_sharing_venn_within_group.jpeg", width = 2000, height = 2000, res = 300)
grid::grid.draw(venn.plot)
dev.off()



module unload bcftools-uoneasy/1.19-GCC-13.2.0

