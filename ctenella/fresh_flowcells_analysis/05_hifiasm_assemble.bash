#!/bin/bash
# Laura Dean
# 2/2/26
# for running on Ada

# script to assemble genome using hifiasm ONT mode

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=900g
#SBATCH --time=80:00:00
#SBATCH --job-name=ctenella_assembly
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

####### PREPARE ENVIRONMENT #######
# create conda environment
#conda create --name hifiasm_0.25.0 hifiasm -y
conda activate hifiasm_0.25.0


# set environment variables
#wkdir=/gpfs01/home/mbzlld/data/ctenella
#wkdir=/gpfs01/home/mbzlld/data/ctenella
#wkdir=/share/deepseq/laura/ctenella
#wkdir=/gpfs01/home/mbzlld/data/ctenella
#wkdir=/gpfs01/home/mbzlld/data/ctenella
#wkdir=/gpfs01/home/mbzlld/data/ctenella
#wkdir=/gpfs01/home/mbzlld/data/ctenella
wkdir=/gpfs01/home/mbzlld/data/ctenella

# set the attempt number for naming the output directory of each try
#attempt=1
#attempt=2
#attempt=3
#attempt=4
#attempt=5
#attempt=6
#attempt=7
attempt=8

# then set the reads file that was used in that attempt
#reads=$wkdir/SUP_calls.fastq.gz
#reads=$wkdir/hamster/SUP_calls_no_hamster.fastq.gz
#reads=$wkdir/Ctenella_sup.fastq.gz
#reads=$wkdir/new_flowcell_calls/Ctenella_sup_3.5kb.fasta
#reads=$wkdir/new_flowcell_calls/Ctenella_sup_36-42GC.fastq.gz
#reads=$wkdir/new_flowcell_calls/Ctenella_sup_36-42GC.fastq.gz
#reads=$wkdir/new_flowcell_calls/Ctenella_sup_no_symbionts.fastq.gz
reads=/share/deepseq/laura/ctenella/kraken2/Ctenella_sup_k2_Montipora.fastq

# print a line to the slurm output that says exactly what was done on this run
echo "This is hifiasm version 0.25.0 running on the file $reads and saving the output to the directory $wkdir/hifiasm_asm$attempt"

# make directory for the assembly & move to it
mkdir -p $wkdir/hifiasm_asm$attempt
cd $wkdir/hifiasm_asm$attempt

# run hifiasm on the simplex reads with the new --ont flag to generate the assembly
hifiasm \
--telo-m AACCCT \
-t 42 \
--ont \
-o ONTasm \
$reads

# convert the final assembly to fasta format
awk '/^S/{print ">"$2;print $3}' ONTasm.bp.p_ctg.gfa > ONTasm.bp.p_ctg.fasta

# deactivate conda
conda deactivate


