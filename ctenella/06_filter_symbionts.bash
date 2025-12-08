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
#SBATCH --cpus-per-task=1
#SBATCH --mem=200g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set variables
wkdir=/gpfs01/home/mbzlld/data/ctenella
reads=$wkdir/SUP_calls.fastq.gz

# setup env
cd $wkdir
source $HOME/.bash_profile


### merge symbiont genomes into a single fasta
#cat $wkdir/symbionts/*_genomic.fna.gz > $wkdir/symbionts/all_symbionts.fasta.gz


### convert reads to fasta format so they can be broken into smaller chunks (for the program to run)
conda activate seqtk
seqtk seq -a $reads | gzip > ${reads%.*.*}.fasta.gz
conda deactivate



### map the reads to the combined symbiont fasta
# (retain only the reads that don't map going forward for coral assembly
conda activate bbmap
bbsplit.sh \
-Xmx170G \
fastareadlen=600 \
ref=$wkdir/symbionts/all_symbionts.fasta.gz \
in=${reads%.*.*}.fasta.gz \
basename=out_%.fastq
conda deactivate










## hdist controls the number of substitutions allowed
## k sets the length of sequence that must match
## by default this also looks for the reverse compliment
## mkh = minimum kmer hits required to report the read as matching
#K=25
#HDIST=1
#mkh=5
## map the reads to the symbionts
#bbduk.sh \
#-Xmx170G \
#in=$reads \
#k=$K \
#hdist=$HDIST \
#mkh=$mkh \
#out=$wkdir/$(basename "${reads%.*}")_without_symbionts_k${K}_hdist${HDIST}_mkh${mkh}.fastq \
#outm=$wkdir/$(basename "${fastq%.*}")_with_symbionts_k${K}_hdist${HDIST}_mkh${mkh}.fastq \
#stats=$wkdir/$(basename "${fastq%.*}")_stats_k${K}_hdist${HDIST}_mkh${mkh}.txt \
#ref=$wkdir/symbionts/all_symbionts.fasta.gz
#

# will play with the settings a bit and see what we get


