#!/bin/bash
# Laura Dean
# 10/3/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=augustus_annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=80g
#SBATCH --time=150:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta # has to be in uncompressed fasta format



# load software
source $HOME/.bash_profile
#conda create --name augustus -c bioconda augustus=3.2.3
conda activate augustus



# run augustus to annotate the genome assembly
# human is the nearest species for mammals and should work reasonably well according to my research
augustus \
	--cds=on \
	--introns=on \
	--start=on \
	--stop=on \
	--species=human \
	$assembly > ${assembly%.*}.gff




conda deactivate

