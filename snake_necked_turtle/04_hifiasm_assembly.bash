#!/bin/bash
# 8/5/26

# script to assemble the snake-necked turtle genome using hifiasm ONT mode

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=361g
#SBATCH --time=80:00:00
#SBATCH --job-name=turtle_assembly
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
source $HOME/.bash_profile
conda activate hifiasm_0.25.0
cd /share/deepseq/org_one/SNT052
mkdir -p hifiasm
cd hifiasm

# run hifiasm on the simplex reads with the new --ont flag to generate the assembly
hifiasm \
-t 94 \
--ont \
-o turtle \
../SUP_basecalls/turtle_SUP.fastq.gz

# convert the final assembly to fasta format
awk '/^S/{print ">"$2;print $3}' turtle.bp.p_ctg.gfa > turtle.bp.p_ctg.fasta
awk '/^S/{print ">"$2;print $3}' turtle.bp.hap1.p_ctg.gfa > turtle.bp.hap1.p_ctg.fasta
awk '/^S/{print ">"$2;print $3}' turtle.bp.hap2.p_ctg.gfa > turtle.bp.hap2.p_ctg.fasta

# deactivate conda
conda deactivate

