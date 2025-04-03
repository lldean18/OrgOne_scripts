#!/bin/bash
# Laura Dean
# 3/4/25
# for running on the UoN HPC Ada



# Make a dir for the data
mkdir /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC

# download HiC data
cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR861/005/SRR8616865/SRR8616865_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR861/005/SRR8616865/SRR8616865_2.fastq.gz



