#!/bin/bash
# 16/6/26

# script to submit the pod5 tar archive for the snake-necked turtle to the ENA

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=30g
#SBATCH --time=100:00:00
#SBATCH --job-name=ENA_submission
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# make ENA submission #

# for the tar archive of pod5s
#curl --upload-file /gpfs01/home/mbzlld/data/OrgOne/turtle/chelodina_mccordi_mccordi_pod5s.tar.gz --user Webin-154:******** ftp://webin2.ebi.ac.uk

# for the basecalled bam
curl --upload-file /share/deepseq/org_one/SNT052/SUP_basecalls/turtle_SUP.bam --user Webin-154:******** ftp://webin2.ebi.ac.uk



