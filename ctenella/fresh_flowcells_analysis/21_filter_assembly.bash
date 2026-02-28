#!/bin/bash
# Laura Dean
# 27/2/26

# script to filter the assembly to remove contigs that we arent sure are coral

#SBATCH --job-name=filter_asm
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
cd /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4
source $HOME/.bash_profile
conda activate seqkit

asm=ONTasm.bp.p_ctg_Scleractinia.fasta


########### FILTER GC
# Make a list of contig IDs with GC content between 38 and 41
awk -F'\t' '$2 >= 38 && $2 <= 41' ONTasm.bp.p_ctg_Scleractinia.fasta_GC.tsv > Contig_IDs_38-41GC.tsv
sed -i 's/\t.*//' Contig_IDs_38-41GC.tsv

# filter the reads to contain only those in the list of read IDs
seqkit grep \
-n \
-f Contig_IDs_38-41GC.tsv \
$asm > ${asm%.*}_38-41GC.fasta


############ FILTER DEPTH
# make a list of contig coverage depth between 180 and 300 X
awk -F' ' '$2 >= 180 && $2 <= 300' ONTasm.bp.p_ctg_mapped_raw_reads_Scleractinia_depth.txt > Contig_IDs_180-300X.txt
sed -i 's/ .*//' Contig_IDs_180-300X.txt

# filter the reads to contain only those in the list of read IDs
seqkit grep \
-f Contig_IDs_180-300X.txt \
${asm%.*}_38-41GC.fasta > ${asm%.*}_38-41GC_180-300X.fasta


############ FILTER CONTIG LENGTH
seqtk seq \
-L 100000 ${asm%.*}_38-41GC_180-300X.fasta > ${asm%.*}_38-41GC_180-300X_100kb.fasta


######### EXTRACT FINAL CONTIG NAMES FOR R FILTERING
grep "^>" ${asm%.*}_38-41GC_180-300X_100kb.fasta | sed 's/^>//' > ${asm%.*}_38-41GC_180-300X_100kb_contig_names.txt


conda deactivate

