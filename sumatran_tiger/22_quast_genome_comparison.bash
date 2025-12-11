#!/bin/bash
# Laura Dean
# 21/2/25
# 3/4/25
# 10/12/25
# script written for running on the UoN HPC Ada

# Script to run Quast to compare genome assemblies

#SBATCH --job-name=quast
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=360g
#SBATCH --time=60:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set variables
#reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta
#annotation=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces_liftoff.gff

reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome.fa
annotation=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0r1.0.2.gff

wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger


source $HOME/.bash_profile
# install and activate software
#conda create --name quast quast
conda activate quast

# compare genomes
python /gpfs01/home/mbzlld/software_bin/miniconda3/envs/quast/bin/quast \
	--threads 64 \
	--eukaryote \
	-r $reference \
	-g $annotation \
	-o $wkdir/quast9 \
	$wkdir/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta \
	$wkdir/hifiasm_asm13/ONTasm.bp.p_ctg_100kb.fasta \
	$wkdir/hifiasm_asm11/ONTasm.bp.p_ctg_100kb.fasta \
	$wkdir/flye_asm5/assembly_100kb.fasta \
	$wkdir/NextDenovo_asm/03.ctg_graph/nd.asm.fasta \
	$wkdir/raft_hifiasm_asm12/finalasm.bp.p_ctg_100kb.fasta \
	$wkdir/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta

# scaffolded cat
#	$wkdir/domestic_cat_reference/AnAms1.0.genome.fa \
# unscaffolded cat
#	$wkdir/domestic_cat_reference/AnAms1.0.genome_split_contigs.fa \
# scaffolded liger
	$wkdir/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta \
# unscaffolded liger
#	$wkdir/liger_reference/GCA_018350195.2_scaff_only_names_split_contigs_100kb.fasta \
# HiC scaffolded asm
#	$wkdir/HiC2/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag/ragtag.scaffold.fasta \
# simplex only asm with hifiasm no ONT
# Hifiasm duplex with hifiasm no ONT
# Flye ASM
# NextDenovo asm
# HERRO_RAFT_HIFIASM asm
# HIFIASM ONT

conda deactivate

