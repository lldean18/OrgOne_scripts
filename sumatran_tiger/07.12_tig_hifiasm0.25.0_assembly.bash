#!/bin/bash
# Laura Dean
# 30/3/25
# for running on Ada

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=24:00:00
#SBATCH --job-name=tig_hifiasm0.25.0
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

####### PREPARE ENVIRONMENT #######
# create conda environment
#conda create --name hifiasm_0.25.0 hifiasm -y
conda activate hifiasm_0.25.0


# set environment variables
species=sumatran_tiger # set the species
wkdir=/gpfs01/home/mbzlld/data/OrgOne/$species # set the working directory
# set the attempt number for naming the output directory of each try
# then set the reads file that was used in that attempt
attempt=12
reads=$wkdir/basecalls/simplex_simplex_and_duplex.fastq.gz # running with the simplex runs merged with the duplex extracted from duplex runs

# print a line to the slurm output that says exactly what was done on this run
echo "This is hifiasm version 0.25.0 running on the file $reads and saving the output to the directory $wkdir/hifiasm_asm$attempt"

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

# deactivate conda
conda deactivate

