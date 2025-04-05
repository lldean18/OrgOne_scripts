#!/bin/bash
# Laura Dean
# 3/4/25
# for running on the UoN HPC Ada


###########################################################
# set working directory
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger

# Make a dir for the hic data
#mkdir $wkdir/HiC

# download HiC data
cd $wkdir/HiC
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR861/005/SRR8616865/SRR8616865_1.fastq.gz
#wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR861/005/SRR8616865/SRR8616865_2.fastq.gz


# set variables
assembly=$wkdir/hifiasm10/ONTasm.bp.p_ctg_100kb.fasta

hic1=~/data/OrgOne/sumatran_tiger/HiC/SRR8616865_1.fastq.gz
hic2=~/data/OrgOne/sumatran_tiger/HiC/SRR8616865_2.fastq.gz

###########################################################
# install the latest version of BWA for aligning hic reads to the assembly
#conda create -n bwa bwa=0.7.19 -y
#conda install samtools
conda activate bwa

# index the assembly fasta file
bwa index $assembly

# align the hic reads to the assembly and convert to BAM
bwa mem -5SP $assembly $hic1 $hic2 |
	samtools view -bS - > $(basename ${assembly%.*})_hic_mapped.bam

# sort and index the bam
samtools sort --write-index $(basename ${assembly%.*})_hic_mapped.bam -o $(basename ${assembly%.*})_hic_mapped_sorted.bam

# filter the bam file
# -f 0x2: Only properly paired reads.
# -q 30: Only high-quality alignments.
samtools view -b -f 0x2 -q 30 hic_mapped.sorted.bam > hic_mapped.filtered.bam

###########################################################
# install the YAHS scaffolding tool
#conda create --name yahs yahs -y
conda activate yahs



# scaffold with hic data
yahs \
	-o 







# deactivate software
conda deactivate

