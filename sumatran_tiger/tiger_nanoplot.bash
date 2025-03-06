#!/bin/bash
# Laura Dean
# 27/2/24

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=10g
#SBATCH --time=24:00:00
#SBATCH --job-name=tig_nanoplot
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# source bash profile for using conda
source $HOME/.bash_profile

# create conda env with nanoplot and nanoqc install
conda create --name nanoplot -c conda-forge -c bioconda nanoplot nanoqc

# activate conda env
conda activate nanoplot


# run nanoplot for each set of tiger fast5's
NanoPlot \
--threads 32 \
--outdir ~/data/OrgOne/sumartran_tiger/nanoplot \
--prefix  \
--plots kde dot \
--fastq 

# protocol for all tiger runs:
# simplex P1 - sequencing/		sequencing_PRO114_DNA_e8_2_400T					:FLO-PRO114M	:SQK-LSK114		:400 	n50 38.07 kb
# simplex P2 - sequencing/		sequencing_PRO114_DNA_e8_2_400T					:FLO-PRO114M	:SQK-LSK114		:400 	n50 28.88 kb
# simplex P3 - 					sequencing_PRO114_DNA_e8_2_400T_long_wind_down	:FLO-PRO114M	:SQK-RAD114		:400 	n50 86.6 kb
# simplex p4 - sequencing/		sequencing_PRO114_DNA_e8_2_400T					:FLO-PRO114M	:SQK-LSK114-XL	:400 	n50 42.92 kb
# duplex dup - sequencing/		sequencing_PRO114_DNA_e8_2_400T					:FLO-PRO114M	:SQK-LSK114		:400 	n50 20.65 kb
# duplex  P2 - krill_scripts/	sequencing_PRO114_DNA_e8_2_400K					:FLO-PRO114M	:SQK-LSK114		:400 	n50 30.41 kb
# duplex  P3 - krill_scripts/	sequencing_PRO114_DNA_e8_2_400K					:FLO-PRO114M	:SQK-LSK114		:400 	n50 1.03 kb
# duplex ns1 - krill_scripts/	sequencing_PRO114_DNA_e8_2_400K					:FLO-PRO114M	:SQK-LSK114		:400 	n50 21.48 kb
# duplex ns2 - krill_scripts/	sequencing_PRO114_DNA_e8_2_400K					:FLO-PRO114M	:SQK-LSK114		:400 	n50 26.33 kb

# pretty sure from this that the simplex P3 are the ultra long reads


