#!/bin/bash
# 10/4/26

# script to polish the ctenella assembly with dorado polish

#SBATCH --job-name=dorado_polish
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=150g
#SBATCH --time=100:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
source $HOME/.bash_profile
conda activate samtools1.22
assembly=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb.fasta


###  # Align reads to a reference using dorado aligner, sort and index
###  dorado aligner $assembly /share/deepseq/matt/Ctenella/Ctenella.sup.meth.bam |
###  samtools sort --threads 48 > ${assembly%.*}_mapped_reads.bam
###  samtools index ${assembly%.*}_mapped_reads.bam


# polish the draft assembly
dorado polish \
--threads 48 \
--RG 1a4a3b36-aa31-420d-acde-f8d38087de7a_dna_r10.4.1_e8.2_400bps_sup@v5.2.0 \
${assembly%.*}_mapped_reads.bam \
$assembly > ${assembly%.*}_polished_1.fasta

# polish the draft assembly again with the 2nd read group
dorado polish \
--threads 48 \
--RG b90d191e-d354-4888-a386-83de53d6f4c7_dna_r10.4.1_e8.2_400bps_sup@v5.2.0 \
${assembly%.*}_mapped_reads.bam \
${assembly%.*}_polished_1.fasta > ${assembly%.*}_polished_final.fasta


conda deactivate

