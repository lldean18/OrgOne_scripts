#!/bin/bash
# Laura Dean
# 2/2/26

# Script to create the metamaps database for searching ctenella reads for symbiont DNA

#SBATCH --job-name=metamaps_make_DB
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50g
#SBATCH --time=68:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out




# set variables
wkdir=/gpfs01/home/mbzlld/data/ctenella/metamaps
cd $wkdir

# setup environment
source $HOME/.bash_profile
#conda create --name metamaps bioconda::metamaps -y
conda activate metamaps

# download the genomes you want to include
mkdir download
perl /gpfs01/home/mbzlld/software_bin/miniconda3/envs/metamaps/bin/downloadRefSeq.pl \
--seqencesOutDirectory download/refseq \
--taxonomyOutDirectory download/taxonomy \
--targetBranches archaea,bacteria,fungi

# ensure contig ids are annotated correctly
perl /gpfs01/home/mbzlld/software_bin/miniconda3/envs/metamaps/bin/annotateRefSeqSequencesWithUniqueTaxonIDs.pl \
--refSeqDirectory download/refseq \
--taxonomyInDirectory download/taxonomy \
--taxonomyOutDirectory download/taxonomy_uniqueIDs

# construct the metamaps database
mkdir databases
perl /gpfs01/home/mbzlld/software_bin/miniconda3/envs/metamaps/bin/buildDB.pl \
--DB databases/myDB \
--FASTAs download/refseq,hg38.primary.fna.with9606 \
--taxonomy download/taxonomy_uniqueIDs



