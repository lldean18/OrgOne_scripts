#!/bin/bash






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

# if the databases dir doesn't exist, make it

# construct the metamaps database
perl /gpfs01/home/mbzlld/software_bin/miniconda3/envs/metamaps/bin/buildDB.pl \
--DB databases/myDB \
--FASTAs download/refseq,hg38.primary.fna.with9606 \
--taxonomy download/taxonomy_uniqueIDs



