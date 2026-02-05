#!/bin/bash
# Laura Dean
# 2/2/26

# Script to create the metamaps database for searching ctenella reads for symbiont DNA
# coundn't download on Ada SO did on balrog

# set up env and software
ssh balrog
tmux new -t metamaps
#conda create --name metamaps bioconda::metamaps -y
conda activate metamaps
cd /data/laura

# download the genomes you want to include
mkdir -p download
downloadRefSeq.pl \
--seqencesOutDirectory download/refseq \
--taxonomyOutDirectory download/taxonomy \
--targetBranches archaea,bacteria,fungi

##  # ensure contig ids are annotated correctly
##  perl /gpfs01/home/mbzlld/software_bin/miniconda3/envs/metamaps/bin/annotateRefSeqSequencesWithUniqueTaxonIDs.pl \
##  --refSeqDirectory download/refseq \
##  --taxonomyInDirectory download/taxonomy \
##  --taxonomyOutDirectory download/taxonomy_uniqueIDs
##  
##  # construct the metamaps database
##  mkdir databases
##  perl /gpfs01/home/mbzlld/software_bin/miniconda3/envs/metamaps/bin/buildDB.pl \
##  --DB databases/myDB \
##  --FASTAs download/refseq,hg38.primary.fna.with9606 \
##  --taxonomy download/taxonomy_uniqueIDs



