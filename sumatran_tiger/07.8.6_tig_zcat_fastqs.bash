#!/bin/bash
# Laura Dean
# 3/1/25
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=100g
#SBATCH --time=36:00:00
#SBATCH --job-name=tig_merge_fqs
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# combine the file with all simplex from simplex runs with the file containing duplex only reads extracted from the duplex runs
# doing this with zcat rather than cat even though its slower to ensure if there are problems with the file compressions there will be an error message
zcat \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_simplex_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_duplex.fastq.gz |
gzip > /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/simplex_simplex_and_duplex.fastq.gz


