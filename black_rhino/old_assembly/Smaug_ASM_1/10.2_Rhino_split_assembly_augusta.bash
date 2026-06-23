#!/bin/bash
# Laura Dean
# 19/2/24

# this took less than a minute to run on Augusta in the login node so no need to submit as a job

# load your bash profile for using conda
source $HOME/.bash_profile

# create your environment
#conda create --name pyfasta

# activate the conda environment containing your software
conda activate pyfasta

# install pyfasta to split the reference genome so that the job can be parallelised
#conda install -c conda-forge -c bioconda python=3.9 pyfasta -y

# set variables
assembly=/gpfs01/home/mbzlld/data/OrgOne/black_rhino/assembly/assembly.fasta

# the original fasta was not removed so no need to make future backups
# first make a back up of your assembly
#cp $assembly ${assembly%.*}_backup.fa

# then split into 10 pieces...
pyfasta split -n 10 $assembly

conda deactivate

