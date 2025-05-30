#!/bin/bash
# Laura Dean
# 10/5/24
# for running on Smaug

#SBATCH --partition=LocalQ
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10g
#SBATCH --time=15:00:00
#SBATCH --job-name=rhino_cramino
#SBATCH --output=/data/test_data/org_one/black_rhino/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

# set variables
species=black_rhino # set the species
wkdir=/data/test_data/org_one/${species}

# # generate the list of fastq files and paste them after the --nano-hq flag below
bams=$(find $wkdir/rhino_sup_epi2me -type f -name '*.bam') # set the full bam file name and further path

## create a conda environment and install the software you want
#conda create --name cramino -c conda-forge -c bioconda cramino

# activate the conda environment
conda activate cramino

for line in ${bams//\\n/ }
do

filepath=${line%/*}
echo $filepath

filename=${line##*/}
echo $filename

cd $filepath

# assess quality of bam files
cramino \
--threads 4 \
--hist \
--ubam \
$filename

done

# deactivate the conda environment
conda deactivate

