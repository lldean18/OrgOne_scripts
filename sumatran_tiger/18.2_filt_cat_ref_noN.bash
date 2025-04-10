#!/bin/bash
# Laura Dean
# 8/4/25
# for running on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=3:00:00
#SBATCH --job-name=filt_cat_ref
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome.fa

source $HOME/.bash_profile
conda activate seqkit

# split the scaffolds into contigs (splitting at every occurence of N)
cat $assembly |
	seqkit fx2tab |
	cut -f 2 |
	sed -r 's/n+/\n/gi' |
	cat -n |
	seqkit tab2fx |
	seqkit replace -p "(.+)" -r "Contig{nr}" > ${assembly%.*}_split_contigs.fa


conda deactivate


