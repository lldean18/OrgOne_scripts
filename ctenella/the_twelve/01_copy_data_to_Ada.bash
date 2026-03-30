#!/bin/bash
# 30/3/26

# code to copy data from balrog to Ada

# setup env
conda activate tmux
tmux new -t ctenella
srun --partition defq --cpus-per-task 8 --mem 30g --time 44:00:00 --pty bash

# copy the bam files and their indexes to Ada
rsync -avh mbzlld@10.157.252.29:/data/matt/Ctenella/map_sort_barcode* /gpfs01/home/mbzlld/data/ctenella/the_twelve/


