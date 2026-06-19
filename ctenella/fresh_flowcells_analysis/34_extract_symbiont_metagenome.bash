#!/bin/bash
# 10/6/26

# script to filter the complete Ctenella assembly to remove everything classified as Scleractinia
# leaving the symbiont metegenome

#SBATCH --job-name=filter_asm
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=2:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
source $HOME/.bash_profile
conda activate kraken2
mkdir -p /gpfs01/home/mbzlld/data/ctenella/metagenome
cd /gpfs01/home/mbzlld/data/ctenella/metagenome


# extract all the reads that are not Scleractinia (i.e. are not coral) from the assembly
python /share/deepseq/laura/ctenella/extract_kraken_reads.py \
-s /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_classified.fasta \
-o ONTasm.bp.p_ctg_NOT_Scleractinia.fasta \
--exclude \
--taxid 6125 \
--include-children \
-k /gpfs01/home/mbzlld/data/ctenella/kraken2/k2_log \
--report /gpfs01/home/mbzlld/data/ctenella/kraken2/k2_report



conda deactivate



