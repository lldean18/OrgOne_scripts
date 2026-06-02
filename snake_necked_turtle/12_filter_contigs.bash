#!/bin/bash
# Laura Dean
# 2/6/26

# script to filter the assembly to remove contigs that don't look great

#SBATCH --job-name=filter_asm
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
cd /share/deepseq/org_one/SNT052/dorado_polish
source $HOME/.bash_profile
conda activate seqkit

asm=turtle.bp.p_ctg_polished.fasta


########### FILTER GC
# Make a list of contig IDs with GC content between 36 and 55
awk -F'\t' '$2 >= 36 && $2 <= 55' ../assembly_QC/turtle.bp.p_ctg.fasta_GC.tsv > Contig_IDs_36-55GC.tsv
sed -i 's/\t.*//' Contig_IDs_36-55GC.tsv

# filter the reads to contain only those in the list of read IDs
seqkit grep \
-n \
-f Contig_IDs_36-55GC.tsv \
$asm > ${asm%.*}_36-55GC.fasta


############ FILTER DEPTH
# make a list of contig coverage depth between 10 and 100 X
awk -F' ' '$2 >= 10 && $2 <= 100' ../assembly_QC/turtle.bp.p_ctg_mapped_reads_depth.txt > Contig_IDs_10-100X.txt
sed -i 's/ .*//' Contig_IDs_10-100X.txt

# filter the reads to contain only those in the list of read IDs
seqkit grep \
-f Contig_IDs_10-100X.txt \
${asm%.*}_36-55GC.fasta > ${asm%.*}_36-55GC_10-100X.fasta


############ FILTER CONTIG LENGTH
seqtk seq \
-L 100000 ${asm%.*}_36-55GC_10-100X.fasta > ${asm%.*}_36-55GC_10-100X_100kb.fasta



conda deactivate

