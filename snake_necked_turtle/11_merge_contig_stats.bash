#!/bin/bash
# Laura Dean
# 24/2/26

# script to merge contig stats into a single file for plotting

cd /share/deepseq/org_one/SNT052/assembly_QC

# clean up and sort the 3 files of data
# coverage
awk '{print $1, $2}' turtle.bp.p_ctg_mapped_reads_depth.txt | sort -k1,1 > cov.txt

# join the 3 separate datasets
join cov.txt turtle.bp.p_ctg.fasta_length.tsv > tmp.txt
join tmp.txt turtle.bp.p_ctg.fasta_GC.tsv > merged.txt

# add column headings and remove the duplicate taxid column
awk 'BEGIN{print "contig\tcoverage\tlength\tGC"}
     {print $1, $2, $3, $4}' OFS="\t" merged.txt > contig_stats_turtle.tsv


rm cov.txt tmp.txt merged.txt
