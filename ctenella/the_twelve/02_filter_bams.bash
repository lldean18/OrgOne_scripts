#!/bin/bash
# 30/3/26

# script to filter ctenella twelve mapped bams that were written by dorado

#SBATCH --job-name=FilterMappedReads
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12


# setup env
source $HOME/.bash_profile
conda activate samtools1.22
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/bams

# setup config
CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
echo "slurm array = $SLURM_ARRAY_TASK_ID filtering mapped reads for sample $ind"




# filter bams to remove low quality mappings and secondary and supplementary alignments and unmapped reads
samtools view \
--threads 16 \
-b \
-q 20 \
-F 0x904 \
map_sort_barcode${ind}.bam > map_sort_barcode${ind}_filtered.bam
# index the filtered bams
samtools index --threads 16 map_sort_barcode${ind}_filtered.bam


# Generate info about how well the reads mapped
echo "the raw reads were mapped with the following success:" > mapping_info/${ind}_mapping_info.txt
samtools flagstat --threads 16 map_sort_barcode${ind}.bam >> mapping_info/${ind}_mapping_info.txt
echo "the filtered reads were mapped with the following success:" >> mapping_info/${ind}_mapping_info.txt
samtools flagstat --threads 16 map_sort_barcode${ind}_filtered.bam >> mapping_info/${ind}_mapping_info.txt



conda deactivate



