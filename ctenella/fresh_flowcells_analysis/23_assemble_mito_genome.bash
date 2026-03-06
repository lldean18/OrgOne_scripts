#!/bin/bash
# Laura Dean
# 4/3/26

# script to assemble the mitochondrial genome for ctenella

#SBATCH --job-name=map_reads_to_mitogenome
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=34
#SBATCH --mem=60g
#SBATCH --time=60:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# the most closely related coral species with a good published mitogenome is Platygyra daedalea
# it was so short I just copied it into a fasta file from this page: https://www.ncbi.nlm.nih.gov/nuccore/PQ763181.1?report=fasta
# I saved it here /gpfs01/home/mbzlld/data/ctenella/mitogenome/Platygra_daedalea_mitogenome.fa

# Then map the raw reads to this mitogenome
source $HOME/.bash_profile
conda activate minimap2
cd /gpfs01/home/mbzlld/data/ctenella/mitogenome

ref=Platygra_daedalea_mitogenome.fa
reads=/share/deepseq/laura/ctenella/Ctenella_sup.fastq.gz

# map reads to mitogenome
minimap2 \
	-a \
	-x map-ont \
	--split-prefix temp_prefix \
	-t 32 \
	-o mitogenome_mapped_reads.sam \
	$ref $reads


# sort and index the sam file and convert to bam format
samtools sort \
	--threads 32 \
	--write-index \
	--output-fmt BAM \
	-o mitogenome_mapped_reads.bam mitogenome_mapped_reads.sam


# remove the intermediate sam file
rm mitogenome_mapped_reads.sam


# filter the bam to remove unmapped read and secondary / supplementary alignments
samtools view \
--threads 30 \
-b \
-q 20 \
-F 2308 \
mitogenome_mapped_reads.bam > mito_reads.bam

# count how many reads there were in the first bam file
# there were 53678735 reads
samtools view \
--threads 30 \
-c mitogenome_mapped_reads.bam
# then count how many we kept
# we kept 90130 reads
samtools view \
--threads 30 \
-c mito_reads.bam


# convert the mitochondrial reads back to fastq format
samtools fastq --threads 30  mito_reads.bam | gzip > mito_reads.fastq.gz

conda deactivate

