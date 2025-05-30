#!/bin/bash
# Laura Dean
# 23/4/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10g
#SBATCH --time=8:00:00
#SBATCH --job-name=chimp_cramino
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

# set variables
species=western_chimpanzee # set the species
#wkdir=/share/StickleAss/OrgOne/${species} # set the working directory
wkdir=/gpfs01/home/mbzlld/data/OrgOne/${species}

# # generate the list of fastq files and paste them after the --nano-hq flag below
bams=$(find $wkdir/basecalls -type f -name '*.bam') # set the full bam file name and further path

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

