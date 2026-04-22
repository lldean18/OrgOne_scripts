#!/bin/bash
# 22/4/26

# script to run de-novo genome annotation using Augustus

#SBATCH --job-name=augustus_annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=80g
#SBATCH --time=100:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
source $HOME/.bash_profile
cd /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/annotation

##  # download protein sequences from other corals to train the annotation
##  mkdir -p /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/annotation/training_proteins
##  cd /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/annotation/training_proteins
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/013/753/865/GCF_013753865.1_Amil_v2.1/GCF_013753865.1_Amil_v2.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/222/465/GCF_000222465.1_Adig_1.1/GCF_000222465.1_Adig_1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/571/385/GCF_002571385.2_Stylophora_pistillata_v1.1/GCF_002571385.2_Stylophora_pistillata_v1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/932/526/225/GCF_932526225.1_jaNemVect1.1/GCF_932526225.1_jaNemVect1.1_protein.faa.gz
##  # concatenate downloaded protein files
##  cat GCF_013753865.1_Amil_v2.1_protein.faa.gz GCF_932526225.1_jaNemVect1.1_protein.faa.gz GCF_000222465.1_Adig_1.1_protein.faa.gz GCF_002571385.2_Stylophora_pistillata_v1.1_protein.faa.gz > cnidaria_proteins.faa.gz
##  rm GCF_013753865.1_Amil_v2.1_protein.faa.gz GCF_932526225.1_jaNemVect1.1_protein.faa.gz GCF_000222465.1_Adig_1.1_protein.faa.gz GCF_002571385.2_Stylophora_pistillata_v1.1_protein.faa.gz

# make gene predictions with braker3
conda activate braker3
export PERL5LIB=/gpfs01/home/mbzlld/software_bin/miniconda3/envs/braker3/lib/perl5/site_perl:$PERL5LIB
braker.pl \
  --AUGUSTUS_ab_initio \
  --threads 16 \
  --PROTHINT_PATH=/gpfs01/home/mbzlld/software_bin/ProtHint/bin \
  --genome=../ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb_polished_1.fasta \
  --species=Ctenella_chagius \
  --prot_seq=training_proteins/cnidaria_proteins.faa.gz
conda deactivate

# not running this block because braker3 runs augustus anyway
###  # run augustus to annotate the genome assembly
###  # the assembly has to be in uncompressed fasta format
###  # human is the nearest species for mammals and should work reasonably well according to my research
###  #conda create --name augustus -c bioconda augustus=3.2.3
###  conda activate augustus
###  assembly=/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb_polished_1.fasta
###  augustus \
###  	--species=human \
###  	--noInFrameStop=true \
###  	--genemodel=complete \
###  	 --protein=on \
###  	$assembly > ${assembly%.*}_augustus.gff
###  conda deactivate


