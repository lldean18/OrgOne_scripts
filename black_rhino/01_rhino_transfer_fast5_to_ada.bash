#!/bin/bash
# Laura Dean
# 26/3/24

#####################################

# location of all rhino fast5 files
/mnt/waterprom/org_one/Black_Rhino_P1     # 664G	Black_Rhino_P1
/mnt/waterprom/org_one/Black_rhino_P2     # 68G		Black_rhino_P2

#####################################

# copy the above directories to Ada

# installed tmux on ada using conda
# in one Tmux window connect to a node with srun
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash

# run rsync after srun connects to a hpc node
# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Black_Rhino_P1 \
/share/StickleAss/OrgOne/black_rhino/fast5_files/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Black_rhino_P2 \
/share/StickleAss/OrgOne/black_rhino/fast5_files/


