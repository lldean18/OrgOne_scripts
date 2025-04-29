#!/bin/bash
# Laura Dean
# 11/4/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=ragtag_rename
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=50g
#SBATCH --time=6:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome.fa
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final.fa


source $HOME/.bash_profile
# create and activate conda env
#conda create --name ragtag ragtag
conda activate ragtag


# rename scaffolds based on domestic cat reference genome
ragtag.py scaffold -t 32 -o ${assembly%.*}_ragtag $reference $assembly



# deactivate software
conda deactivate

# remove the additional text added to fasta headers
sed -i 's/_RagTag//;s/AnAms1.0_//' ${assembly%.*}_ragtag/ragtag.scaffold.fasta



