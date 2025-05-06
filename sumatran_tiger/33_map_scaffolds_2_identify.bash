#!/bin/bash
# Laura Dean
# 2/5/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=map_sacffs_to_ref
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=34
#SBATCH --mem=50g
#SBATCH --time=6:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# activate software
source $HOME/.bash_profile
conda activate minimap2

scaffs=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC2/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag/1Mbplus_scaffolds.fasta
#reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome.fa
reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC2/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag/ragtag.scaffold_3Mb.fasta

# map the raw reads back to our assembly
minimap2 \
	-a \
	-x map-ont \
	--split-prefix temp_prefix \
	-t 32 \
	-o ${scaffs%.*}_mapped_self_chrs.sam \
	$reference $scaffs


# sort and index the sam file and convert to bam format
samtools sort \
	--threads 32 \
	--write-index \
	--output-fmt BAM \
	-o ${scaffs%.*}_mapped_self_chrs.bam ${scaffs%.*}_mapped_self_chrs.sam


# remove the intermediate sam file
rm ${scaffs%.*}_mapped_self_chrs.sam


# calculate and plot stats about the mapping
#samtools stats ${scaffs%.*}_mapped_self_chrs.bam > ${scaffs%.*}_mapped_self_chrs.bam.stats
#plot-bamstats -p ${scaffs%.*}_mapped_self_chrs.bam.stats.plots ${scaffs%.*}_mapped_self_chrs.bam.stats
samtools flagstat ${scaffs%.*}_mapped_self_chrs.bam


# filter for primary mappings only
samtools view \
	--bam \
	-F 0x800 -F 0x100 \
	-o ${scaffs%.*}_mapped_self_chrs_primary.bam ${scaffs%.*}_mapped_self_chrs.bam

# index the primary mappings bam file
samtools index ${scaffs%.*}_mapped_self_chrs_primary.bam

# extract coordinates of where the scaffolds are mapping to
samtools view -F 4 ${scaffs%.*}_mapped_self_chrs_primary.bam | awk '{print $3"\t"$4}'

# deactivate software
conda deactivate



