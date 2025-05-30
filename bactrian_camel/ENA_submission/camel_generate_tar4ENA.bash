#!/bin/bash
# Laura Dean
# 4/4/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=30g
#SBATCH --time=60:00:00
#SBATCH --job-name=camel_tarball_prep
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-3

# set variables
species=bactrian_camel
wkdir=/share/StickleAss/OrgOne/${species} # set the working directory
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/${species}_tarball_prep_array_config.txt # set the name of the config file


# ##### GENERATE THE ARRAY CONFIG FILE #####
# ##### FOR Single promethion run #####
# # generate list of file paths for the array config
# cd $wkdir/pod5_files
# # list all tarballs & write to config file
# \ls > ${config%.*}_tmp1.txt
# # add the start of the filepath to the config file (bc we cd'd to only get tiger, it only prints from there)
# sed -i "s/^/\/share\/StickleAss\/OrgOne\/${species}\/pod5_files\//" ${config%.*}_tmp1.txt
# # then delete the 1st line (which is P1 with 2x runs)
# sed -i '1d' ${config%.*}_tmp1.txt
# ##### FOR two promethion runs #####
# cd $wkdir/pod5_files/Bactrian_camel_P1
# # list all tarballs & write to config file
# \ls > ${config%.*}_tmp2.txt
# # add the start of the filepath to the config file (bc we cd'd to only get tiger, it only prints from there)
# sed -i "s/^/\/share\/StickleAss\/OrgOne\/${species}\/pod5_files\/Bactrian_camel_P1\//" ${config%.*}_tmp2.txt
# ##### ADD TOGETHER #####
# cat ${config%.*}_tmp1.txt ${config%.*}_tmp2.txt > ${config%.*}_tmp.txt
# # add array numbers to config file
# awk '{print NR,$0}' ${config%.*}_tmp.txt > $config
# rm ${config%.*}_tmp1.txt ${config%.*}_tmp2.txt ${config%.*}_tmp.txt # remove the temp file
# # replace the last backslash with a space
# sed -i -E 's/(.*)\//\1 /' $config
# # finally add a new column manually for what you want each tarball to be called with VIM
# # vim $config 




# extract the tarball name and path for this array number
directory=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)
tar_dir=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $3}' $config)
tar_name=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $4}' $config)

# output info for this array
echo "The path to the directory being tarballed is: $directory"
echo "The directory being tarballed is: $tar_dir"
echo "The name of the tarball being created is: $tar_name"


##### Generate the tarball #####
# move to the directory containing the pod5 files to be tarred
cd $directory
# create a compressed tar archive of each promethion run
tar -cvzf $tar_name ./$tar_dir


##### Generate the MD5 checksums for this tarball
md5sum $tar_name > ${tar_name%.*.*}.md5




