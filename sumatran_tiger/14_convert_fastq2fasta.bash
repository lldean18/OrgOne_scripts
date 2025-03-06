#!/bin/bash
# Laura Dean
# 21/5/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50g
#SBATCH --time=6:00:00
#SBATCH --job-name=fq2fa
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

file=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_duplex.fastq.gz

# convert fastq to fasta using seqkit
#conda create --name seqkit
conda activate seqkit
#conda install -c conda-forge -c bioconda seqkit
seqkit fq2fa \
-o ${file%.*.*}.fa.gz \
--threads 8 \
$file
conda deactivate


# remove everything after the first space on every line (this should get rid of the @ symbols in the
# headers that I think are causing a problem!)
cp ${file%.*.*}.fa.gz ${file%.*.*}.fa.gz~
gzip -cd ${file%.*.*}.fa.gz~ | sed 's/\s.*//' | gzip > ${file%.*.*}.fa.gz




