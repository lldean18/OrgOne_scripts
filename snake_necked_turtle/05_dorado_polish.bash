#!/bin/bash
# 13/5/26

# script to polish the turtle assembly variations with dorado polish

#SBATCH --job-name=dorado_polish
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=361g
#SBATCH --time=100:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
source $HOME/.bash_profile
conda activate samtools1.22
assembly=/share/deepseq/org_one/SNT052/hifiasm/turtle_3.5kb.bp.p_ctg.fasta


# Align reads to a reference using dorado aligner, sort and index
dorado aligner $assembly /share/deepseq/org_one/SNT052/SUP_basecalls/turtle_SUP.bam |
samtools sort --threads 48 > ${assembly%.*}_mapped_reads.bam
samtools index ${assembly%.*}_mapped_reads.bam


# polish the draft assembly
dorado polish \
--threads 48 \
${assembly%.*}_mapped_reads.bam \
$assembly > ${assembly%.*}_polished.fasta


conda deactivate

