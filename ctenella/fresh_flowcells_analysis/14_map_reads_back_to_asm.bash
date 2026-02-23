#!/bin/bash
# Laura Dean
# 23/2/26
# script written for running on the UoN HPC Ada

# script to map raw reads back to our assembly so we can see what the coverage is like

#SBATCH --job-name=map_reads_to_ref
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=34
#SBATCH --mem=50g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# activate software
source $HOME/.bash_profile
conda activate minimap2

reads=/share/deepseq/laura/ctenella/Ctenella_sup.fastq.gz
assembly=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg.fasta

# map the raw reads back to our assembly
minimap2 \
	-a \
	-x map-ont \
	--split-prefix temp_prefix \
	-t 32 \
	-o ${assembly%.*}_mapped_raw_reads.sam \
	$assembly $reads


# sort and index the sam file and convert to bam format
samtools sort \
	--threads 32 \
	--write-index \
	--output-fmt BAM \
	-o ${assembly%.*}_mapped_raw_reads.bam ${assembly%.*}_mapped_raw_reads.sam


# remove the intermediate sam file
rm ${assembly%.*}_mapped_raw_reads.sam

conda deactivate
