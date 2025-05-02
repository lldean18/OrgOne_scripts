#!/bin/bash
# Laura Dean
# 30/4/25
# for running on the UoN HPC Ada

#SBATCH --job-name=hic_scaffold
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=50g
#SBATCH --time=12:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

###########################################################
# set working directory
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger

#outdir=HiC
outdir=HiC2

# Make a dir for the hic data & move to it
#mkdir $wkdir/$outdir
cd $wkdir/$outdir

# download HiC data
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR861/005/SRR8616865/SRR8616865_1.fastq.gz
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR861/005/SRR8616865/SRR8616865_2.fastq.gz


# set variables
#assembly=$wkdir/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta
assembly=$wkdir/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta

hic1=~/data/OrgOne/sumatran_tiger/HiC/SRR8616865_1.fastq.gz
hic2=~/data/OrgOne/sumatran_tiger/HiC/SRR8616865_2.fastq.gz

############################################################
## install the latest version of BWA for aligning hic reads to the assembly
##conda create -n bwa bwa=0.7.19 -y
##conda install samtools
##conda install picard
#conda activate bwa
#
## index the assembly fasta file
#bwa index $assembly
#
## align the hic reads to the assembly and convert to BAM
#bwa mem -t 32 -S -P -5 $assembly $hic1 $hic2 |
#	samtools view -@ 32 -b -q 30 - > $(basename ${assembly%.*})_hic_mapped.bam
#
#
#
#
#
#
############ sort the bam by read name
############samtools sort -@ 32 -n $(basename ${assembly%.*})_hic_mapped.bam |
############# mark pcr duplicates
############samtools fixmate -m -@ 32 - - |
############# sort the bam by cooprdinate
############samtools sort -@ 32 -o $(basename ${assembly%.*})_hic_mapped_sorted.bam -
############samtools markdup \
############       --write-index \
############       -r \
############       -@ 32 \
############       -s -f $(basename ${assembly%.*})_hic_mapped_dup_stats.txt \
############       --output-fmt BAM $(basename ${assembly%.*})_hic_mapped_sorted.bam $(basename ${assembly%.*})_hic_mapped_dedup.bam
###########
############# sort the bam by read name
############samtools sort -@ 32 -n $(basename ${assembly%.*})_hic_mapped.bam |
############# mark pcr duplicates
############samtools fixmate -m -@ 32 - - |
############# sort the bam by cooprdinate
############samtools sort -@ 32 - |
############samtools markdup \
############	--write-index \
############	-r \
############	-@ 32 \
############	-s -f $(basename ${assembly%.*})_hic_mapped_dup_stats.txt \
############	--output-fmt BAM - $(basename ${assembly%.*})_hic_mapped_dedup.bam
############# mark pcr duplicates in the bam with picard
############picard MarkDuplicates \
############	-I $(basename ${assembly%.*})_hic_mapped_sorted.bam \
############	-O $(basename ${assembly%.*})_hic_mapped_sorted_dupmk.bam \
############	-M $(basename ${assembly%.*})_picard_dup_metrics.txt \
############	--CREATE_INDEX true \
############	--READ_NAME_REGEX null
#
#
#
#
#
#
#conda deactivate
#
#
##########################################################
# install the YAHS scaffolding tool
#conda create --name yahs yahs -y
conda activate yahs

## index the assembly with samtools
#samtools faidx $assembly
#
## scaffold with hic data
#yahs \
#	-o $wkdir/$outdir/$(basename ${assembly%.*})_yahs \
#	$assembly \
#	$(basename ${assembly%.*})_hic_mapped.bam
#
###########################################################
# prepare the files for visualisation in juicebox
(juicer pre $(basename ${assembly%.*})_yahs.bin $(basename ${assembly%.*})_yahs_scaffolds_final.agp $assembly.fai |
       	sort -k2,2d -k6,6d -T ./ --parallel=8 -S32G |
       	awk 'NF' > alignments_sorted.txt.part) && (mv alignments_sorted.txt.part alignments_sorted.txt)

# deactivate software
conda deactivate

###########################################################
# generate hi-c contact matrix with juicer tools
# first make the chrom sizes file
conda activate bwa
samtools faidx $(basename ${assembly%.*})_yahs_scaffolds_final.fa
cut -f1,2 $(basename ${assembly%.*})_yahs_scaffolds_final.fa.fai > $(basename ${assembly%.*})_yahs_scaffolds_final.chrom.sizes
conda deactivate

module load java-uoneasy/17.0.6
java -jar -Xmx64G ~/software_bin/juicer/juicer_tools_1.22.01.jar pre \
	alignments_sorted.txt out.hic.part $(basename ${assembly%.*})_yahs_scaffolds_final.chrom.sizes
mv out.hic.part out.hic

# deactivate module
module unload java-uoneasy/17.0.6






