#!/bin/bash
# 6/2/26
# Laura Dean
# script written for running on the UoN HPC Ada

# script to annotate a genome using liftoff from another assembly

#SBATCH --job-name=liftoff_annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=50g
#SBATCH --time=1:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out




source $HOME/.bash_profile
cd /share/deepseq/laura/ctenella


##  # download the genome and annotation for the hammer coral
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/042/850/425/GCA_042850425.1_Fanc_1.0/GCA_042850425.1_Fanc_1.0_genomic.fna.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/042/850/425/GCA_042850425.1_Fanc_1.0/GCA_042850425.1_Fanc_1.0_genomic.gff.gz

# gunzip GCA_042850425.1_Fanc_1.0_genomic.fna.gz
# gunzip GCA_042850425.1_Fanc_1.0_genomic.gff.gz

reference_assembly=GCA_042850425.1_Fanc_1.0_genomic.fna
reference_gff=GCA_042850425.1_Fanc_1.0_genomic.gff
target_assembly=hifiasm_asm4/ONTasm.bp.p_ctg_100kb.fasta


# annotate assembly by lifting over genes from the closely related source assembly
conda activate liftoff
liftoff \
	-g $reference_gff \
	-o ${target_assembly%.*}_liftoff.gff \
	-p 32 \
	$target_assembly $reference_assembly
conda deactivate



# Count the number of genes successfully transferred to the new assembly
echo "The number of genes that were successfully transferred to the new assembly was:"
cut -f3 ${target_assembly%.*}_liftoff.gff | grep "gene" | wc -l

# load software
conda activate gffread

# convert the gff file to bed format for input to genespace
# this command seems to retain only the genes anyway so no need for further filtering
gffread \
${target_assembly%.*}_liftoff.gff \
--bed \
-o ${target_assembly%.*}_liftoff_genes.bed


# generate protein fasta file as this is also required as input to genespace
# -S flag uses * instead of . for stop codon translation
gffread \
${target_assembly%.*}_liftoff.gff \
-S \
-g $target_assembly \
-y ${target_assembly%.*}_proteins.fasta

# unload software
conda deactivate





