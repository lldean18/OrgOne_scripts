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
# this wasnt really what I was after, try a different option


bcftools query -f '[%SAMPLE\t%GT\n]' the_twelve_filtered.vcf.gz \
| awk '$2!="0/0" && $2!="./." && $2!~/\./' \
| cut -f1 \
| sort \
| uniq -c

# count the number of variants that differ from the reference
bcftools query -f '[%SAMPLE\t%GT\n]' the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz \
| awk '$2!="0/0" && $2!="./." && $2!~/\./' \
| cut -f1 \
| sort \
| uniq -c

### 0.05 MAF
#  212657 barcode17
#  232759 barcode18
#  233928 barcode19
#  230534 barcode20
#  223021 barcode21
#  219241 barcode22
#  235436 barcode23
#  209501 barcode24
#  213517 barcode29
#  144702 barcode30
#  213839 barcode31
#  217648 barcode32

### 0.1 MAF
# 170554 barcode17
# 185800 barcode18
# 190103 barcode19
# 184025 barcode20
# 179826 barcode21
# 176407 barcode22
# 188537 barcode23
# 166636 barcode24
# 171340 barcode29
# 115184 barcode30
# 170363 barcode31
# 175011 barcode32


# count the number of sites that match the reference
bcftools query -f '[%SAMPLE\t%GT\n]' the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz \
| awk '$2=="0/0"' \
| cut -f1 \
| sort \
| uniq -c

### 0.05 MAF
#  355735 barcode17
#  335633 barcode18
#  334464 barcode19
#  337858 barcode20
#  345371 barcode21
#  349151 barcode22
#  332956 barcode23
#  358891 barcode24
#  354875 barcode29
#  423690 barcode30
#  354553 barcode31
#  350744 barcode32

### 0.1 MAF
# 139197 barcode17
# 123951 barcode18
# 119648 barcode19
# 125726 barcode20
# 129925 barcode21
# 133344 barcode22
# 121214 barcode23
# 143115 barcode24
# 138411 barcode29
# 194567 barcode30
# 139388 barcode31
# 134740 barcode32


# count the number of SNPs per contig
bcftools view -v snps the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz |
 bcftools query -f '%CHROM\n' | sort | uniq -c |
awk '{print $2"\t"$1}' > snp_counts.txt

# extract contig lengths to divide by
bcftools view -h the_twelve_snps_0.1maf_nopartialcalls_nomissing.vcf.gz | grep '^##contig' | \
sed 's/.*ID=\([^,]*\),length=\([0-9]*\).*/\1\t\2/' > contig_lengths.txt

# join the 2 files
join contig_lengths.txt snp_counts.txt > contig_snp_counts.txt

# calculate SNP density
awk '{print $1, $2, $3, ($3/$2)*1000000}' contig_snp_counts.txt > contig_snp_density.txt

# plot SNP density per contig
conda activate r
R
library(ggplot2)
options(scipen=999)

df <- read.table("contig_snp_density.txt", header = FALSE)
colnames(df) <- c("contig", "length", "snp_count", "snp_density")

# the scatter plot
p <- ggplot(df, aes(x = length, y = snp_density)) +
  geom_point() +
  labs(x = "Contig length", y = "SNP density (per Mb)") +
  theme_classic()
ggsave("contig_snp_density.jpeg", plot = p, width = 8, height = 6, dpi = 300)

# the histogram
p <- ggplot(df, aes(x = snp_density)) +
  geom_histogram(bins = 50) +
  labs(x = "SNP density (per Mb)", y = "Number of contigs", title = "Distribution of SNP density across contigs") +
  theme_classic()
ggsave("snp_density_histogram.jpeg", plot = p, width = 8, height = 6, dpi = 300)
q()

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

# plot the venn diagram in r
R
s1 <- scan("barcode22_snps.txt", what = character())
s2 <- scan("barcode17_snps.txt", what = character())
s3 <- scan("barcode23_snps.txt", what = character())
library(VennDiagram)
venn.plot <- venn.diagram(
  x = list(barcode22 = s1, barcode17 = s2, barcode23 = s3),
  filename = NULL,
  fill = c("skyblue", "pink", "lightgreen"),
  alpha = 0.5, cex = 1.5, cat.cex = 1.2)
jpeg("snp_sharing_venn.jpeg", width = 2000, height = 2000, res = 300)
grid::grid.draw(venn.plot)
dev.off()



module unload bcftools-uoneasy/1.19-GCC-13.2.0

