#!/bin/bash
# Laura Dean
# 14/12/23

#SBATCH --partition=LocalQ
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=1g
#SBATCH --time=00:10:00
#SBATCH --job-name=splfast
#SBATCH --output=/home/mbzlld/slurm-%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbzlld@exmail.nottingham.ac.uk

# this took less than a minute to run on smaug in the login node so no need to submit as a job

# load your bash profile for using conda
source $HOME/.bash_profile

# create your environment
#conda create --name pyfasta

# activate the conda environment containing your software
conda activate pyfasta

# install pyfasta to split the reference genome so that the job can be parallelised
#conda install -c conda-forge -c bioconda python=3.9 pyfasta -y

# set variables
assembly=/data/test_data/org_one/black_rhino/black_rhino_asm_002/00-assembly/draft_assembly.fasta

# the original fasta was not removed so no need to make future backups
# first make a back up of your assembly
#cp $assembly ${assembly%.*}_backup.fa

# then split into 10 pieces...
pyfasta split -n 10 $assembly

conda deactivate

