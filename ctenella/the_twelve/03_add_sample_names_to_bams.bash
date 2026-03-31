#!/bin/bash
# 31/3/26

# script to add sample names to bam headers as they are missing


#SBATCH --job-name=add_sample_names
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=4:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12

# set up env
source $HOME/.bash_profile
conda activate samtools1.22
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/bams

CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
echo "slurm array = $SLURM_ARRAY_TASK_ID adding sample ID to bam for sample $ind"


# add sample name to header line
sample=barcode$ind
samtools addreplacerg \
    -r "@RG\tID:${sample}\tSM:${sample}" \
    -o map_sort_barcode${ind}_filtered_named.bam \
    map_sort_barcode${ind}_filtered.bam

# index new bams
samtools index map_sort_barcode${ind}_filtered_named.bam

# remove the bams without sample names
rm map_sort_barcode${ind}_filtered.bam*

conda deactivate

