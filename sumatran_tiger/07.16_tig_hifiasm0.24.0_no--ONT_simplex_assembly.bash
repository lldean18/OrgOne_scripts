#!/bin/bash
# Laura Dean
# 7/5/25
# for running on Ada

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=24:00:00
#SBATCH --job-name=tig_hifiasm0.24.0_simp
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

####### PREPARE ENVIRONMENT #######
# create conda environment
#conda create --name hifiasm_0.24.0 hifiasm -y
conda activate hifiasm_0.24.0


# set environment variables
species=sumatran_tiger # set the species
wkdir=/gpfs01/home/mbzlld/data/OrgOne/$species # set the working directory
# set the attempt number for naming the output directory of each try
# then set the reads file that was used in that attempt
attempt=13
#reads=$wkdir/basecalls/all_simplex_simplex.fastq.gz # running the file with the best previous assembly in the newest version of hifiasm

# print a line to the slurm output that says exactly what was done on this run
echo "This is hifiasm version 0.24.0 running on the file $reads WITHOUT the new --ONT flag and saving the output to the directory $wkdir/hifiasm_asm$attempt"

# make directory for the assembly & move to it
mkdir -p $wkdir/hifiasm_asm$attempt
cd $wkdir/hifiasm_asm$attempt

# run hifiasm on the simplex reads withOUT the new --ont flag to generate the assembly
hifiasm \
-t 96 \
-o ONTasm \
$reads


#--ont \


# convert the final assembly to fasta format
awk '/^S/{print ">"$2;print $3}' ONTasm.bp.p_ctg.gfa > ONTasm.bp.p_ctg.fasta

# deactivate conda
conda deactivate

