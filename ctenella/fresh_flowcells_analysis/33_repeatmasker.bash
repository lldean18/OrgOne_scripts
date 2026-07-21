#!/bin/bash
# 21/7/26

# script to run repeatmodeler and repeatmasker for masking of repeat and low
# complexity regions prior to genome annotation

#SBATCH --job-name=repeatmasker
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=17
#SBATCH --mem=80g
#SBATCH --time=80:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
source $HOME/.bash_profile
#conda create --name repeatmasker bioconda::repeatmasker
conda activate repeatmasker
mkdir -p /gpfs01/home/mbzlld/data/ctenella/repeatmodeler
cd /gpfs01/home/mbzlld/data/ctenella/repeatmodeler
assembly=/gpfs01/home/mbzlld/data/ctenella/ctenella_chagius_asm.fasta


# # build repeatmasker database
# BuildDatabase -name ctenella $assembly


# run repeatmodeler
RepeatModeler -database ctenella -pa 16


# run repeat masker
RepeatMasker -pa 16 -xsmall -gff $assembly


# cleanup env
conda deactivate


