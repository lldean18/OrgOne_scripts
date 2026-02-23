#!/bin/bash
# 6/2/26
# Laura Dean
# I ran this on UoN HPC

# record of code used to extract reads classified as certain taxonomic groups

# set up env

conda activate tmux
tmux attach -t kraken
srun --partition defq --cpus-per-task 2 --mem 30g --time 24:00:00 --pty bash
source $HOME/.bash_profile
conda activate kraken2

# TaxID for Montipora (the right family of coral) = 46703

### SECOND TRY WITH MY CLASSIFIED READS
# This worked so Matt's file of classified reads must have been truncated
# Extract just the Montipora reads
cd /share/deepseq/laura/ctenella/kraken2
python /share/deepseq/laura/ctenella/extract_kraken_reads.py \
-s Ctenella_sup_k2_classified.fastq.gz \
-o Ctenella_sup_k2_Montipora.fastq \
--taxid 46703 \
--fastq-output \
--include-children \
-k k2_log \
--report k2_report
# compress the fastq output
gzip Ctenella_sup_k2_Montipora.fastq

# extract just the Scleractinia reads
cd /share/deepseq/laura/ctenella/kraken2
python /share/deepseq/laura/ctenella/extract_kraken_reads.py \
-s Ctenella_sup_k2_classified.fastq.gz \
-o Ctenella_sup_k2_Scleratinia.fastq \
--taxid 6125 \
--fastq-output \
--include-children \
-k k2_log \
--report k2_report
# compress the fastq output
gzip Ctenella_sup_k2_Scleratinia.fastq


# extract just the reads that are not classified as Scleractinia
cd /share/deepseq/laura/ctenella/kraken2
python /share/deepseq/laura/ctenella/extract_kraken_reads.py \
-s Ctenella_sup_k2_classified.fastq.gz \
-o Ctenella_sup_k2_NOT_Scleratinia.fastq \
--exclude \
--taxid 6125 \
--fastq-output \
--include-children \
-k k2_log \
--report k2_report
# compress the fastq output
gzip Ctenella_sup_k2_NOT_Scleratinia.fastq


#########################################################


# extract just the Scleractinia contigs from the assembly
cd /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4
python /share/deepseq/laura/ctenella/extract_kraken_reads.py \
-s ONTasm.bp.p_ctg_classified.fasta \
-o ONTasm.bp.p_ctg_Scleractinia.fasta \
--taxid 6125 \
--include-children \
-k /gpfs01/home/mbzlld/data/ctenella/kraken2/k2_log \
--report /gpfs01/home/mbzlld/data/ctenella/kraken2/k2_report
# this was so quick for the contigs I probably didn't even need srun



