#!/bin/bash
# 22/4/26

# script to run de-novo genome annotation using Augustus

#SBATCH --job-name=augustus_annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=17
#SBATCH --mem=360g
#SBATCH --time=168:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
module load singularity/3.8.5
#cd ~/software_bin/singularity
#singularity build braker3.sif docker://teambraker/braker3:latest
cd /gpfs01/home/mbzlld/data/ctenella/braker
#singularity build braker3.sif docker://teambraker/braker3:latest

##  # download protein sequences from other corals to train the annotation
##  mkdir -p /gpfs01/home/mbzlld/data/ctenella/braker/training_proteins
##  cd /gpfs01/home/mbzlld/data/ctenella/braker/training_proteins
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/013/753/865/GCF_013753865.1_Amil_v2.1/GCF_013753865.1_Amil_v2.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/222/465/GCF_000222465.1_Adig_1.1/GCF_000222465.1_Adig_1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/571/385/GCF_002571385.2_Stylophora_pistillata_v1.1/GCF_002571385.2_Stylophora_pistillata_v1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/932/526/225/GCF_932526225.1_jaNemVect1.1/GCF_932526225.1_jaNemVect1.1_protein.faa.gz
##  # concatenate downloaded protein files
##  cat GCF_013753865.1_Amil_v2.1_protein.faa.gz GCF_932526225.1_jaNemVect1.1_protein.faa.gz GCF_000222465.1_Adig_1.1_protein.faa.gz GCF_002571385.2_Stylophora_pistillata_v1.1_protein.faa.gz > cnidaria_proteins.faa.gz
##  rm GCF_013753865.1_Amil_v2.1_protein.faa.gz GCF_932526225.1_jaNemVect1.1_protein.faa.gz GCF_000222465.1_Adig_1.1_protein.faa.gz GCF_002571385.2_Stylophora_pistillata_v1.1_protein.faa.gz

###  # make gene predictions with braker3
###  singularity exec braker3.sif braker.pl \
###    --AUGUSTUS_ab_initio \
###    --threads 16 \
###    --genome=../ctenella_chagius_asm.fasta \
###    --species=Ctenella_chagius \
###    --prot_seq=training_proteins/cnidaria_proteins.faa.gz \
###    --gff3


# trying with Sonals sif and code
WKDIR=/gpfs01/home/mbzlld/data/ctenella/braker

singularity exec -B ${WKDIR}:${WKDIR} braker3.sif braker.pl \
        --genome=ctenella_chagius_asm.fasta \
        --species=Ctenella_chagius \
	--prot_seq=cnidaria_proteins.faa \
        --busco_lineage actinopterygii_odb10 \
	--gff3 \
        --workingdir=${WKDIR} \
        --threads 16 &> ${WKDIR}/braker3.log


#        --AUGUSTUS_CONFIG_PATH=${OUTDIR} \
#  --PROTHINT_PATH=/gpfs01/home/mbzlld/software_bin/ProtHint/bin \

module unload singularity/3.8.5


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


