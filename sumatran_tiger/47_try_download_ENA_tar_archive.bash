#!/bin/bash
# 21/6/26

# script to download raw pod5s submitted to ENA as a tar archive

#SBATCH --job-name=ENA_raw_file_download
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=15g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# move to download location
cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/tar_test


# try to download the archive
wget -c --tries=0 --waitretry=60 --read-timeout=300 \
ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR128/ERR12834992/sumatran_tiger_P4_pod5s.tar.gz


# print that the command completed
echo "wget command has finished"


# calculate md5
md5sum sumatran_tiger_P4_pod5s.tar.gz > P4.md5


