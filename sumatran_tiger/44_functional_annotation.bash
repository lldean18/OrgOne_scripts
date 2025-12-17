#!/bin/bash
# Laura Dean
# 16/12/25
# script written for running on the UoN HPC Ada

# script to perform functional annotation following de novo structural annotation

#SBATCH --job-name=annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50g
#SBATCH --time=48:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# setup environment
source $HOME/.bash_profile
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9
cd $wkdir

# set variables
protein_file_basename=proteins_from_gffread


# # extract protein sequences from structural annotation file
# conda activate gffread
# gffread ONTasm.bp.p_ctg_100kb.gff \
#   -g ONTasm.bp.p_ctg_100kb.fasta \
#   -y $protein_file_basename.faa
# conda deactivate
# # fix the not allowed characters by replacing them with X
# sed -i '/^>/! s/[^ACDEFGHIKLMNPQRSTVWY*]/X/g' proteins.faa

# run interproscan
#conda create --name interproscan bioconda::interproscan -y
conda activate interproscan
interproscan.sh \
  -i $protein_file_basename.faa \
  -f tsv,gff3,xml \
  -dp \
  -goterms \
  -iprlookup \
  -pa \
  -cpu 16
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




### merge all this information together
#conda create --name agat bioconda::agat -y
conda activate agat
agat_sp_add_functional_annotation.pl \
  --gff augustus.gff \
  --ipr proteins.faa.gff3 \
  -o augustus_functional.gff
conda deactivate





