#!/bin/bash
# Laura Dean
# 8/4/24
# 8/12/25
# for running on Ada

# script to assemble genome with nextdenovo

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=168:00:00
#SBATCH --job-name=tig_nextdenovo
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

## load your bash environment for using conda
source $HOME/.bash_profile
## create a conda environment and install the software you want
#conda create --name nextdenovo -c conda-forge -c bioconda nextdenovo
## activate the conda environment
conda activate nextdenovo

# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger
input=/gpfs01/home/mbzlld/code_and_scripts/File_lists/sumatran_tiger_nextDenovo_input.fofn # set input files list you will make
config=/gpfs01/home/mbzlld/code_and_scripts/config_files/sumatran_tiger_nextDenovo_config.cfg # set the config file you will make
genome_size=2.4g
assembly_dir=${wkdir}/NextDenovo_asm

# prepare the input file
echo "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/ALL_simplex.fastq.gz" > $input

# prepare the config file
echo "[General]
job_type = local # here we use SGE to manage jobs possible options SGE, slurm, local, some others see man
job_prefix = nextDenovo
task = all
rewrite = yes
deltmp = yes
rerun = 3
parallel_jobs = 10
input_type = raw
read_type = ont # clr, ont, hifi
input_fofn = $input
workdir = $assembly_dir

[correct_option]
read_cutoff = 1k
genome_size = $genome_size # estimated genome size
seed_depth = 45
sort_options = -m 50g -t 8
minimap2_options_raw = -t 8 -K 5000M
correction_options = -p 30

[assemble_option]
minimap2_options_cns = -t 30 -k17 -w17 -K 1G
nextgraph_options = -a 1" > $config

#cluster_options=--cpus-per-task={cpu} --mem-per-cpu={vf} time_limited_option
#submit = sbatch -p hmemq --cpus-per-task=1 --mem-per-cpu=64g -o {out} -e {err} {script}




# assemble your genome from fastq files (using all pass and fail reads)
nextDenovo $config

# deactivate the conda environment
conda deactivate



