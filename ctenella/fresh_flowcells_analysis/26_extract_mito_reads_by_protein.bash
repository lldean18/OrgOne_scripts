#!/bin/bash
# Laura Dean
# 9/3/26

# script to assemble the mitochondrial genome for ctenella

#SBATCH --job-name=map_reads_to_proteins
#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=160:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# the most closely related coral species with a good published mitogenome is Galaxea fascircularis 
# Here is the NCBI page for it: https://www.ncbi.nlm.nih.gov/nuccore/PP526287.1
# I saved the protein sequences to the file Galaxea_fascircularis_proteins.fa
# to use to extract reads that code for these proteins

# set up for software
source $HOME/.bash_profile

# move to working directory
cd /gpfs01/home/mbzlld/data/ctenella/mitogenome

# set variables
reads=/share/deepseq/laura/ctenella/Ctenella_sup.fastq.gz
proteins=Galaxea_fascircularis_proteins.fa


###  # convert reads from fastq to fasta format
###  conda activate seqkit
###  seqkit fq2fa $reads > ${reads%.*.*}.fasta
###  conda deactivate


# identify reads that code for mitochondrial proteins
conda activate miniprot
miniprot \
-t 96 \
-S \
${reads%.*.*}.fasta $proteins > output.paf
conda deactivate

# list the read names that contain a mitochondrial protein sequence
less output.paf | cut -f 6 | sort | uniq > mito_reads_miniprot.list


# filter the full fastq file to keep only the reads we want
conda activate seqtk
seqtk subseq $reads mito_reads_miniprot.list | gzip > mito_reads_miniprot.fastq.gz
conda deactivate

