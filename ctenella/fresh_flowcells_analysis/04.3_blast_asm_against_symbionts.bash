#!/bin/bash
# Laura Dean
# 3/2/26

# notes on blasting assembly against symbionts
# run on my Mac


#conda create --name blast bioconda::blast
conda activate blast

# make the database
makeblastdb \
-in all_symbionts.fasta \
 -dbtype nucl \
-out symbiontsdb

# blast the asm against the database
blastn \
  -query hifiasm_asm4/ONTasm.bp.p_ctg.fasta \
  -db symbiontsdb \
  -out hifiasm_asm4/assembly_vs_symbionts.blast \
  -outfmt 6 \
  -evalue 1e-10 \
  -num_threads 8


