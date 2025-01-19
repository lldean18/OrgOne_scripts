#!/bin/bash
# Laura Dean
# 10/1/25
# For running on the UoN HPC Ada


#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=24
#SBATCH --mem=100g
#SBATCH --time=5:00:00
#SBATCH --job-name=map_to_liger
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

####### PREPARE ENVIRONMENT #######
# create conda environment
#conda create --name last last -y
conda activate last

# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm10
assembly=ONTasm.bp.p_ctg.fasta
reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names.fasta.gz

# Create database from the reference genome
# -uRY128 combined flag - makes it faster but less sensitive: it'll miss tiny rearranged fragments. To find them, try -uRY4
# -uRY16 seemed to work well
uRY=128
lastdb \
	-P24 \
	-c \
	-uRY$uRY \
	${reference%.*.*}_db \
	$reference
echo "database created from reference genome with -uRY$uRY"
# -c
# -uRY128

# find score parameters for aligning the assembly to the reference
last-train \
	-P24 \
	--revsym \
	-C2 \
	${reference%.*.*}_db \
	$wkdir/$assembly > $wkdir/hc.train
echo "score parameters written"

# find and align similar sequences
lastal \
	-P24 \
	-D1e9 \
	-C2 \
	--split-f=MAF+ \
	-p $wkdir/hc.train \
	${reference%.*.*}_db $wkdir/$assembly > $wkdir/many-to-one.maf
echo "many to one alignments written"

# get one to one alignments
last-split \
	-r \
	$wkdir/many-to-one.maf > $wkdir/one-to-one.maf
echo "one to one alignments written"

# make a dotplot
last-dotplot \
	$wkdir/one-to-one.maf \
	$wkdir/dotplot.png
echo "dotplot written"

# -P = number of threads


conda deactivate

