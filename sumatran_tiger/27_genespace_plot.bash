#!/bin/bash
# Laura Dean
# 14/3/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=genespace
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=1:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# install and load software
source $HOME/.bash_profile
conda create --name genespace bioconda::orthofinder=2.5.5 bioconda::mcscanx conda-forge::r-base r::rstudio -y
conda activate genespace
conda install r-devtools
conda install r-BiocManager
conda install r-gtable r-MASS r-Matrix r-cpp11 r-lattice

conda install r-base=4.4.1 # trying this

# ok trying again from scratch
conda create --name genespace2 bioconda::orthofinder=2.5.5 bioconda::mcscanx conda-forge::r-base=4.4.1 -y
conda activate genespace2
#conda install r-devtools r-BiocManager # this line wouldn't run because of a wierd orthofinder error try installing in R

R
install.packages("devtools")

# ok trying a fourth time from scratch
# first ran: conda config --remove channels defaults
# this removed some silly conflict warning. Then ran:
conda create --name genespace4 orthofinder=2.5.5 mcscanx r-base=4.4.1 r-devtools r-BiocManager bioconductor-biostrings -y
conda activate genespace4
R
devtools::install_github("jtlovell/GENESPACE")
BiocManager::install("rtracklayer")
library(GENESPACE)

# To actually use it
conda activate genespace4
R
library(GENESPACE)






