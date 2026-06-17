#!/bin/bash
# 1/6/26

# script to download raw pod5s submitted to ENA as a tar archive

#SBATCH --job-name=ENA_raw_file_download
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=10g
#SBATCH --time=80:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set the run accession number for the file you wish to download
#accession=ERR12834988
accession=ERR12834986
#accession=ERR12834987

# move to download location
cd /gpfs01/home/mbzlld/data/OrgOne/camel/pod5s

###### get the ftp file location for the file you want to download using the accession number
curl "https://www.ebi.ac.uk/ena/portal/api/filereport?accession=$accession&result=read_run&fields=submitted_ftp,submitted_format&format=tsv" > ftp_path.txt
# modify the tsv file so that it contains only the url
cut -f2 ftp_path.txt > tmp && mv tmp ftp_path.txt # remove the first column of accessions
sed -i '1d' ftp_path.txt # remove header lines
sed -i 's/;/\n/g' ftp_path.txt # if there are multiple urls on the same line (e.g.) for paired forward and reverse reads split them onto single lines


###### download the files from the urls
#wget --input-file=ftp_path.txt
#echo "wget command has finished"
curl -O "$(cat ftp_path.txt)"


###  ####### now extract the tarball
###  # (get the file name first)
###  tarball=$(cat ftp_path.txt)
###  tarball=${tarball##*/}
###  tar -xvzf $tarball

####### now delete the tarball
# feels to risky to run in a job!
#rm -r $tarball



##############################
# giving up and trying with srun so I can see what is going on
# srun --partition defq --cpus-per-task 1 --mem 20g --time 80:00:00 --pty bash

source $HOME/.bash_profile
cd /gpfs01/home/mbzlld/data/OrgOne/camel/pod5s
wget --input-file=ftp_path.txt



