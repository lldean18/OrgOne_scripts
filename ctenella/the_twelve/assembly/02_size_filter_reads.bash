#!/bin/bash
# 30/3/26

# script to filter the raw ctenella reads to try an assembly with only the larger fragments

# setup env
source $HOME/.bash_profile
conda activate seqtk
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/fastqs


# loop over fastqs and filter reads to >3.5kb or longer
for f in *.fastq.gz; do
    seqtk seq -L 3500 $f | gzip > ${f%.fastq.gz}_3.5kb.fastq.gz
done


# unload the software
conda deactivate

