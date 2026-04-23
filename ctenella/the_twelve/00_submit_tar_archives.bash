#!/bin/bash
# 16/4/26

# script to submit the Ctenella 12 pod5 tarballs

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50g
#SBATCH --time=100:00:00
#SBATCH --job-name=ENA_submission
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12

# setup config
CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
echo "slurm array = $SLURM_ARRAY_TASK_ID uploading the tar archive for barcode$ind"

# make ENA submission
curl --upload-file /share/deepseq/laura/ctenella/ctenella_chagius_pod5s_barcode${ind}.tar.gz --user Webin-154:******** ftp://webin2.ebi.ac.uk


