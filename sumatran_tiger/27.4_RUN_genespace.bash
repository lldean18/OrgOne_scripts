#!/bin/bash
# Laura Dean
# 3/4/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=run_genespace
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=30g
#SBATCH --time=2:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


source $HOME/.bash_profile
conda activate genespace4

Rscript ~/github/OrgOne_scripts/sumatran_tiger/27.3_customise_genespace_plot.R


conda deactivate


