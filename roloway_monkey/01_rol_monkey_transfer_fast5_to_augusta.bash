#!/bin/bash
# Laura Dean
# 9/2/24

#####################################

# location of all monkey fast5 files
/mnt/waterprom/org_one/Roloway_Monkey_P1 # 950 GB
/mnt/waterprom/org_one/Roloway_monkey_P2 # 264 GB

#####################################

# copy the above directories to Augusta

# installed tmux on augusta using conda
# in one Tmux window connect to a node with srun
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash

# run rsync after srun connects to a hpc node
# have to run these commands one by one so I can type in my password
# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Roloway_Monkey_P1 \
/share/StickleAss/OrgOne/roloway_monkey/fast5_files/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Roloway_monkey_P2 \
/share/StickleAss/OrgOne/roloway_monkey/fast5_files/

# checked the size of the drive on Augusta - 1.2TB so sizes match :)

