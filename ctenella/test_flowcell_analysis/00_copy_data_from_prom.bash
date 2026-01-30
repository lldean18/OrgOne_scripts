#!/bin/bash
# Laura Dean
# 25/11/25

# noting down the code I used to copy the files from prom to Ada

# setup tmux session
conda activate tmux
tmux attach

# request an interactive job
srun --partition defq --cpus-per-task 1 --mem 50g --time 168:00:00 --pty bash

# change to dir in which I want to put the data
cd /gpfs01/home/mbzlld/data/ctenella/pod5s

# copy the data to Ada
rsync -rvh --progress prom@10.157.252.34:/data/ic_213 ./


