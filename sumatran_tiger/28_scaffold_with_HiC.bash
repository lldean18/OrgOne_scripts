#!/bin/bash
# Laura Dean
# 3/4/25
# for running on the UoN HPC Ada

#SBATCH --job-name=hic_scaffold
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=50g
#SBATCH --time=60:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

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
assembly=$wkdir/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta

hic1=~/data/OrgOne/sumatran_tiger/HiC/SRR8616865_1.fastq.gz
hic2=~/data/OrgOne/sumatran_tiger/HiC/SRR8616865_2.fastq.gz

###########################################################
# install the latest version of BWA for aligning hic reads to the assembly
#conda create -n bwa bwa=0.7.19 -y
#conda install samtools
#conda install picard
conda activate bwa

## index the assembly fasta file
#bwa index $assembly

## align the hic reads to the assembly and convert to BAM
#bwa mem -t 32 -S -P -5 $assembly $hic1 $hic2 |
#	samtools view -@ 32 -b -q 30 - > $(basename ${assembly%.*})_hic_mapped.bam

## sort and index the bam
#samtools sort --write-index $(basename ${assembly%.*})_hic_mapped.bam -o $(basename ${assembly%.*})_hic_mapped_sorted.bam

# mark pcr duplicates in the bam with picard
picard MarkDuplicates \
	-I $(basename ${assembly%.*})_hic_mapped_sorted.bam \
	-O $(basename ${assembly%.*})_hic_mapped_sorted_dupmk.bam \
	-M $(basename ${assembly%.*})_picard_dup_metrics.txt \
	--CREATE_INDEX=true


conda deactivate


###########################################################
# install the YAHS scaffolding tool
#conda create --name yahs yahs -y
conda activate yahs

# index the assembly with samtools
samtools faidx $assembly

# scaffold with hic data
yahs \
	-o $wkdir/HiC/$(basename ${assembly%.*})_yahs \
	$assembly \
	$(basename ${assembly%.*})_hic_mapped_sorted_dupmk.bam



# deactivate software
conda deactivate

