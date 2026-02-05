#!/bin/bash
# Laura Dean
# 4/2/26

# Script to calculate GC content of raw reads
# We will then use this info to filter the reads prior to assembly

#SBATCH --job-name=calculate_GC
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=10g
#SBATCH --time=8:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# setup env
reads=/share/deepseq/laura/ctenella/Ctenella_sup.fastq.gz
output_dir=/gpfs01/home/mbzlld/data/ctenella/new_flowcell_calls

source $HOME/.bash_profile
conda activate seqkit


## # calculate GC content of reads
## seqkit fx2tab --threads 16 --gc --name $reads > $output_dir/Ctenella_sup_read_GC.tsv
## 
## # Make a list of read IDs with GC content between 36 and 42
## awk -F'\t' '$2 >= 36 && $2 <= 42' $output_dir/Ctenella_sup_read_GC.tsv > $output_dir/Ctenella_readIDs_36-42GC.tsv
## sed -i 's/\t.*//' $output_dir/Ctenella_readIDs_36-42GC.tsv

# filter the reads to contain only those in the list of read IDs
seqkit grep \
-f $output_dir/Ctenella_readIDs_36-42GC.tsv \
$reads | gzip > $output_dir/Ctenella_sup_36-42GC.fastq.gz





conda deactivate





