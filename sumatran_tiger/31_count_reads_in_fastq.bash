#!/bin/bash

file=all_simplex_simplex.fastq.gz
file=all_duplex.fastq.gz

# count the number of total reads in the file
zcat /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/$file | awk 'END { print NR/4 }'



