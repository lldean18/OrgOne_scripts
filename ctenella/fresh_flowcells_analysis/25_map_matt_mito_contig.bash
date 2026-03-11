#!/bin/bash
# Laura Dean
# 9/3/26

# script to map matts mitochondrial two contigs to the closely related mito genome

#SBATCH --job-name=map_matts_reads_to_mitogenome
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=08:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# the most closely related coral species with a good published mitogenome is Platygyra daedalea
# it was so short I just copied it into a fasta file from this page: https://www.ncbi.nlm.nih.gov/nuccore/PQ763181.1?report=fasta
# I saved it here /gpfs01/home/mbzlld/data/ctenella/mitogenome/Platygra_daedalea_mitogenome.fa

# Then map the raw reads to this mitogenome
source $HOME/.bash_profile
conda activate minimap2
cd /gpfs01/home/mbzlld/data/ctenella/mitogenome

ref=Platygra_daedalea_mitogenome.fa
reads=matt_mito_contigs.fasta

# map reads to mitogenome
minimap2 \
	-a \
	-x map-ont \
	--split-prefix temp_prefix \
	-t 1 \
	-o mitogenome_mapped_matt_reads.sam \
	$ref $reads


# sort and index the sam file and convert to bam format
samtools sort \
	--threads 1 \
	--write-index \
	--output-fmt BAM \
	-o mitogenome_mapped_matt_reads.bam mitogenome_mapped_matt_reads.sam


# remove the intermediate sam file
rm mitogenome_mapped_matt_reads.sam



conda deactivate

