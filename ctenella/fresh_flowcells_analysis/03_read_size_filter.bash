#!/bin/bash
# Laura Dean
# 2/2/26

# script to filter the raw ctenella reads to try an assembly with only the larger fragments

# setup env
source $HOME/.bash_profile
conda activate seqtk
reads=/share/deepseq/laura/ctenella/Ctenella_sup.fastq.gz


# remove sequences shorter than 3.5kb
seqtk seq -L 3500 $reads > /gpfs01/home/mbzlld/data/ctenella/new_flowcell_calls/Ctenella_sup_3.5kb.fasta


# unload the software
conda deactivate


