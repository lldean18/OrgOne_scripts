#!/bin/bash
# 10/4/26

# script to submit the Ctenella pod5 tarball for the high coverage individual used to
# generate the reference assembly to ENA

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50g
#SBATCH --time=100:00:00
#SBATCH --job-name=ENA_submission
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# make ENA submission
curl --upload-file /share/deepseq/laura/ctenella/ctenella_chagius_pod5s.tar.gz --user Webin-154:******** ftp://webin2.ebi.ac.uk



