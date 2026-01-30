#!/bin/bash
# Laura Dean
# 2/12/25

# noting down the code I used to copy the files from Ada to newprom

# setup tmux session
conda activate tmux
tmux new -s filetransfer

# request an interactive job
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash

# change to dir in which I want to put the data
cd /gpfs01/home/mbzlld/data/ctenella/pod5s

# copy the data to Ada
rsync -rvh --progress ic_213 prom@10.157.252.24:/data/laura/


