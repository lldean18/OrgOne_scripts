#!/bin/bash
# 20/4/26

# script to remap the reads from the 12 to the polished reference genome

#SBATCH --job-name=remap_ctenella_12
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=50g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12

# setup env
source $HOME/.bash_profile
conda activate minimap2
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/bams

# setup config
CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
echo "slurm array = $SLURM_ARRAY_TASK_ID remapping reads for sample $ind to the polished reference"


# remap the reads to the polished reference
samtools fastq -@ 24 map_sort_barcode${ind}.bam |
minimap2 \
-y \
-ax map-ont \
-t 24 \
/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb_polished_1.fasta \
- |
samtools sort --threads 24 -o remap_sort_barcode${ind}.bam
samtools index --threads 24 remap_sort_barcode${ind}.bam


conda deactivate


