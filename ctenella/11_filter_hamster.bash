#!/bin/bash
# Laura Dean
# 15/12/25
# script written for running on the UoN HPC Ada


# script to map reads to chinese hamster to ensure no contamination happened from reusing the flowcell


#SBATCH --job-name=filter_hamster
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=200g
#SBATCH --time=80:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set variables
wkdir=/gpfs01/home/mbzlld/data/ctenella/hamster
reads=/gpfs01/home/mbzlld/data/ctenella/SUP_calls.fastq.gz

# setup env
cd $wkdir
source $HOME/.bash_profile


### map the reads to the hamster fasta
# (retain only the reads that don't map going forward for coral assembly
conda activate bbmap
bbsplit.sh \
-Xmx170G \
fastareadlen=600 \
minid=0.98 \
ref=$wkdir/GCF_003668045.3_CriGri-PICRH-1.0_genomic.fna.gz \
in=${reads%.*.*}.fasta.gz \
basename=reads_mapping_to_%.fastq
conda deactivate


# extract the fastq header lines (without the @)
awk 'NR % 4 == 1 {sub(/^@/, ""); print}' $wkdir/reads_mapping_to_GCF_003668045.3_CriGri-PICRH-1.0_genomic.fastq > $wkdir/hamster_read_ids.txt
# remove everything after the first space on every line to retain only the read ids
sed -i "s/ .*//" $wkdir/hamster_read_ids.txt
# remove the now duplicate lines where the same read id is identified more than once
awk '!seen[$0]++' $wkdir/hamster_read_ids.txt > $wkdir/temporary && mv $wkdir/temporary $wkdir/hamster_read_ids.txt



# filter the reads to remove these contaminants
conda activate seqkit
seqkit grep --threads 24 -v -f $wkdir/hamster_read_ids.txt $reads | gzip > $wkdir/SUP_calls_no_hamster.fastq.gz
conda deactivate



# keep the contaminanat reads in another file
conda activate seqkit
seqkit grep --threads 24 -f $wkdir/hamster_read_ids.txt $reads | gzip > $wkdir/SUP_calls_mapped_to_hamster.fastq.gz
conda deactivate

# convert fastq to fasta
conda activate seqkit
seqkit fq2fa $wkdir/SUP_calls_mapped_to_hamster.fastq.gz -o $wkdir/SUP_calls_mapped_to_hamster.fasta.gz
conda deactivate





