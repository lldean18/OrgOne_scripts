#!/bin/bash
# Laura Dean
# 5/12/25
# script written for running on the UoN HPC Ada

# script to merge symbiont genomes into a single fasta file
# and then filter raw ONT reads based on mapping
# to symbiotic algae so they can be separated from reads that
# are (hopefully) coral. There will need to be another step to
# filter for prokaryotes but I'll do that separately so that Bryan
# can look at the symbiont reads as standalone if he wants.

# tried with BBmap but got OOM then read bbsplit is designed for
# this so now trying this. If not, maybe we'll try with minimap2

#SBATCH --job-name=filter_symbionts
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=200g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set variables
wkdir=/gpfs01/home/mbzlld/data/ctenella
reads=$wkdir/SUP_calls.fastq.gz

# setup env
cd $wkdir
source $HOME/.bash_profile


# hashing out this block because it already ran once successfully
# ### merge symbiont genomes into a single fasta
# cat $wkdir/symbionts/*_genomic.fna.gz > $wkdir/symbionts/all_symbionts.fasta.gz


# hashing out this block because it already ran once successfully
# ### convert reads to fasta format so they can be broken into smaller chunks (for the program to run)
# conda activate seqtk
# seqtk seq -a $reads | gzip > ${reads%.*.*}.fasta.gz
# conda deactivate



# hashing out this block because it already ran once successfully
# ### map the reads to the combined symbiont fasta
# # (retain only the reads that don't map going forward for coral assembly
# conda activate bbmap
# bbsplit.sh \
# -Xmx170G \
# fastareadlen=600 \
# ref=$wkdir/symbionts/all_symbionts.fasta.gz \
# in=${reads%.*.*}.fasta.gz \
# basename=reads_mapping_to_%.fastq
# conda deactivate


# hashing out this block because it already ran once successfully
# # extract the fastq header lines (without the @)
# awk 'NR % 4 == 1 {sub(/^@/, ""); print}' $wkdir/reads_mapping_to_all_symbionts.fastq > $wkdir/symbionts/symbiont_read_ids.txt
# # remove everything after the first space on every line to retain only the read ids
# sed -i "s/ .*//" $wkdir/symbionts/symbiont_read_ids.txt
# # remove the now duplicate lines where the same read id is identified more than once
# awk '!seen[$0]++' $wkdir/symbionts/symbiont_read_ids.txt > $wkdir/temporary && mv $wkdir/temporary $wkdir/symbionts/symbiont_read_ids.txt

# filter the reads to remove these contaminants
conda activate seqkit
seqkit grep --threads 24 -v -f $wkdir/symbionts/symbiont_read_ids.txt $wkdir/SUP_calls.fastq.gz | gzip > $wkdir/SUP_calls_no_symbionts.fastq.gz
conda deactivate





