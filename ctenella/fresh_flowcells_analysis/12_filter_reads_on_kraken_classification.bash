#!/bin/bash
# 6/2/26
# Laura Dean
# I ran this on UoN HPC

# record of code used to extract reads classified as certain taxonomic groups

# set up env

srun --partition defq --cpus-per-task 2 --mem 20g --time 10:00:00 --pty bash
conda activate kraken2

# TaxID for Montipora (the right family of coral) = 46703

# filter the classified reads to keep only those from the Montipora family
python /share/deepseq/laura/ctenella/extract_kraken_reads.py \
-s /share/deepseq/matt/Ctenella/Ctenella_sup_classified.fastq.gz \
-o /share/deepseq/laura/ctenella/Ctenella_sup_Montipora.fastq \
--taxid 46703 \
--fastq-output \
--include-children \
-k /share/deepseq/matt/Ctenella/read.k2_out \
--report /share/deepseq/matt/Ctenella/reads.report

# TaxID for Scleratinia (zooming a bit further out taxonomically) = 6125

# filter the classified reads to keep only those from the Scleratinia family
python /share/deepseq/laura/ctenella/extract_kraken_reads.py \
-s /share/deepseq/matt/Ctenella/Ctenella_sup_classified.fastq.gz \
-o /share/deepseq/laura/ctenella/Ctenella_sup_Scleratinia.fastq \
--taxid 6125 \
--fastq-output \
--include-children \
-k /share/deepseq/matt/Ctenella/read.k2_out \
--report /share/deepseq/matt/Ctenella/reads.report


  
