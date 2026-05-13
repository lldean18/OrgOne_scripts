#!/bin/bash
# 5/5/26

# script to run SUP basecalling on the snake-neck turtle pod5's

#SBATCH --partition=ampereq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --gres=gpu:A100-full:1
#SBATCH --mem=256g
#SBATCH --time=100:00:00
#SBATCH --job-name=turtle_basecall
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup environment
module load cuda-12.2.2
cd /share/deepseq/org_one/SNT052


# basecall the simplex reads
dorado basecaller \
	sup@latest \
        --modified-bases 5mC_5hmC 6mA \
	--recursive \
	--models-directory /gpfs01/home/mbzlld/data/dorado_models/dorado_models \
       	20260428_1505_1E_PBG22653_beadde09/pod5 > SUP_basecalls/turtle_SUP.bam

#        --modified-bases 5mCG_5hmCG \

# unload module
module unload cuda-12.2.2

