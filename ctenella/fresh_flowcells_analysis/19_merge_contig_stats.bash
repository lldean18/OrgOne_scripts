#!/bin/bash
# Laura Dean
# 24/2/26

# script to merge contig stats into a single file for plotting

cd /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4

# clean up and sort the 3 files of data
# coverage
awk '{print $1, $2}' ONTasm.bp.p_ctg_mapped_raw_reads_Scleractinia_depth.txt | sort -k1,1 > cov.txt
# length (extract taxid)
awk '{split($2,a,"|"); print $1, a[2], $3}' ONTasm.bp.p_ctg_Scleractinia.fasta_length.tsv | sort -k1,1 > len.txt
# GC (extract taxid)
awk '{split($2,a,"|"); print $1, a[2], $3}' ONTasm.bp.p_ctg_Scleractinia.fasta_GC.tsv | sort -k1,1 > gc.txt


# join the 3 separate datasets
join cov.txt len.txt > tmp.txt
join tmp.txt gc.txt > merged.txt

# add column headings and remove the duplicate taxid column
awk 'BEGIN{print "contig\tcoverage\ttaxid\tlength\tGC"}
     {print $1, $2, $3, $4, $6}' OFS="\t" merged.txt > final_table.tsv


rm cov.txt len.txt gc.txt tmp.txt merged.txt


