#!/bin/bash
# 22/4/26

# script to run de-novo genome annotation using Augustus

#SBATCH --job-name=augustus_annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=17
#SBATCH --mem=360g
#SBATCH --time=100:00:00
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
##  
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/013/753/865/GCF_013753865.1_Amil_v2.1/GCF_013753865.1_Amil_v2.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/222/465/GCF_000222465.1_Adig_1.1/GCF_000222465.1_Adig_1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/571/385/GCF_002571385.2_Stylophora_pistillata_v1.1/GCF_002571385.2_Stylophora_pistillata_v1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/932/526/225/GCF_932526225.1_jaNemVect1.1/GCF_932526225.1_jaNemVect1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/964/030/605/GCF_964030605.1_jaAcrPala1.3/GCF_964030605.1_jaAcrPala1.3_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/036/669/905/GCF_036669905.1_ASM3666990v1/GCF_036669905.1_ASM3666990v1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/958/299/795/GCF_958299795.1_jaPorLute2.1/GCF_958299795.1_jaPorLute2.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/036/669/915/GCF_036669915.1_ASM3666991v2/GCF_036669915.1_ASM3666991v2_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/964/199/315/GCF_964199315.1_jaOrbFran1.1/GCF_964199315.1_jaOrbFran1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/052/425/735/GCF_052425735.1_crgOcupat/GCF_052425735.1_crgOcupat_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/036/669/935/GCF_036669935.1_ASM3666993v2/GCF_036669935.1_ASM3666993v2_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/036/669/925/GCF_036669925.1_ASM3666992v2/GCF_036669925.1_ASM3666992v2_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/001/417/965/GCF_001417965.1_Aiptasia_genome_1.1/GCF_001417965.1_Aiptasia_genome_1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/002/042/975/GCF_002042975.1_ofav_dov_v1/GCF_002042975.1_ofav_dov_v1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/003/704/095/GCF_003704095.1_ASM370409v1/GCF_003704095.1_ASM370409v1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/009/602/425/GCF_009602425.1_ASM960242v1/GCF_009602425.1_ASM960242v1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/977/016/875/GCF_977016875.1_jaPavDecu1.1/GCF_977016875.1_jaPavDecu1.1_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/004/324/835/GCF_004324835.1_DenGig_1.0/GCF_004324835.1_DenGig_1.0_protein.faa.gz
##  wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/021/976/095/GCF_021976095.1_XeniaSp_v1/GCF_021976095.1_XeniaSp_v1_protein.faa.gz
##  
##  # concatenate downloaded protein files
##  cat *_protein.faa.gz > anthozoa_proteins.faa.gz
##  gunzip anthozoa_proteins.faa.gz
##  
##  # remove individual files
##  rm GCF*
##  
##  # move back to wkdir
##  cd /gpfs01/home/mbzlld/data/ctenella/braker 



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
	--prot_seq=training_proteins/anthozoa_proteins.faa \
	--gff3 \
        --workingdir=${WKDIR} \
        --threads 16 &> ${WKDIR}/braker3.log


#        --busco_lineage anthozoa_odb12 \
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


