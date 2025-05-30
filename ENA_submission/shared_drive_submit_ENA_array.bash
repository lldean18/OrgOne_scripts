#!/bin/bash
# Laura Dean
# 5/4/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50g
#SBATCH --time=100:00:00
#SBATCH --job-name=ENA_tarball_submission_share
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-5


# set variables
wkdir=/share/StickleAss/OrgOne # set the working directory
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/ENA_tarball_array_config_share.txt # set the name of the config file

# ##### GENERATE THE ARRAY CONFIG FILE #####
# # generate list of file paths for the array config
# cd $wkdir
# # list all tarballs & write to config file
# find . -type f -name '*.tar.gz' | sort -u > ${config%.*}_tmp.txt
# # add the start of the filepath to the config file (bc we cd'd to only get tiger, it only prints from there)
# sed -i "s/[.]/\/share\/StickleAss\/OrgOne/" ${config%.*}_tmp.txt
# # manually delete lines for files I have already uploaded with vim then...
# # add array numbers to config file
# awk '{print NR,$0}' ${config%.*}_tmp.txt > $config
# rm ${config%.*}_tmp.txt # remove the temp file

# extract the tarball name and path for this array number
tarball=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)

echo $tarball

# make ENA submission
curl --upload-file $tarball --user Webin-154:hjsH3ZTp ftp://webin2.ebi.ac.uk


# this submission took like 2 or 3 days for roloway monkey but completed successfully :D
# running for the western chimpanzee took a bit less time & successfully completed :)
# running for the black and white ruffed lemur took a couple of days and 2 attempts but completed successfully
# running for the brown spider monkey this only took about a day!


