#!/bin/bash
# Laura Dean
# 24/11/26

# script to install and run BRAKER4 for genome annotation

#SBATCH --job-name=BRAKER4
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=17
#SBATCH --mem=360g
#SBATCH --time=100:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup env
conda activate tmux
tmux attach
module load singularity/3.8.5
#cd ~/software_bin
#git clone https://github.com/Gaius-Augustus/BRAKER4.git
cd /gpfs01/home/mbzlld/software_bin/BRAKER4
#pixi install
###  WARN cache for Repodata at /gpfs01/home/mbzlld/.cache/rattler/cache/repodata is on a network/parallel filesystem (NFS/SMB/FUSE/BeeGFS/Lustre/GPFS/CephFS), redirected to /tmp/pixi-cache-mbzlld/repodata for this run. Set [cache.repodata] in config.toml or PIXI_CACHE_DIR to override, or [cache.netfs-redirect] = "never" to keep the original path.
pixi shell
pixi add snakemake-executor-plugin-cluster-generic


##  # download the rfam database with: (only need to do this once)
##  # got these urls from the file /gpfs01/home/mbzlld/software_bin/BRAKER4/test_data/download_test_data.sh
##  cd /gpfs01/home/mbzlld/data/databases/rfam_db
##  wget -q "https://ftp.ebi.ac.uk/pub/databases/Rfam/15.1/Rfam.cm.gz" -O "Rfam.cm.gz"
##  gunzip Rfam.cm.gz
##  wget -q "https://ftp.ebi.ac.uk/pub/databases/Rfam/15.1/Rfam.clanin" -O "Rfam.clanin"


# move to the working directory and put everything that is needed for this run inside it
cd /gpfs01/home/mbzlld/data/ctenella/BRAKER4
# must have copied the assembly to here
# the training proteins dataset if using must also be here (we make it for ctenella below)
# and the config.ini file for which there is a template in the BRAKER4 github repo
# and the samples.csv file for which there is also a template in the BRAKER4 github repo 
# and copy the augustus config dir from a local install to augustus_config in your working dir with:
# cp -r /gpfs01/home/mbzlld/software_bin/miniconda3/envs/augustus/config /gpfs01/home/mbzlld/data/ctenella/BRAKER4/augustus_config
mkdir -p sge_logs # and make a directory for the log files to go in


##  # download protein sequences from other corals to train the annotation
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


# finally run the actual snakemake command in tmux (but just on a login node)
snakemake \
    --executor slurm \
    --default-resources slurm_partition="defq" \
    --jobs 40 \
    --printshellcmds \
    --snakefile /gpfs01/home/mbzlld/software_bin/BRAKER4/Snakefile \
    --use-singularity \
    --singularity-prefix /gpfs01/home/mbzlld/software_bin/singularity \
    --singularity-args "-B /gpfs01/home/mbzlld"




# cleanup env
module unload singularity/3.8.5



