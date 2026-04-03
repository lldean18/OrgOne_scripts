#!/bin/bash
# Laura Dean
# 3/4/26

# script to calculate depth of coverage from BAM files

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=4g
#SBATCH --time=5:00:00
#SBATCH --array=1-12
#SBATCH --job-name=coverage_calcs
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# move to working dir
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/bams

# set the config file (script 000_make_fastq_array_config_file.bash gives instructions on making the config)
CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)


# load software
source $HOME/.bash_profile
conda activate samtools1.22


############################################
# CALCULATE COVERAGE DEPTH FOR EACH SAMPLE #
############################################

# calculate depth for all bams
samtools depth \
-a \
-J \
-H \
map_sort_barcode${ind}_filtered_named.bam |
awk -F '\t' '(NR==1) {split($0,header);N=0.0;next;} {N++;for(i=3;i<=NF;i++) a[i]+=int($i);} END { for(x in a) print header[x], a[x]/N;}' > mapping_info/barcode${ind}_mapping_cov_depth.txt

# unload software
conda deactivate

