#!/bin/bash
# Laura Dean
# 6/2/26

# script to install and use kraken2 to classify reads or contings from ctenella sequencing

#SBATCH --job-name=kraken2
#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=500g
#SBATCH --time=12:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


##  # download the standard database (did with tmux & srun)
##  cd /gpfs01/home/mbzlld/data/ctenella/kraken2/database
##  wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_20240112.tar.gz
##  tar -xvzf k2_standard_20240112.tar.gz
##  
##  # download the core_nt database (did with tmux & srun)
##  cd /gpfs01/home/mbzlld/data/databases/core_nt
##  wget https://genome-idx.s3.amazonaws.com/kraken/k2_core_nt_20251015.tar.gz
##  tar -xvzf k2_core_nt_20251015.tar.gz


#conda create --name kraken2 bioconda::kraken2
source $HOME/.bash_profile
conda activate kraken2

# set variables
#DBNAME=/gpfs01/home/mbzlld/data/databases/core_nt/k2_core_nt_20251015
DBNAME=/share/deepseq/matt/Ctenella/kraken_core
#to_classify=Ctenella_sup.fastq.gz
to_classify=/share/deepseq/laura/ctenella/Ctenella_sup.fastq.gz

cd /share/deepseq/laura/ctenella/kraken2

##  # run kraken2 to classify reads or assembly contigs
##  kraken2 \
##  --db $DBNAME \
##  --threads 40 \
##  --use-names \
##  --report kraken_report \
##  $to_classify | gzip > Ctenella_sup_classified.fastq.gz

# Trying with the K2 wrapper instead since the above ran but only produced a 5GB output file!?

k2 classify \
--db $DBNAME \
--threads 40 \
--classified-out Ctenella_sup_k2_classified.fastq \
--report k2_report \
--use-names \
--log k2_log \
$to_classify

conda deactivate



