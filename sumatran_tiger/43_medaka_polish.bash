#!/bin/bash
# Laura Dean
# 13/12/25
# script written for running on the UoN HPC Ada

# script to polish a genome assembly using medaka polish

#SBATCH --job-name=medaka_polish
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=150g
#SBATCH --time=168:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/medaka_polish
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta
reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_extracted_duplex_duplex.fastq.gz


# setup env
mkdir -p $wkdir
cd $wkdir
source $HOME/.bash_profile
#conda create -n medaka -c conda-forge -c nanoporetech -c bioconda medaka
conda activate medaka


# run medaka to polish the assembly with the duplex reads
medaka_consensus -i $reads -d $assembly -o $wkdir -t 46


conda deactivate



