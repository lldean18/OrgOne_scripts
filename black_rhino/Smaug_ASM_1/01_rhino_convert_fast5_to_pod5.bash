#!/bin/bash
# Laura Dean
# Friday 17th Nov 23

#SBATCH --partition=LocalQ
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --tasks-per-node=40
#SBATCH --mem=4g
#SBATCH --time=24:00:00
#SBATCH --job-name=pod5
#SBATCH --output=/home/mbzlld/slurm-%x-%j.out

source $HOME/.bash_profile

## location of rhino fast5 files:
#/mnt/waterprom/org_one/Black_Rhino_P1/20230118_1701_3G_PAM45394_c4a641a4/fast5/
## with the filenames:
#PAM45394_c4a641a4_d3469262_'number'.fast5

#############################
# Set environment variables #
#############################

# keep P1 and P2 fast5 files seperate?

### FOR P1 FAST5 FILES ###
# # set working directory for whatever species you're working on
# wdir=/data/test_data/org_one/black_rhino
# # set the mount directory or directories in which the fast5 files are stored long term
# sdir=/mnt/waterprom/org_one/Black_Rhino_P1/20230118_1701_3G_PAM45394_c4a641a4/fast5
# # set the promethion run for the fast5 files you are going to work on
# P=1
# # set the file prefix of the fast5 files
# file_prefix=PAM45394_c4a641a4_d3469262_
# # set the total number of files to loop over
# nfiles=$(ls $sdir | wc -l)
# nfiles=$(($nfiles-1))

### FOR P2 pass FAST5 FILES ###
# # set working directory for whatever species you're working on
# wdir=/data/test_data/org_one/black_rhino
# # set the mount directory or directories in which the fast5 files are stored long term
# sdir=/mnt/waterprom/org_one/Black_rhino_P2/20230207_1523_2H_PAM70369_8b55b5b8/fast5_pass
# # set the promethion run for the fast5 files you are going to work on
# P=2
# # set the file prefix of the fast5 files
# file_prefix=PAM70369_pass_8b55b5b8_864e53f0_
# # set the total number of files to loop over
# nfiles=$(ls $sdir | wc -l)
# nfiles=$(($nfiles-1))

### FOR P2 fail FAST5 FILES ###
# set working directory for whatever species you're working on
wdir=/data/test_data/org_one/black_rhino
# set the mount directory or directories in which the fast5 files are stored long term
sdir=/mnt/waterprom/org_one/Black_rhino_P2/20230207_1523_2H_PAM70369_8b55b5b8/fast5_fail
# set the promethion run for the fast5 files you are going to work on
P=2
# set the file prefix of the fast5 files
file_prefix=PAM70369_fail_8b55b5b8_864e53f0_

# set the total number of files to loop over
nfiles=$(ls $sdir | wc -l)
nfiles=$(($nfiles-1))
fail=fail


##########################################################################
# Copy fast5 files to the data partition and convert them to pod5 format #
##########################################################################

# make a new directory for the fast5 files in the working directory (only if one does not already exist with the same name)
#mkdir -p $wdir/fast5_P$P$fail

# Copy fast5 files to the data partition for working on them
#cp $sdir/*.fast5 $wdir/fast5_P$P$fail/

# make a directory for the pod5 files you will make (only if one does not already exist with the same name)
mkdir -p $wdir/pod5_P$P

# activate your conda environment
conda activate pod5

# I couldn't work out why this wouldn't work so in the end just did it with zellij with the loop under this one
# in a terminal window! :(
for i in {0..$nfiles}
do
# convert fast5 files to pod5
# this took just a few seconds per file
pod5 convert \
fast5 $wdir/fast5_P$P\_$fail/$file_prefix$i.fast5 \
--output $wdir/pod5_P$P/$file_prefix$i.pod5
done

conda deactivate

# this ran fine from within the directory I wanted to convert the files from.
for file in ./*
do
pod5 convert \
fast5 ./$file \
--output /data/test_data/org_one/black_rhino/pod5_P2/${file%.*}.pod5
done




