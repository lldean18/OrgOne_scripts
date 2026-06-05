#!/bin/bash
# 5/6/2026


#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50g
#SBATCH --time=100:00:00
#SBATCH --job-name=ENA_bam_submission
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set bam file for upload
bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P1/20230111_1737_3D_PAM34692_e5400fa7/pod5/tig_P1_SUP_basecalls.bam


# submit the bam file to ENA
curl --upload-file $bam --user Webin-154:******** ftp://webin2.ebi.ac.uk

echo "finished submission for file $bam"


