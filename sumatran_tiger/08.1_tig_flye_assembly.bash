#!/bin/bash
# Laura Dean
# 25/3/24
# for running on Ada

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=168:00:00
#SBATCH --job-name=tig_flye
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load your bash environment for using conda
source $HOME/.bash_profile

# set variables
species=sumatran_tiger # set the species
wkdir=/gpfs01/home/mbzlld/data/OrgOne/${species} # set the working directory

# # generate the list of fastq files and paste them after the --nano-hq flag below
# find $wkdir/basecalls -type f -name '*calls.fastq.gz' # set the full fastq file name and further path

## create a conda environment and install the software you want
#conda create --name flye -c conda-forge -c bioconda flye

# activate the conda environment
conda activate flye

# assemble your genome from fastq files (using all pass and fail reads)
flye \
--threads 96 \
--iterations 5 \
-o $wkdir/${species}_asm \
--nano-hq /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P3/20230119_1328_1G_PAM34749_b65364c2/pod5/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/pod5_fail/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/pod5_pass/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/pod5_fail/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/pod5_pass/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/pod5_fail/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/pod5_pass/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P1/20230111_1737_3D_PAM34692_e5400fa7/pod5/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/pod5_fail/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/pod5_pass/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/pod5_fail/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/pod5_pass/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P4/20230207_1523_1C_PAO11037_b4b86f62/pod5_fail/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P4/20230207_1523_1C_PAO11037_b4b86f62/pod5_pass/SUPlatest_calls.fastq.gz /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P2/20230113_1342_3F_PAM70827_70386f08/pod5/SUPlatest_calls.fastq.gz

# deactivate the conda environment
conda deactivate

