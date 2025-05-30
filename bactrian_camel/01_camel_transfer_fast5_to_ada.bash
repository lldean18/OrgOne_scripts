#!/bin/bash
# Laura Dean
# 27/3/24

#####################################

# location of all rhino fast5 files
/mnt/waterprom/org_one/Bactrian_camel_P1             # 725G
/mnt/waterprom/org_one/Bactrian_camel_sheared_P1     # 807G

#####################################

# copy the above directories to Ada

# installed tmux on ada using conda
# in one Tmux window connect to a node with srun
srun --partition defq --cpus-per-task 1 --mem 50g --time 12:00:00 --pty bash

# run rsync after srun connects to a hpc node
# ran successfully 28th March 24
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Bactrian_camel_P1 \
/share/StickleAss/OrgOne/bactrian_camel/fast5_files/

# ran successfully 28th March 24
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/Bactrian_camel_sheared_P1 \
/share/StickleAss/OrgOne/bactrian_camel/fast5_files/


