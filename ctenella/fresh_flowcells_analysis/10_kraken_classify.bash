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


# well the log was written to stdout rather than the log file but I just copied it to the log file minus
# the last 3 lines which were information about how many reads were classified with the command
# head -n -3 slurm-kraken2-6051446.out > /share/deepseq/laura/ctenella/kraken2/k2_log

gzip Ctenella_sup_k2_classified.fastq

# 53668435 sequences (115276.64 Mbp) processed in 1018.647s (3161.2 Kseq/m, 6789.99 Mbp/m).
#  42580517 sequences classified (79.34%)
#  11087918 sequences unclassified (20.66%)

# calculate abundances for plotting with bracken
bracken \
-d $DBNAME \
-i k2_report \
-o reads.bracken.out \
-w reads.breport


# then use the .breport file in the shiny app here to make the plot: https://fbreitwieser.shinyapps.io/pavian/

conda deactivate

