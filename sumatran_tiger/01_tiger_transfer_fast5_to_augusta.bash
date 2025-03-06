#!/bin/bash
# Laura Dean
# 2/2/24

# location of all tiger fast5 files

# simplex
#/mnt/waterprom/org_one/sumatran_tiger_P1/20230111_1737_3D_PAM34692_e5400fa7/fast5 # 253 Gb
#/mnt/waterprom/org_one/sumatran_tiger_P2/20230113_1342_3F_PAM70827_70386f08/fast5
#/mnt/waterprom/org_one/sumatran_tiger_P3/20230119_1328_1G_PAM34749_b65364c2/fast5

#/mnt/waterprom/org_one/sumatran_Tiger_P4/20230207_1523_1C_PAO11037_b4b86f62/fast5_pass
#/mnt/waterprom/org_one/sumatran_Tiger_P4/20230207_1523_1C_PAO11037_b4b86f62/fast5_fail

# duplex
#/mnt/waterprom/org_one/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/fast5_pass
#/mnt/waterprom/org_one/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/fast5_fail

#/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/fast5_pass
#/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/fast5_fail

#/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/fast5_pass
#/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/fast5_fail

#/mnt/waterprom/org_one/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/fast5_pass
#/mnt/waterprom/org_one/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/fast5_fail

#/mnt/waterprom/org_one/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/fast5_pass
#/mnt/waterprom/org_one/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/fast5_fail



# run from Augusta
# tried to run in a login node but it was really slow so cancelled and thought about submitting as a job
# realised I can't do this easily because I can't pass my smaug password to rsync!
# will have to run leaving laptop open when I get home 0_o
# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/sumatran_tiger_P1/20230111_1737_3D_PAM34692_e5400fa7 \
~/data/sumatran_tiger/fast5_files/simplex/sumatran_tiger_P1/ # 253 Gb


# new plan to make this faster... try to run from smaug in tmux window
# ok coudn't do that because couldn't connect to Augusta without it's ip address
# new plan, installed tmux on augusta using conda
# run rsync in tmux screens on Augusta
# ran successfully on Augusta
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/sumatran_tiger_P2/20230113_1342_3F_PAM70827_70386f08 \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files/simplex/sumatran_tiger_P2/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/sumatran_tiger_P3/20230119_1328_1G_PAM34749_b65364c2 \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files/simplex/sumatran_tiger_P3/

# ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/sumatran_Tiger_P4/20230207_1523_1C_PAO11037_b4b86f62 \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files/simplex/sumatran_tiger_P4/

# the above ran successfully even though they were all pasted in one after the other and I didn't enter
# my password seperately each time - so maybe that's not necessary after one rsync command?

#####################################

# in one Tmux window connect to a node with srun
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash
# Ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1 \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files/duplex/sumatran_tiger_duplex/

# Ran successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files/duplex/sumatran_tiger_duplex_P3/

# completed successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files/duplex/sumatran_tiger_duplex_ns/

# completed successfully
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2 \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files/duplex/sumatran_tiger_duplex_ns/

# completed successfully 
rsync -rvh --progress \
mbzlld@10.157.200.14:/mnt/waterprom/org_one/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88 \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/fast5_files/duplex/sumatran_tiger_duplex_P2/





