#!/bin/bash
# Laura Dean
# 15/3/24

#SBATCH --partition=ampereq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --gres=gpu:1
#SBATCH --mem=256g
#SBATCH --time=24:00:00
#SBATCH --job-name=black_lemur_basecall
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-2

# set variables
species=black_and_white_ruffed_lemur
wkdir=/share/StickleAss/OrgOne/$species # set the working directory
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/${species}_basecall_array_config.txt # set the name of the config file

# ##### GENERATE THE ARRAY CONFIG FILE #####
# # generate list of file paths for the array config
# cd $wkdir/pod5_files
# # list all directories containing pod5 files & write to config file
# find . -type f -name '*pod5*' | sed -r 's|/[^/]+$||' |sort -u > ${config%.*}_tmp.txt
# # add the start of the filepath to the config file (bc we cd'd to pod5_files directory, it only prints from there)
# sed -i "s/[.]/\/share\/StickleAss\/OrgOne\/$species\/pod5_files/" ${config%.*}_tmp.txt
# # add array numbers to config file
# awk '{print NR,$0}' ${config%.*}_tmp.txt > $config
# rm ${config%.*}_tmp.txt # remove the temp file


# load cuda module
module load cuda-12.2.2

# extract the fast5 directory paths from the config file
pod5_path=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)

# get the name of just the directory the pod5 files are in 
#name=${pod5_path##*/} # this works but the output directories wouldn't have been unique
#out_path=$(echo $pod5_path | cut -f10,11,12 -d '/') # so took the last 3 fields as the name instead (for files in my home directory)
out_path=$(echo $pod5_path | cut -f7,8,9 -d '/') # so took the last 3 fields as the name instead (for files in /share/StickleAss)

# then make a directory with this path (only if one does not already exist with the same name)
mkdir -p $wkdir/basecalls/$out_path

# basecall the simplex reads
dorado basecaller \
sup@latest,5mCG_5hmCG \
$pod5_path/ > $wkdir/basecalls/$out_path/SUPlatest_calls.bam

# sup@latest \
# --recursive \
# --verbose \

