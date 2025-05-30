#!/bin/bash
# Laura Dean
# 14/12/23

#SBATCH --partition=LocalQ
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=24
#SBATCH --mem=40g
#SBATCH --time=200:00:00
#SBATCH --job-name=diamond
#SBATCH --output=/home/mbzlld/slurm-%x-%j.out
#SBATCH --mail-type=ALL
#SBATCH --mail-user=mbzlld@exmail.nottingham.ac.uk
#SBATCH --array=1-10

# load your bash profile for using conda
source $HOME/.bash_profile


# activate the conda environment
conda activate assembly_tools

# install diamond
#conda install -c conda-forge -c bioconda diamond

# copy levi's database from augusta to smaug
##rsync -rvh --progress mbzlld@login002.augusta.nottingham.ac.uk:~/data/PacBio/blobtools/reference_proteomes.dmnd /data/test_data/diamond_databases/ # couldn't authenticate from smaug
#rsync -rvh --progress ./reference_proteomes.dmnd mbzlld@10.157.200.14:/data/test_data/diamond_databases/ # from augusta


# set the config file for your array
config=~/config/Rhino_diamond_array_config.txt

# extract the dataset variable from your config file
number=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $config)

# set enviornment variables
assembly=/data/test_data/org_one/black_rhino/black_rhino_asm_002/00-assembly/draft_assembly.fasta
outdir=/data/test_data/org_one/black_rhino/black_rhino_asm_002/diamond

# make the output directory if it doesn't already exist
#mkdir -p $outdir # can't really do this in an array!

        # run diamond
        diamond blastx \
                --query ${assembly%.*}.$number.fasta \
                --db /data/test_data/diamond_databases/reference_proteomes_Levi.dmnd \
                --outfmt 6 qseqid staxids bitscore qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore \
                --sensitive \
                --max-target-seqs 1 \
                --evalue 1e-25 \
                --threads 24 \
                > $outdir/diamond_$number.out

conda deactivate

