#!/bin/bash
# Laura Dean
# 2/12/25

# script to record process of copying SUP basecalled bam from newprom back to Ada

# RUN FROM ADA

# set up tmux
conda activate tmux
tmux attach

# copy bam file
cd ~/data/ctenella
rsync -rvh prom@10.157.252.24:/data/laura/basecalls/SUP_calls.bam ./


