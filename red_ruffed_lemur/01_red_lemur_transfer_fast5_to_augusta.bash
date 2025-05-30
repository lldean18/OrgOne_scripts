#!/bin/bash
# Laura Dean
# 9/2/24

#####################################

# location of all red ruffed lemur fast5 files
/mnt/waterprom/org_one/Red_ruffed_lemur_P1         # 371 GB
/mnt/waterprom/org_one/Red_ruffed_lemur_sheared_P1 # 724 GB
/mnt/waterprom/org_one/Red_ruffed_lemur_duplex     # 364 GB
/mnt/waterprom/org_one/Red_ruffed_lemur_duplex_ns  # 713 GB
/mnt/waterprom/org_one/Red_ruffed_lemur.tar.gz     # 1.8 TB

#####################################

# copy the above directories to Augusta

# installed tmux on augusta using conda
# in one Tmux window connect to a node with srun
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash

# run rsync after srun connects to a hpc node
# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Red_ruffed_lemur_P1 \
/share/StickleAss/OrgOne/red_ruffed_lemur/fast5_files/simplex/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Red_ruffed_lemur_sheared_P1 \
/share/StickleAss/OrgOne/red_ruffed_lemur/fast5_files/simplex/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Red_ruffed_lemur_duplex \
/share/StickleAss/OrgOne/red_ruffed_lemur/fast5_files/duplex/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Red_ruffed_lemur_duplex_ns \
/share/StickleAss/OrgOne/red_ruffed_lemur/fast5_files/duplex/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Red_ruffed_lemur.tar.gz \
/share/StickleAss/OrgOne/red_ruffed_lemur/fast5_files/


#####################################

# extract the tar.gz directory
cd /share/StickleAss/OrgOne/red_ruffed_lemur/fast5_files
tar -xvzf ./Red_ruffed_lemur.tar.gz

# check if it contains any reads that aren't in the non tarball directories

# no, the 4 runs are the same so removed the tarball and extracted file







