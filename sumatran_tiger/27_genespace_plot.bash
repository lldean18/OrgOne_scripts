#!/bin/bash
# Laura Dean
# 14/3/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=genespace
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=1:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# install and load software
source $HOME/.bash_profile
conda create --name genespace bioconda::orthofinder=2.5.5 bioconda::mcscanx conda-forge::r-base r::rstudio -y
conda activate genespace
conda install r-devtools
conda install r-BiocManager
conda install r-gtable r-MASS r-Matrix r-cpp11 r-lattice

conda install r-base=4.4.1 # trying this

# ok trying again from scratch
conda create --name genespace2 bioconda::orthofinder=2.5.5 bioconda::mcscanx conda-forge::r-base=4.4.1 -y
conda activate genespace2
#conda install r-devtools r-BiocManager # this line wouldn't run because of a wierd orthofinder error try installing in R

R
install.packages("devtools")

# ok trying a fourth time from scratch
# first ran: conda config --remove channels defaults
# this removed some silly conflict warning. Then ran:
conda create --name genespace4 orthofinder=2.5.5 mcscanx r-base=4.4.1 r-devtools r-BiocManager bioconductor-biostrings -y
conda activate genespace4
R
devtools::install_github("jtlovell/GENESPACE")
BiocManager::install("rtracklayer")
library(GENESPACE)


#########################################################################
# to get my files in order:
# make the file structure and copy my fasta & gff files into it
mkdir ~/data/OrgOne/sumatran_tiger/genespace_ours/data
mkdir ~/data/OrgOne/sumatran_tiger/genespace_ours/data/DomesticCat
mkdir ~/data/OrgOne/sumatran_tiger/genespace_ours/data/hifiasm10
mkdir ~/data/OrgOne/sumatran_tiger/genespace_ours/data/RaftHifiasmAsm9

cp ~/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb_proteins.fasta ~/data/OrgOne/sumatran_tiger/genespace_ours/data/hifiasm10/
cp ~/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb_liftoff_genes.bed ~/data/OrgOne/sumatran_tiger/genespace_ours/data/hifiasm10/

cp ~/data/OrgOne/sumatran_tiger/raft_hifiasm_asm9/finalasm.bp.p_ctg_proteins.fasta ~/data/OrgOne/sumatran_tiger/genespace_ours/data/RaftHifiasmAsm9/
cp ~/data/OrgOne/sumatran_tiger/raft_hifiasm_asm9/finalasm.bp.p_ctg_liftoff_genes.bed ~/data/OrgOne/sumatran_tiger/genespace_ours/data/RaftHifiasmAsm9/


# To actually use it
conda activate genespace4
R
library(GENESPACE)





