#!/bin/bash
# Laura Dean
# 9/2/24

#####################################

# location of all black and white ruffed lemur fast5 files
/mnt/waterprom/org_one/Black_and_whilte_ruffed_lemur_P1 # 375 GB
/mnt/waterprom/org_one/Black_and_white_ruffed_lemur.tar.gz # 332 GB

#####################################

# copy the above directories to Augusta

# installed tmux on augusta using conda
# in one Tmux window connect to a node with srun
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash

# run rsync after srun connects to a hpc node
# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Black_and_white_ruffed_lemur.tar.gz \
/share/StickleAss/OrgOne/black_and_white_ruffed_lemur/fast5_files/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Black_and_whilte_ruffed_lemur_P1 \
/share/StickleAss/OrgOne/black_and_white_ruffed_lemur/fast5_files/



#####################################

# extract the tar.gz directory
cd /share/StickleAss/OrgOne/black_and_white_ruffed_lemur/fast5_files
tar -xvzf ./Black_and_white_ruffed_lemur.tar.gz

# checked the contents of the tar.gz archive and it contains nothing more than the P1 reads
# removed the tarball and it's extracted files
# leaving the one Black_and_whilte_ruffed_lemur_P1 directory of fast5 reads

