#!/bin/bash
# Laura Dean
# 9/2/24

#####################################

# location of all brown spider monkey fast5 files
/mnt/waterprom/org_one/Brown_spider_monkey_P1     # 328 GB
/mnt/waterprom/org_one/Brown_Spider_Monkey.tar.gz # 290 GB

#####################################

# copy the above directories to Augusta

# installed tmux on augusta using conda
# in one Tmux window connect to a node with srun
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash

# run rsync after srun connects to a hpc node
# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Brown_spider_monkey_P1 \
/share/StickleAss/OrgOne/brown_spider_monkey/fast5_files/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Brown_Spider_Monkey.tar.gz \
/share/StickleAss/OrgOne/brown_spider_monkey/fast5_files/


#####################################

# extract the tar.gz directory
cd /share/StickleAss/OrgOne/brown_spider_monkey/fast5_files
tar -xvzf ./Brown_Spider_Monkey.tar.gz

# checked the contents of the tar.gz archive and it contains nothing more than the P1 reads
# removed the tarball and it's extracted files
# leaving the one Brown_spider_monkey_P1 directory of fast5 reads

