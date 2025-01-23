#!/bin/bash
# Laura Dean
# 23/1/25
# for running on the UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=3:00:00
#SBATCH --job-name=telo_explorer
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# create and load conda env
source $HOME/.bash_profile
#cd ~/software_bin
#git clone git@github.com:aaranyue/quarTeT.git
# added the path /gpfs01/home/mbzlld/software_bin/quarTeT to my path in .bashrc
#conda create -n quartet Python Minimap2 MUMmer4 trf CD-hit BLAST tidk R R-RIdeogram R-ggplot2 gnuplot -y
conda activate quartet


# set environmental variables
wkdir=~/data/OrgOne/sumatran_tiger/hifiasm_asm10
genome=ONTasm.bp.p_ctg_100kb.fasta

# move to working directory
cd $wkdir

# run the telomere explorer
python ~/software_bin/quarTeT/quartet.py TeloExplorer \
	-i $genome \
	-c animal \
	-p ${genome%.*}_quartet


