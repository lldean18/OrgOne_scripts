#!/bin/bash
# Laura Dean
# 23/4/25
# for running on the UoN HPC Ada

#SBATCH --job-name=hic_scaffold_pretextmap
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=300g
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
#conda activate bwa

## index the assembly fasta file
#bwa index $assembly

## align the hic reads to the assembly and convert to BAM
#bwa mem -t 32 -S -P -5 $assembly $hic1 $hic2 |
#	samtools view -@ 32 -b -q 30 - > $(basename ${assembly%.*})_hic_mapped.bam


#conda deactivate


###########################################################
# install pretextmap
#conda create --name pretextmap pretext-suite
conda activate pretextmap

samtools view -h $(basename ${assembly%.*})_hic_mapped.bam | PretextMap -o $(basename ${assembly%.*})_pretextmap_scaffolds.pretext


conda deactivate




