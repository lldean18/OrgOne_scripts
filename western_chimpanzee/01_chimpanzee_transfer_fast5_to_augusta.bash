#!/bin/bash
# Laura Dean
# 1/3/24

#####################################

# location of all western chimpanzee fast5 files
/mnt/waterprom/org_one/Western_Chimpanzee_P1  # 447 GB

#####################################

# copy the above directories to Ada

# installed tmux on ada using conda
# in one Tmux window connect to a node with srun
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash

# run rsync after srun connects to a hpc node
# not yet run
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Western_Chimpanzee_P1 \
/gpfs01/home/mbzlld/data/OrgOne/western_chimpanzee/fast5_files/

# completed
