#!/bin/bash
# Laura Dean
# 1/3/24

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=30g # ran on 4G failed for ultra long reads so upped to 30
#SBATCH --time=48:00:00 # jobs completed within 7 hours
#SBATCH --job-name=tig_pod5
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-15

## location of tiger fast5 files:
#/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files  # 3.7 TB

##### GENERATE THE ARRAY CONFIG FILE #####
# # generate list of file paths for the array config
# cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files
# # list all directories containing fast5 files & write to config file
# find . -type f -name '*fast5*' | sed -r 's|/[^/]+$||' |sort -u > ~/code_and_scripts/config_files/sum_tiger_pod5_conv_array_config_tmp.txt
# # add the start of the filepath to the config file (bc we cd'd to only get tiger, it only prints from there)
# sed -i 's/[.]/\/gpfs01\/home\/mbzlld\/data\/OrgOne\/sumatran_tiger\/fast5_files/' ~/code_and_scripts/config_files/sum_tiger_pod5_conv_array_config_tmp.txt
# # add array numbers to config file
# awk '{print NR,$0}' ~/code_and_scripts/config_files/sum_tiger_pod5_conv_array_config_tmp.txt > ~/code_and_scripts/config_files/sum_tiger_pod5_conv_array_config.txt
# rm ~/code_and_scripts/config_files/sum_tiger_pod5_conv_array_config_tmp.txt # remove the temp file

# for using conda
source $HOME/.bash_profile

# set the config file
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/sum_tiger_pod5_conv_array_config.txt

# extract the fast5 directory paths from the config file
fast5_path=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)

# make a new version of the fast5 filepath where fast5_files is replaced with pod5_files
pod5_path=$(sed 's/fast5/pod5/g' <<< "$fast5_path")

# then make a with this path (only if one does not already exist with the same name)
mkdir -p $pod5_path



# activate your conda environment
conda activate pod5

# loop over files in directories and convert fast5 to pod5
cd $fast5_path
for file in ./*
do
filename="${file##*/}" # extract whole filenames
filename="${filename%.*}" # remove file extensions
# convert fast5 files to pod5
pod5 convert \
fast5 $file \
--output $pod5_path/$filename.pod5
done

# deactivate conda environment
conda deactivate


