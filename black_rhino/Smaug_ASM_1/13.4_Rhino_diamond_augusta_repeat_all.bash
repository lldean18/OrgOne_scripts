#!/bin/bash
# Laura Dean
# 16/2/24

#SBATCH --partition=mmemq
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=755g
#SBATCH --time=168:00:00
#SBATCH --job-name=diamond
#SBATCH --array=1-10
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbzlld@exmail.nottingham.ac.uk

# load your bash profile for using conda
source $HOME/.bash_profile

# activate the conda environment
conda activate PacBio

# install diamond
#conda install -c conda-forge -c bioconda diamond
 
# set the config file for your array
config=~/code_and_scripts/config_files/Rhino_diamond_array_config.txt

# extract the dataset variable from your config file
number=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)

# set enviornment variables
assembly=~/data/OrgOne/black_rhino/assembly/assembly.fasta
outdir=~/data/OrgOne/black_rhino/diamond


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


