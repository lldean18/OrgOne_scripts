#!/bin/bash
# Laura Dean
# 19/2/26
# For running on the UoN HPC Ada

# script to align our ctenella assembly with the published Acropora cervicornis coral assembly
# published asm page here: https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_964034985.1/


####### PREPARE ENVIRONMENT #######
conda activate tmux
tmux new -t last
# OR to reattach
tmux attach -t last
srun --partition defq --cpus-per-task 24 --mem 100g --time 18:00:00 --pty bash
source $HOME/.bash_profile
#conda create --name last last -y
conda activate last


######### Download Acropora cervicornis assembly ##########
mkdir -p ~/data/ctenella/Acropora_cervicornis
cd ~/data/ctenella/Acropora_cervicornis
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCA/964/034/985/GCA_964034985.1_jaAcrCerv1.1/GCA_964034985.1_jaAcrCerv1.1_genomic.fna.gz


####### SET VARIABLES #######
reference=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_100kb.fasta
assembly=GCA_964034985.1_jaAcrCerv1.1_genomic.fna.gz



####### RUN ANALYSIS ########
# -P = number of threads
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

# find score parameters for aligning the assembly to the reference
last-train \
	-P24 \
	--revsym \
	-C2 \
	${reference%.*.*}_db \
	$assembly > ${assembly%.*}hc.train

# find and align similar sequences
lastal \
	-P24 \
	-D1e9 \
	-C2 \
	--split-f=MAF+ \
	-p ${assembly%.*}hc.train \
	${reference%.*.*}_db $assembly > ${assembly%.*}many-to-one.maf

# get one to one alignments
last-split \
	-r \
	${assembly%.*}many-to-one.maf > ${assembly%.*}one-to-one.maf

# make a dotplot
last-dotplot \
--verbose \
--rot1=v \
--rot2=h \
--fontsize=10 \
--sort1=3 \
--sort2=1 \
${assembly%.*}one-to-one.maf \
${assembly%.*}dotplot.png

## # specify which of the fragments to include in the plot
## last-dotplot \
## --verbose \
## --rot1=v \
## --rot2=h \
## --fontsize=10 \
## -1 'NC_133187*' \
## -1 'NC_133190*' \
## -2 'ptg000012*' \
## ${assembly%.*}one-to-one.maf \
## ${assembly%.*}dotplot2.png 


################################################################
################################################################

SCORE=2500

# get one to one alignments with filtering for slignment score
last-split \
        -r \
        --score=$SCORE \
        ${assembly%.*}many-to-one.maf > ${assembly%.*}one-to-one_score$SCORE.maf

# make a dotplot
last-dotplot \
--verbose \
--rot1=v \
--rot2=h \
--fontsize=10 \
--sort1=3 \
--sort2=1 \
${assembly%.*}one-to-one_score$SCORE.maf \
${assembly%.*}dotplot_score$SCORE.png


conda deactivate
