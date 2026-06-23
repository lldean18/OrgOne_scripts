#!/bin/bash
# Laura Dean
# 10/12/23

#SBATCH --partition=LocalQ
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=10g
#SBATCH --time=50:00:00
#SBATCH --job-name=conda
#SBATCH --output=/home/mbzlld/slurm-%x-%j.out


source $HOME/.bash_profile

conda create --name busco

conda activate busco

conda install -c conda-forge -c bioconda busco=5.5.0 -y

busco --help

conda deactivate


