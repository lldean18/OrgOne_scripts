#!/bin/bash
# 13/4/26

# script to generate tar archives for the 12 for ENA submission

#SBATCH --job-name=tar_archive
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=4:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12

# set up env
cd /share/deepseq/matt/Ctenella
CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
echo "slurm array = $SLURM_ARRAY_TASK_ID generating pod5 tar archive for sample barcode$ind"

# make tar archive for each barcode for the pod5 files from the twelve
tar -czf /share/deepseq/laura/ctenella/ctenella_chagius_pod5s_barcode${ind}.tar.gz \
  20260325_1426_2G_PBG31226_c8a42015/pod5_pass/barcode${ind} \
  20260325_1426_2G_PBG31226_c8a42015/pod5_fail/barcode${ind} \
  20260323_1207_2G_PBG31226_1c8c2a8d/pod5_pass/barcode${ind} \
  20260323_1207_2G_PBG31226_1c8c2a8d/pod5_fail/barcode${ind}

# generate md5sums
md5sum /share/deepseq/laura/ctenella/ctenella_chagius_pod5s_barcode${ind}.tar.gz > /share/deepseq/laura/ctenella/ctenella_chagius_pod5s_barcode${ind}.md5

