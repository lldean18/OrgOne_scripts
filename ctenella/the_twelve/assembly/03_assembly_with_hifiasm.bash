#!/bin/bash
# 1/4/26

# script to assemble genomes of the twelve using hifiasm ONT mode

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=361g
#SBATCH --time=48:00:00
#SBATCH --job-name=ctenella12assemblies
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12

# setup env
source $HOME/.bash_profile
conda activate hifiasm_0.25.0

# setup array config
CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
echo "slurm array = $SLURM_ARRAY_TASK_ID is running using hifiasm v0.25.0 to assemble reads filtered to >3.5kb for sample: $ind"

# make directory for the assembly & move to it
mkdir -p /gpfs01/home/mbzlld/data/ctenella/the_twelve/assemblies/barcode${ind}
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/assemblies/barcode${ind}

# run hifiasm on the simplex reads with the new --ont flag to generate the assembly
hifiasm \
-t 94 \
--ont \
-o barcode${ind}_ONTasm \
/gpfs01/home/mbzlld/data/ctenella/the_twelve/fastqs/barcode${ind}_3.5kb.fastq.gz

# convert the final assembly to fasta format
awk '/^S/{print ">"$2;print $3}' barcode${ind}_ONTasm.bp.p_ctg.gfa > barcode${ind}_ONTasm.bp.p_ctg.fasta

# deactivate conda
conda deactivate

