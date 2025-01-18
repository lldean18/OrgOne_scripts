#!/bin/bash
# Laura Dean
# 17/1/25
# for running on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1g
#SBATCH --time=3:00:00
#SBATCH --job-name=filt_lig_ref
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

fasta=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2.fasta.gz
headers=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chr_only_list.txt
output=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only.fasta.gz

source $HOME/.bash_profile
conda activate seqtk

seqtk subseq $fasta $headers | gzip > $output

conda deactivate

conda activate seqkit

seqkit rmdup -s $output > ${output%.*.*}_uniq.fasta.gz

conda deactivate

# rename the chromosomes in the fasta file to remove everything but the actual chromosome number
# (so that the names of the chrs are visible in the dotplot)
sed "s/^.*chromosome/>/;s/, whole genome shotgun sequence.//" ${output%.*.*}_uniq.fasta.gz > ${output%.*.*}_uniq.fasta_names.gz

