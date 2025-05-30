#!/bin/bash
# Laura Dean
# 18/4/24

#SBATCH --partition=ampereq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --gres=gpu:1
#SBATCH --mem=256g
#SBATCH --time=72:00:00
#SBATCH --job-name=Rlem_dup_basecall
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-6

## location of duplex pod5 files:
#/gpfs01/home/mbzlld/data/OrgOne/$species/pod5_files/$reads

species=red_ruffed_lemur
reads=duplex
underscore=_
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/${species}_${reads}${underscore}basecalling_array_config.txt

# ##### GENERATE THE ARRAY CONFIG FILE #####
# # generate list of file paths for the array config
# cd /gpfs01/home/mbzlld/data/OrgOne/$species/pod5_files/$reads
# # list all directories containing fast5 files & write to config file
# find . -type f -name '*pod5*' | sed -r 's|/[^/]+$||' |sort -u > ${config%.*}_tmp.txt
# # add the start of the filepath to the config file (bc we cd'd to only get tiger, it only prints from there)
# sed -i "s/[.]/\/gpfs01\/home\/mbzlld\/data\/OrgOne\/$species\/pod5_files\/$reads/" ${config%.*}_tmp.txt
# # add array numbers to config file
# awk '{print NR,$0}' ${config%.*}_tmp.txt > $config
# rm ${config%.*}_tmp.txt # remove the temp file


# load cuda module
module load cuda-12.2.2

# extract the fast5 directory paths from the config file
pod5_path=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)

# extract the working directory from the pod5 filepath
wkdir=$(echo $pod5_path | cut -f1,2,3,4,5,6,7 -d '/')

# get the name of just the directory the pod5 files are in 
#name=${pod5_path##*/} # this works but the output directories wouldn't have been unique
out_path=$(echo $pod5_path | cut -f10,11,12 -d '/') # so took the last 3 fields as the name instead

# then make a directory with this path (only if one does not already exist with the same name)
mkdir -p $wkdir/basecalls/$out_path


# basecall the duplex reads
dorado duplex \
sup@latest,5mCG_5hmCG \
$pod5_path/ > $wkdir/basecalls/$out_path/SUPlatest_calls.bam

# sup@latest \
# --recursive \
# --verbose \

