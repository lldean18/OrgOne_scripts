#!/bin/bash
# Laura Dean
# 29/11/24
# for running on the UoN HPC Ada

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=168:00:00
#SBATCH --job-name=blacklemur_hifiasm1
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile # source bash profile to allow use of conda

# create conda environment
#conda create --name hifiasm_new hifiasm
conda activate hifiasm_new


# set environment variables
species=black_and_white_ruffed_lemur # set the species
wkdir=/share/StickleAss/OrgOne/$species # set the working directory
attempt=1 # set the attempt number for naming out output directory
reads=$wkdir/basecalls/All_SUPlatest_calls.fastq.gz # set the fastq file containing the reads


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

# deactivate condda environment
conda deactivate
