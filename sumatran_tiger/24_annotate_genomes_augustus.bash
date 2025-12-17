#!/bin/bash
# Laura Dean
# 10/3/25
# 4/12/25
# script written for running on the UoN HPC Ada

# script to run de-novo genome annotation using Augustus
# I tried this with the tiger initially and then decided liftoff was better
# but reviewers want this to be published alongside the asm
# so re-running for the best asm

#SBATCH --job-name=augustus_annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80g
#SBATCH --time=50:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta # has to be in uncompressed fasta format
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names.fasta
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome.fa
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta

# load software
source $HOME/.bash_profile
#conda create --name augustus -c bioconda augustus=3.2.3
conda activate augustus



# run augustus to annotate the genome assembly
# human is the nearest species for mammals and should work reasonably well according to my research
augustus \
	--species=human \
	--noInFrameStop=true \
	--genemodel=complete \
	 --protein=on \
	$assembly > ${assembly%.*}_3.faa





conda deactivate

