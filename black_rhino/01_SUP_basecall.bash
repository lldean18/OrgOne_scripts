#!/bin/bash
# 23/6/26

# script to run SUP basecalling on pod5's

#SBATCH --partition=ampereq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --gres=gpu:A100-full:1
#SBATCH --mem=256g
#SBATCH --time=100:00:00
#SBATCH --job-name=rhino_basecall
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup environment
module load cuda-12.2.2
mkdir -p /gpfs01/home/mbzlld/data/OrgOne/black_rhino
cd /gpfs01/home/mbzlld/data/OrgOne/black_rhino
mkdir -p SUP_basecalls


# basecall the simplex reads
dorado basecaller \
	sup@latest \
        --modified-bases 5mC_5hmC 6mA \
	--recursive \
	--models-directory /gpfs01/home/mbzlld/data/dorado_models/dorado_models \
       	/share/StickleAss/OrgOne/black_rhino/pod5_files > SUP_basecalls/rhino_SUP.bam

#        --modified-bases 5mCG_5hmCG \

# unload module
module unload cuda-12.2.2




