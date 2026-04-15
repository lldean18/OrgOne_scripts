#!/bin/bash
# 15/4/26

# script to have a look at synteny between the assemblies for the ctenella twelve

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=20g
#SBATCH --time=2:00:00
#SBATCH --job-name=ctenella_synteny
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
source $HOME/.bash_profile
#conda create --name ntsynt -c bioconda -c conda-forge ntsynt
conda activate ntsynt
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/assemblies


# make a list of the assemblies to plot
#ls barcode*/barcode*_ONTasm.bp.p_ctg.fasta > assemblies_list.txt

# estimate divergence between sequences


# plot synteny between assemblies
ntSynt \
  --fastas_list assemblies_list.txt \
  --divergence

# unload software
conda deactivate

