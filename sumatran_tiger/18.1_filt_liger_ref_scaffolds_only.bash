#!/bin/bash
# Laura Dean
# 1/4/25
# for running on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=3:00:00
#SBATCH --job-name=filt_lig_ref
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# make the file of headers to keep (from within the liger dir)
#zgrep "scaffold" GCA_018350195.2.fasta.gz > GCA_018350195.2_scaff_only_list.txt

fasta=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2.fasta.gz
headers=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_scaff_only_list.txt
output=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_scaff_only.fasta.gz

source $HOME/.bash_profile
#conda activate seqtk
#
#seqtk subseq $fasta $headers | gzip > $output
#
#conda deactivate
#
## rename the fasta headers to something sensible for viewing
## (so that the names of the chrs are visible in the dotplot)
#zcat $output | sed "s/^.*scaffold_/>/;s/, whole genome shotgun sequence.//" | gzip > ${output%.*.*}_names.fasta.gz


conda activate seqkit

# split the scaffolds into contigs (splitting at every occurence of N)
zcat ${output%.*.*}_names.fasta.gz |
	seqkit fx2tab |
	cut -f 2 |
	sed -r 's/n+/\n/gi' |
	cat -n |
	seqkit tab2fx |
	seqkit replace -p "(.+)" -r "Contig{nr}" |
	gzip > ${output%.*.*}_names_split_contigs.fasta.gz


conda deactivate


