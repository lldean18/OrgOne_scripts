#!/bin/bash
# 30/3/26

# code to merge the final assembly with mitogenome for mapping and pop gen analysis

# this one was prior to polishing
cat /gpfs01/home/mbzlld/data/ctenella/mitogenome/flye_mito_asm_2/assembly.fasta /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb.fasta > /gpfs01/home/mbzlld/data/ctenella/ctenella_chagius_asm_unpolished.fasta

conda activate samtools1.22
samtools faidx /gpfs01/home/mbzlld/data/ctenella/ctenella_chagius_asm_unpolished.fasta
conda deactivate

# this one is after polishing both asms
cat /gpfs01/home/mbzlld/data/ctenella/mitogenome/flye_mito_asm_2/assembly_polished_final.fasta /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb_polished_1.fasta > /gpfs01/home/mbzlld/data/ctenella/ctenella_chagius_asm.fasta

conda activate samtools1.22
samtools faidx /gpfs01/home/mbzlld/data/ctenella/ctenella_chagius_asm.fasta
conda deactivate


