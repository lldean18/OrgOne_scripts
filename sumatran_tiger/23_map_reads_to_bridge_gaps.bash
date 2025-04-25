#!/bin/bash
# Laura Dean
# 25/4/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=map_reads_to_ref
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=34
#SBATCH --mem=200g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# activate software
source $HOME/.bash_profile
conda activate minimap2


#reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/simplex_simplex_and_duplex.fastq.gz
#reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_simplex_simplex.fastq.gz
reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_duplex.fastq.gz
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta

suffix=duplex

## map the raw reads back to our assembly
#minimap2 \
#	-a \
#	-x map-ont \
#	--split-prefix temp_prefix \
#	-t 32 \
#	-o ${assembly%.*}_$suffix.sam \
#	$assembly $reads
#
#
## sort and index the sam file and convert to bam format
#samtools sort \
#	--threads 32 \
#	--write-index \
#	--output-fmt BAM \
#	-o ${assembly%.*}_$suffix.bam ${assembly%.*}_$suffix.sam
#
#
## remove the intermediate sam file
#rm ${assembly%.*}_$suffix.sam


# calculate and plot stats about the mapping
samtools stats ${assembly%.*}_$suffix.bam > ${assembly%.*}_$suffix.bam.stats
plot-bamstats -p ${assembly%.*}_$suffix.bam.plots ${assembly%.*}_$suffix.bam.stats


# deactivate software
conda deactivate



