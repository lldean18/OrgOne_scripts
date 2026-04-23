#!/bin/bash
# 23/4/26

# script to generate stats abount genotypes in the 13 ctenella samples

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


# count the number of variants that differ from the reference
# for all files in a list and write to an output file
rm non_ref_variant_counts.tsv
files=(the_thirteen_Q30_DP10_SNP_mis1_maf0.1.vcf.gz the_thirteen_Q30_DP15_SNP_mis1_maf0.1.vcf.gz the_thirteen_Q30_DP20_SNP_mis1_maf0.1.vcf.gz the_thirteen_Q30_DP10_SNP_mis1_maf0.05.vcf.gz the_thirteen_Q30_DP15_SNP_mis1_maf0.05.vcf.gz the_thirteen_Q30_DP20_SNP_mis1_maf0.05.vcf.gz)
for file in ${files[@]}
do
bcftools query -f '[%SAMPLE\t%GT\n]' $file \
| awk '$2!="0/0" && $2!="./." && $2!~/\./' | cut -f1 | sort | uniq -c > tmp
sed -i "s/$/\t${file%.vcf.gz}/" tmp
cat tmp >> non_ref_variant_counts.tsv
rm tmp
done

# make the output file fully tab separated
awk '{print $1, $2, $3}' OFS='\t' non_ref_variant_counts.tsv > tmp && mv tmp non_ref_variant_counts.tsv

# count the number of variants that differ from the reference (for a single file at a time)
bcftools query -f '[%SAMPLE\t%GT\n]' the_thirteen_Q30_DP15_SNP_mis1_maf0.1.vcf.gz \
| awk '$2!="0/0" && $2!="./." && $2!~/\./' | cut -f1 | sort | uniq -c

# count the number of sites that match the reference
bcftools query -f '[%SAMPLE\t%GT\n]' the_thirteen_Q30_DP15_SNP_mis1_maf0.1.vcf.gz \
| awk '$2=="0/0"' | cut -f1 | sort | uniq -c












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

