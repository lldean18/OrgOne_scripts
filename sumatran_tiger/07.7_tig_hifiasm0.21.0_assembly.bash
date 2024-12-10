#!/bin/bash
# Laura Dean
# 3/12/24
# for running on Ada

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=168:00:00
#SBATCH --job-name=tig_hifiasm10
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

####### PREPARE ENVIRONMENT #######
# create conda environment
#conda create --name hifiasm_new hifiasm
conda activate hifiasm_new


# set environment variables
species=sumatran_tiger # set the species
wkdir=/gpfs01/home/mbzlld/data/OrgOne/$species # set the working directory
attempt=1 # set the attempt number for naming out output directory
attempt=2
attempt=3
reads=$wkdir/basecalls/SUPlatest_simp_and_simp_from_dup.fastq.gz
reads=$wkdir/basecalls/all_simplex_simplex_preprocessed.fastq.gz # set the fastq file containing the reads
reads=$wkdir/basecalls/all_simplex_simplex_herro_corrected.fa.gz # Need fastq not fasta


# make directory for the assembly & move to it
mkdir -p $wkdir/hifiasm_asm$attempt
cd $wkdir/hifiasm_asm$attempt


# run hifiasm on the simplex reads with the new --ont flag to generate the assembly
hifiasm \
-t 96 \
--ont \
-o ONTasm \
$reads



# convert the final assembly to fasta format
awk '/^S/{print ">"$2;print $3}' ONTasm.bp.p_ctg.gfa > ONTasm.bp.p_ctg.fasta



