#!/bin/bash
# Laura Dean
# file written for running on newprom
# 4/12/25

# script to basecall the raw traces from pod5 files

# attach to my tmux session
tmux a -t laura

# make a directory for the basecalled files (only if it does not already exist)
mkdir -p /data/laura/basecalls



# basecall the simplex reads
dorado basecaller \
	/data/laura/dorado_models/dna_r10.4.1_e8.2_400bps_sup@v5.2.0 \
	--recursive \
       	/data/laura/ic_213 > /data/laura/basecalls/SUP_calls.bam


#	sup@latest,5mCG_5hmCG \




