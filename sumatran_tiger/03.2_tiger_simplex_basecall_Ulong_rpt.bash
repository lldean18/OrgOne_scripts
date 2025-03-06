#!/bin/bash
# Laura Dean
# 1/3/24

#SBATCH --partition=ampereq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --gres=gpu:2
#SBATCH --mem=256g
#SBATCH --time=167:00:00
#SBATCH --job-name=tig_basecall
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# load cuda module
module load cuda-12.2.2

# extract the fast5 directory paths from the config file
pod5_path=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/pod5_files/simplex/sumatran_tiger_P3/20230119_1328_1G_PAM34749_b65364c2/pod5

# extract the working directory from the pod5 filepath
wkdir=$(echo $pod5_path | cut -f1,2,3,4,5,6,7 -d '/')

# get the name of just the directory the pod5 files are in 
#name=${pod5_path##*/} # this works but the output directories wouldn't have been unique
out_path=$(echo $pod5_path | cut -f10,11,12 -d '/') # so took the last 3 fields as the name instead

# then make a directory with this path (only if one does not already exist with the same name)
mkdir -p $wkdir/basecalls/$out_path


# basecall the simplex reads
dorado basecaller \
--verbose \
sup@latest \
$pod5_path/ > $wkdir/basecalls/$out_path/SUPlatest_calls.bam

# --recursive \
