#!/bin/bash
# 31/3/26

# script to merge individual level vcf files output by clair3 for the 12 ctenella samples

#SBATCH --job-name=joint_genotype
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=180g
#SBATCH --time=80:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants

source $HOME/.bash_profile
#conda create --name glnexus bioconda::glnexus
conda activate glnexus

# merge and joint genotype the individual level vcfs
glnexus_cli \
  --config ~/github/OrgOne_scripts/ctenella/the_twelve/clair3.yml \
  --threads 32 \
  --trim-uncalled-alleles \
  /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants/*/merge_output.gvcf.gz > the_twelve.bcf



conda deactivate

###  module load bcftools-uoneasy/1.19-GCC-13.2.0
###  
###  
###  bcftools merge \
###  *.vcf.gz \
###   -Oz \
###  --threads 16 \
###  --write-index \
###  --output merged.vcf.gz
