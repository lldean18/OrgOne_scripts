#!/bin/bash
# Laura Dean
# 19/1/24

#SBATCH --partition=LocalQ
#SBATCH --nodes=1
#SBATCH --ntasks=40
#SBATCH --tasks-per-node=40
#SBATCH --mem=4g
#SBATCH --time=24:00:00
#SBATCH --job-name=pod5
#SBATCH --output=/home/mbzlld/slurm-%x-%j.out

source $HOME/.bash_profile

## location of tiger fast5 files:
# /mnt/waterprom/org_one/sumatran_tiger_P1/20230111_1737_3D_PAM34692_e5400fa7/fast5    # 253 Gb


#############################
# Set environment variables #
#############################

# keep P1 and P2 fast5 files seperate? YES


# set working directory for whatever species you're working on
wdir=/data/test_data/org_one/sumatran_tiger/lauras_work

# set the mount directory or directories in which the fast5 files are stored long term
#sdir=/mnt/waterprom/org_one/sumatran_tiger_P1/20230111_1737_3D_PAM34692_e5400fa7/fast5
#sdir=/mnt/waterprom/org_one/sumatran_tiger_P2/20230113_1342_3F_PAM70827_70386f08/fast5
#sdir=/mnt/waterprom/org_one/sumatran_tiger_P3/20230119_1328_1G_PAM34749_b65364c2/fast5
#sdir=/mnt/waterprom/org_one/sumatran_Tiger_P4/20230207_1523_1C_PAO11037_b4b86f62/fast5_pass
#sdir=/mnt/waterprom/org_one/sumatran_Tiger_P4/20230207_1523_1C_PAO11037_b4b86f62/fast5_fail
#sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/fast5_pass
#sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/fast5_fail
#sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/fast5_pass
#sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/fast5_fail
#sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/fast5_pass
#sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/fast5_fail
#sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/fast5_pass
#sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/fast5_fail
#sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/fast5_pass
sdir=/mnt/waterprom/org_one/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/fast5_fail

#P=duplex_P2_pass # set the promethion run
#P=duplex_P2_fail # set the promethion run
#P=duplex_P3_pass
P=duplex_P3_fail

##########################################################################
# Copy fast5 files to the data partition and convert them to pod5 format #
##########################################################################

# make a new directory for the fast5 files in the working directory (only if one does not already exist with the same name)
mkdir -p $wdir/fast5_P${P}

# Copy fast5 files to the data partition for working on them
cp -v $sdir/*.fast5 $wdir/fast5_P${P}

# make a directory for the pod5 files you will make (only if one does not already exist with the same name)
mkdir -p $wdir/pod5_P${P}

# activate your conda environment
conda activate pod5

# loop over files in directories and convert fast5 to pod5
for file in $wdir/fast5_P${P}/*
do
filename="${file##*/}" # extract whole filenames
filename="${filename%.*}" # remove file extensions
# convert fast5 files to pod5
# this took just a few seconds per file
pod5 convert \
fast5 $wdir/fast5_P${P}/$filename.fast5 \
--output $wdir/pod5_P${P}/$filename.pod5
done

conda deactivate



# ran this code in a tmux window for each of the folders containing tiger fast5 files




