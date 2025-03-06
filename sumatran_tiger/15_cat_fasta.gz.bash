#!/bin/bash
# Laura Dean
# 20/5/24
# for running on Ada

# spin up a HPC node
srun --partition defq --cpus-per-task 1 --mem 20g --time 04:00:00 --pty bash

# merge the 2 fa.gz files
cat /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_simplex_simplex_herro_corrected.fa.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_duplex.fa.gz > duplex_and_herro_simplex.fa.gz

# cat command only took a few mins to concatenate 117GB

# check for duplicate headers
zgrep ">" /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/duplex_and_herro_simplex.fa.gz | sort | uniq -c

zgrep ">" /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/duplex_and_herro_simplex.fa.gz | sort | uniq -d

# There do not seem to be any duplicate headers

# try combining just a portion of the two files to see if it is the file size causing the issue

cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls
zcat all_simplex_simplex_herro_corrected.fa.gz | head -n 100 > SMALL_duplex_and_herro_simplex.fa.gz
zcat all_duplex.fa.gz | head -n 100 >> SMALL_duplex_and_herro_simplex.fa.gz

# the first file is not gzipped!!
mv all_simplex_simplex_herro_corrected.fa.gz all_simplex_simplex_herro_corrected.fa
gzip all_simplex_simplex_herro_corrected.fa.gz

# then try concatenating them again
# this time the final file was only 39Gb not 117!! 

