#!/bin/bash
# 13/5/26

# script to assemble the snake neck turtle mitogenome

#SBATCH --job-name=map_reads_to_proteins
#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=160:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# the most closely related published mitogenome is Chelodina longicollis
# here is the NCBI page for it: https://www.ncbi.nlm.nih.gov/nuccore/KJ713173
# I saved the protein sequences as a fasta file (13 proteins)
# then I will use these sequences to id reads from my sequence data that code for these proteins


# setup env
source $HOME/.bash_profile
conda activate miniprot
cd /share/deepseq/org_one/SNT052/mitogenome 


# set variables
reads=../SUP_basecalls/turtle_SUP.fastq.gz
proteins=Chelodina_longicollis_mito_proteins.fasta


# convert reads from fastq to fasta format
conda activate seqkit
seqkit fq2fa $reads > ${reads%.*.*}.fasta
conda deactivate


# identify reads that code for mitochondrial proteins
conda activate miniprot
miniprot \
-t 96 \
-S \
${reads%.*.*}.fasta $proteins > output.paf
conda deactivate

# list the read names that contain a mitochondrial protein sequence
less output.paf | cut -f 6 | sort | uniq > mito_reads_miniprot.list

# remove paf file
rm output.paf

# filter the full fastq file to keep only the reads we want
conda activate seqtk
seqtk subseq $reads mito_reads_miniprot.list | gzip > mito_reads_miniprot.fastq.gz
conda deactivate


