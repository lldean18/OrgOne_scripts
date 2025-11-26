#!/bin/bash
# Laura Dean
# file written for running on the UoN HPC Ada
# 25/11/25

# script to basecall the raw traces from pod5 files

#SBATCH --partition=ampereq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --gres=gpu:1
#SBATCH --mem=256g
#SBATCH --time=100:00:00
#SBATCH --job-name=ctenella_basecall
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
wkdir=/gpfs01/home/mbzlld/data/ctenella


# then make a directory for the basecalled files (only if it does not already exist)
mkdir -p $wkdir/basecalls
cd $wkdir/basecalls


# load cuda module
module load cuda-12.2.2


# basecall the simplex reads
dorado basecaller \
	sup@latest,5mCG_5hmCG \
	--recursive \
       	$wkdir/pod5s  > $wkdir/basecalls/SUP_calls.bam


#	sup@latest,5mCG_5hmCG \
#	/gpfs01/home/mbzlld/data/dorado_models/dna_r10.4.1_e8.2_400bps_sup@v5.2.0 \

# unload module
module unload cuda-12.2.2



