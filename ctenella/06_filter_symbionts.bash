#!/bin/bash
# Laura Dean
# 5/12/25
# script written for running on the UoN HPC Ada

# script to merge symbiont genomes into a single fasta file
# and then filter raw ONT reads with bbmap to determine reads that map
# to symbiotic bacteria so they can be separated from reads that
# are (hopefully) coral

#SBATCH --job-name=filter_symbionts
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=30g
#SBATCH --time=24:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set variables
wkdir=/gpfs01/home/mbzlld/data/ctenella

# setup env
cd $wkdir
source $HOME/.bash_profile
conda activate bbmap


### merge symbiont genomes into a single fasta
cat $wkdir/symbionts/*_genomic.fna.gz > $wkdir/symbionts/all_symbionts.fasta.gz








