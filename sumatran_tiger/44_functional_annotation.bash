#!/bin/bash
# Laura Dean
# 16/12/25
# script written for running on the UoN HPC Ada

# script to perform functional annotation following de novo structural annotation

#SBATCH --job-name=annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=100g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup environment
source $HOME/.bash_profile
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9
cd $wkdir

# set variables
protein_file_basename=ONTasm.bp.p_ctg_100kb_3

# # Hashing out as this bit already completed
# # extract protein sequences from structural annotation file
# conda activate gffread
# gffread $protein_file_basename.gff \
#   -g ONTasm.bp.p_ctg_100kb.fasta \
#   -y $protein_file_basename.faa
# conda deactivate
# # fix the not allowed characters by replacing them with X
# sed '/^>/! s/[^ACDEFGHIKLMNPQRSTVWY*]/X/g' $protein_file_basename.faa > ${protein_file_basename}_filtered.faa

# run interproscan
#conda create --name interproscan bioconda::interproscan -y
#conda activate interproscan
# conda install failed, trying with the install they suggest on website
#conda create --name interproscan2
conda activate interproscan2
#conda install python=3.8
#PATH=$PATH:/gpfs01/home/mbzlld/software_bin/miniconda3/envs/interproscan2/bin
#cd ~/software_bin
#mkdir interproscan
#cd interproscan
#wget https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.76-107.0/interproscan-5.76-107.0-64-bit.tar.gz
#wget https://ftp.ebi.ac.uk/pub/software/unix/iprscan/5/5.76-107.0/interproscan-5.76-107.0-64-bit.tar.gz.md5
#md5sum -c interproscan-5.76-107.0-64-bit.tar.gz.md5
#tar -pxvzf interproscan-5.76-107.0-*-bit.tar.gz
#cd interproscan-5.76-107.0
#python3 setup.py -f interproscan.properties
PATH=$PATH:/gpfs01/home/mbzlld/software_bin/interproscan/interproscan-5.76-107.0
#conda install openjdk=11
PATH=$PATH:/gpfs01/home/mbzlld/software_bin/miniconda3/envs/interproscan2/lib/jvm/bin


interproscan.sh \
  -i ${protein_file_basename}_filtered.faa \
  -f tsv,gff3,xml \
  -dp \
  -goterms \
  -iprlookup \
  -pa \
  -cpu 32
conda deactivate


# install the software for kegg
#conda create --name kofamscan bioconda::kofamscan -y
conda activate kofamscan
#conda install -c astrobiomike bit
# download the database
#curl -L -O ftp://ftp.genome.jp/pub/db/kofam/profiles.tar.gz
#tar -xzvf profiles.tar.gz && rm profiles.tar.gz
#curl -L -O ftp://ftp.genome.jp/pub/db/kofam/ko_list.gz
#gunzip ko_list.gz

# run the kegg analysis
# this ran successfully
exec_annotation \
	-p kegg_analysis/profiles/ \
	-k kegg_analysis/ko_list \
	--cpu 16 \
	-f detail-tsv \
	--tmp-dir ko-tmp \
	-o $protein_file_basename-ko-annotations.tsv \
	$protein_file_basename.faa

# filter results from kegg analysis
bit-filter-KOFamScan-results \
	-i $protein_file_basename-ko-annotations.tsv \
	-o $protein_file_basename-ko-annotations-filtered.tsv

conda deactivate

# filter the results to remove lines with no significant hits so I can count the significant hits
awk '$2 != "NA"' FS='\t' $protein_file_basename-ko-annotations-filtered.tsv > $protein_file_basename-ko-annotations-filtered-sighits.tsv



### blast proteins against curated databases
conda activate blast
# dowload and format the swissprot database
#cd ~/data/databases
#wget ftp://ftp.uniprot.org/pub/databases/uniprot/current_release/knowledgebase/complete/uniprot_sprot.fasta.gz
#gunzip uniprot_sprot.fasta.gz
#makeblastdb -in uniprot_sprot.fasta -dbtype prot -out swissprot
#cd $wkdir

# run blast
blastp \
	-query $protein_file_basename.faa \
	-db ~/data/databases/swissprot \
	-outfmt 6 \
	-evalue 1e-5 \
	-num_threads 16 > $protein_file_basename-blast-swissprot.tsv
conda deactivate

# filter the blast hits to retain only the top hit per gene
awk '!seen[$1]++' $protein_file_basename-blast-swissprot.tsv > $protein_file_basename-blast-swissprot-tophits.tsv
# filter the top hits to remove any with an e value greater than 0.05
awk '$11 <= 0.05' $protein_file_basename-blast-swissprot-tophits.tsv > $protein_file_basename-blast-swissprot-tophits-signif.tsv
# Note this didn't actually remove any - all top hits were significant


### merge all this information together
#conda create --name agat bioconda::agat -y
conda activate agat
agat_sp_add_functional_annotation.pl \
  --gff augustus.gff \
  --ipr proteins.faa.gff3 \
  -o augustus_functional.gff
conda deactivate





