#!/bin/bash
# Laura Dean
# 14/12/23

#SBATCH --partition=mmemq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=755g
#SBATCH --time=168:00:00
#SBATCH --job-name=diamond
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbzlld@exmail.nottingham.ac.uk

# load your bash profile for using conda
source $HOME/.bash_profile

# activate the conda environment
conda activate PacBio

# install diamond
#conda install -c conda-forge -c bioconda diamond
 
# set the number of the one remaining diamond run that failed to complete
number=01

# set enviornment variables
assembly=~/data/Rhino/assembly/draft_assembly.fasta
outdir=~/data/Rhino/diamond

# make the output directory if it doesn't already exist
#mkdir -p $outdir # can't really do this in an array!

        # run diamond
        diamond blastx \
                --verbose \
                --block-size 6000000000 \
                --index-chunks 1 \
                --query ${assembly%.*}.$number.fasta \
                --db ~/data/PacBio/blobtools/reference_proteomes.dmnd \
                --outfmt 6 qseqid staxids bitscore qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore \
                --sensitive \
                --max-target-seqs 1 \
                --evalue 1e-25 \
                --threads 40 \
                > $outdir/diamond_$number.out

conda deactivate


