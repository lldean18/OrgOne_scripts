#!/bin/bash
# Laura Dean
# 27/3/24

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4g
#SBATCH --time=167:00:00
#SBATCH --job-name=rhino_pod5_convert
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-3

# set variables
species=black_rhino
wkdir=/share/StickleAss/OrgOne/$species # set the working directory
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/${species}_fast52pod5_array_config.txt # set the name of the config file


# ##### GENERATE THE ARRAY CONFIG FILE #####
# # generate list of file paths for the array config
# cd $wkdir/fast5_files
# # list all directories containing fast5 files & write to config file
# find . -type f -name '*fast5*' | sed -r 's|/[^/]+$||' |sort -u > ${config%.*}_tmp.txt
# # add the start of the filepath to the config file (bc we cd'd to only get tiger, it only prints from there)
# sed -i "s/[.]/\/share\/StickleAss\/OrgOne\/$species\/fast5_files/" ${config%.*}_tmp.txt
# # add array numbers to config file
# awk '{print NR,$0}' ${config%.*}_tmp.txt > $config
# rm ${config%.*}_tmp.txt # remove the temp file


# for using conda
source $HOME/.bash_profile

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


