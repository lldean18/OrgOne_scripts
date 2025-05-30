#!/bin/bash
# Laura Dean
# 10/5/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=5
#SBATCH --mem=361g
#SBATCH --time=100:00:00
#SBATCH --job-name=spider_monkey_nextpolish2
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

# set variables
species=brown_spider_monkey
wkdir=/share/StickleAss/OrgOne/${species}/${species}_flye_asm
config=$wkdir/run.cfg


# create conda environment for software install
#conda create --name nextpolish2
# activate conda environment
conda activate nextpolish2
# install nextpolish with conda
#conda install -c conda-forge -c bioconda nextpolish2

cd $wkdir

# prepare reads
fqs=$(find /share/StickleAss/OrgOne/${species}/basecalls -type f -name '*.fastq.gz')
echo "$fqs" > lgs.fofn
# create the run config file
echo "[General]
job_type = local # here we use SGE to manage jobs possible options SGE, slurm, local, some others see man
job_prefix = nextPolish
task = best
rewrite = yes
rerun = 2
parallel_jobs = 10
multithread_jobs = 5
genome = ./assembly.fasta #genome file
genome_size = auto
workdir = ./01_rundir
polish_options = -p {multithread_jobs}

[lgs_option]
lgs_fofn = ./lgs.fofn
lgs_options = -min_read_len 1k -max_depth 100
lgs_minimap2_options = -x map-ont" > $config


# run nextpolish
nextPolish2 $config

# deactivate conda environment
conda deactivate


