#!/bin/bash
# Laura Dean
# 2/3/24

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=40g
#SBATCH --time=48:00:00 # jobs completed within 7 hours
#SBATCH --job-name=rpt_tig_pod5
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# for using conda
source $HOME/.bash_profile

# extract the fast5 directory paths from the config file
fast5_path=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files/simplex/sumatran_tiger_P3/20230119_1328_1G_PAM34749_b65364c2/fast5

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


