#!/bin/bash
# Laura Dean
# 2/5/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=80g
#SBATCH --time=100:00:00
#SBATCH --job-name=spider_monkey_nextpolish
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

# set variables
species=brown_spider_monkey
wkdir=/share/StickleAss/OrgOne/${species}
assembly=$wkdir/${species}_flye_asm/assembly.fasta
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/${species}_nextpolish_run.cfg


# create conda environment for software install
#conda create --name nextpolish
# activate conda environment
conda activate nextpolish
# install nextpolish with conda
#conda install -c conda-forge -c bioconda nextpolish


# make a directory for the polishing
mkdir -p $wkdir/nextpolish
# move to the analysis directory
cd $wkdir/nextpolish



# prepare reads
fqs=$(find $wkdir/basecalls -type f -name '*.fastq.gz')
echo "$fqs" > lgs.fofn
# create the run config file
echo "[General]
job_type = local # here we use SGE to manage jobs possible options SGE, slurm, local, some others see man
job_prefix = nextPolish
task = best
rewrite = yes
rerun = 3
parallel_jobs = 10
multithread_jobs = 5
genome = $assembly #genome file
genome_size = auto
workdir = $wkdir/nextpolish/01_rundir
polish_options = -p {multithread_jobs}

[lgs_option]
lgs_fofn = $wkdir/nextpolish/lgs.fofn
lgs_options = -min_read_len 1k -max_depth 100
lgs_minimap2_options = -x map-ont" > $config


# run nextpolish
nextPolish $config

# deactivate conda environment
conda deactivate


