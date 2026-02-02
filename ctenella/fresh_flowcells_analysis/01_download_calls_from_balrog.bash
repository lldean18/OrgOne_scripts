#!/bin/bash
# Laura Dean
# 2/2/26

# note of code used to download the basecalled fastq from balrog to Ada

# set up env
conda activate tmux
tmux new -t datadownload
srun --partition defq --cpus-per-task 1 --mem 10g --time 10:00:00 --pty bash
cd /share/deepseq/laura/ctenella


# pull the fastq from balrog
rsync -vh --progress mbzlld@10.157.252.29:/data/matt/Ctenella_sup.fastq.gz ./

