#!/bin/bash
# Laura Dean
# 21/2/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=quast
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=80g
#SBATCH --time=6:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set variables
reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger


source $HOME/.bash_profile
# install and activate software
#conda create --name quast quast
conda activate quast

# compare genomes
python /gpfs01/home/mbzlld/software_bin/miniconda3/envs/quast/bin/quast \
	--threads 64 \
	--eukaryote \
	-r $reference \
	-o $wkdir/quast $wkdir/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta $wkdir/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta $wkdir/hifiasm_asm8/ONTasm.bp.p_ctg.fasta $wkdir/hifiasm_asm1/ONTasm.bp.p_ctg.fasta


conda deactivate

