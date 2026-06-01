#!/bin/bash
# 13/5/26

# script to polish the turtle assembly variations with dorado polish

#SBATCH --job-name=dorado_polish
#SBATCH --partition=ampereq
#SBATCH --gres=gpu:A100-full:1
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=256g
#SBATCH --time=130:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
source $HOME/.bash_profile
module load cuda-12.2.2
conda activate samtools1.22
#assembly=/share/deepseq/org_one/SNT052/hifiasm/turtle_3.5kb.bp.p_ctg.fasta
assembly=/share/deepseq/org_one/SNT052/hifiasm/turtle.bp.p_ctg.fasta


##  # Align reads to a reference using dorado aligner, sort and index
##  dorado aligner $assembly /share/deepseq/org_one/SNT052/SUP_basecalls/turtle_SUP.bam |
##  samtools sort --threads 48 > ${assembly%.*}_mapped_reads.bam
##  samtools index ${assembly%.*}_mapped_reads.bam


# polish the draft assembly
dorado polish \
--threads 48 \
--device cuda:all \
${assembly%.*}_mapped_reads.bam \
$assembly > /share/deepseq/org_one/SNT052/dorado_polish/$(basename ${assembly%.*})_polished.fasta


module unload cuda-12.2.2
conda deactivate

