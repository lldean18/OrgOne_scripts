#!/bin/bash
# 24/4/26

# script to build unrooted maximum likelihood phylogeny for ctenella

#SBATCH --job-name=raxml-ng
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50g
#SBATCH --time=24:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
source $HOME/.bash_profile
#conda create -n raxmlng bioconda::raxml-ng
conda activate raxmlng
mkdir -p /gpfs01/home/mbzlld/data/ctenella/the_twelve/raxmlng

# # convert the twelve VCF to phylip format
# cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants
# python ~/software_bin/vcf2phylip.py --fasta --input the_twelve_Q30_DP10_SNP_mis1_maf0.1.vcf.gz
# mv the_twelve_Q30_DP10_SNP_mis1_maf0.1.min4.phy the_twelve_Q30_DP10_SNP_mis1_maf0.1.phy
# mv the_twelve_Q30_DP10_SNP_mis1_maf0.1.min4.fasta the_twelve_Q30_DP10_SNP_mis1_maf0.1.fasta

# convert the thirteen VCF to phylip format
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants
python ~/software_bin/vcf2phylip.py --input the_thirteen_Q30_DP10_SNP_mis1_maf0.1.vcf.gz
mv the_thirteen_Q30_DP10_SNP_mis1_maf0.1.min4.phy the_thirteen_Q30_DP10_SNP_mis1_maf0.1.phy

# # remove invariant sites from the alignment
# snp-sites -p /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants/the_twelve_Q30_DP10_SNP_mis1_maf0.1.fasta \
# > /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants/the_twelve_Q30_DP10_SNP_mis1_maf0.1_onlyvar.phy

# # check raxml can read the input file correctly
# raxml-ng --check --msa the_twelve_Q30_DP10_SNP_mis1_maf0.1.phy --model GTR+G --prefix R1

cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/raxmlng

# make bootstrap trees
raxml-ng \
  --msa /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants/the_thirteen_Q30_DP10_SNP_mis1_maf0.1.phy \
  --model GTR+G \
  --seed 2 --threads 16 \
  --bootstrap --bs-trees 1000 \
  --prefix Raxml_thirteen_GTR-G_BS1000

# make a majority rule consensus tree from the bootstrap replicates
raxml-ng --consense --tree Raxml_thirteen_GTR-G_BS1000.raxml.bootstraps


# # make tree and bootstrap in same step
# raxml-ng \
#   --all \
#   --msa /gpfs01/home/mbzlld/data/ctenella/the_twelve/variants/the_twelve_Q30_DP10_SNP_mis1_maf0.1_onlyvar.phy \
#    --model GTR+G \ 
#   --prefix Raxml_GTR-G_2 \
#   --seed 2 --threads 16 \
#   --bs-metric fbp,tbe




conda deactivate

