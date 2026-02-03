#!/bin/bash
# Laura Dean
# 3/2/26
# script written for running on the UoN HPC Ada

# script to merge symbiont genomes into a single fasta file
# and then filter raw ONT reads based on mapping
# to symbiotic algae so they can be separated from reads that
# are (hopefully) coral. There will need to be another step to
# filter for prokaryotes but I'll do that separately so that Bryan
# can look at the symbiont reads as standalone if he wants.

# tried with BBmap but got OOM then read bbsplit is designed for
# this so now trying this. Seems to work ok

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
reads=/share/deepseq/laura/ctenella/Ctenella_sup.fastq.gz
reads_out=/gpfs01/home/mbzlld/data/ctenella/new_flowcell_calls/Ctenella_sup.fastq.gz

# setup env
cd $wkdir
source $HOME/.bash_profile


# hashing out this block because it already ran once successfully
# ### merge symbiont genomes into a single fasta
# cat $wkdir/symbionts/*_genomic.fna.gz > $wkdir/symbionts/all_symbionts.fasta.gz


### convert reads to fasta format so they can be broken into smaller chunks (for the program to run)
conda activate seqtk
seqtk seq -a $reads | gzip > ${reads_out%.*.*}.fasta.gz
conda deactivate



### map the reads to the combined symbiont fasta
# (retain only the reads that don't map going forward for coral assembly
conda activate bbmap
bbsplit.sh \
-Xmx170G \
fastareadlen=600 \
minid=0.98 \
ref=$wkdir/symbionts/all_symbionts.fasta.gz \
in=${reads_out%.*.*}.fasta.gz \
basename=new_reads_mapping_to_%.fastq
conda deactivate


# extract the fastq header lines (without the @)
awk 'NR % 4 == 1 {sub(/^@/, ""); print}' $wkdir/new_reads_mapping_to_all_symbionts.fastq > $wkdir/symbionts/new_symbiont_read_ids.txt
# remove everything after the first space on every line to retain only the read ids
sed -i "s/ .*//" $wkdir/symbionts/new_symbiont_read_ids.txt
# remove the now duplicate lines where the same read id is identified more than once
awk '!seen[$0]++' $wkdir/symbionts/new_symbiont_read_ids.txt > $wkdir/temporary && mv $wkdir/temporary $wkdir/symbionts/new_symbiont_read_ids.txt

# filter the reads to remove these contaminants
conda activate seqkit
seqkit grep --threads 24 -v -f $wkdir/symbionts/new_symbiont_read_ids.txt $reads | gzip > ${reads_out%.*.*}_no_symbionts.fastq.gz
conda deactivate

## # keep the contaminanat reads in another file bc they are cool on their own
## conda activate seqkit
## seqkit grep --threads 24 -f $wkdir/symbionts/new_symbiont_read_ids.txt $reads | gzip > $wkdir/symbionts/SUP_calls_mapped_to_symbionts.fastq.gz
## conda deactivate





