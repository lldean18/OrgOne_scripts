#!/bin/bash
# Laura Dean
# 19/12/25
# script written for running on the UoN HPC Ada

# script to perform functional annotation following de novo structural annotation
# all separate parts were run in a tmux window with srun
conda activate tmux
tmux new -t annotation
srun --partition defq --cpus-per-task 16 --mem 80g --time 12:00:00 --pty bash



# setup environment
source $HOME/.bash_profile
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag
cd $wkdir

# set variables
protein_file_basename=ONTasm.bp.p_ctg_100kb_3
protein_file_basename=ragtag.scaffolds_only_augustus


#############################################################################
#############################################################################


# extract protein sequences from structural annotation file
conda activate gffread
gffread $protein_file_basename.gff \
  -g ${protein_file_basename%_*}.fasta \
  -y $protein_file_basename.faa
conda deactivate
# fix the not allowed characters by replacing them with X
# this wasn't actually necessary in the end because it didn't filter anything out!
#sed '/^>/! s/[^ACDEFGHIKLMNPQRSTVWY*]/X/g' $protein_file_basename.faa > ${protein_file_basename}_filtered.faa

# filter the proteins in the fasta file to retain only those with at least 2 exons and >= 200 amino acids
conda activate python3.12
python 46_filter_augustus_proteins.py
conda deactivate
# then should proceed to run downstream things with the filtered fasta
# but since I ran them already on the unfiltered fasta I will instead extract the fasta headers that were thrown out and remove them
# from downstream outputs
comm -23 \
  <(grep '^>' $protein_file_basename.faa | sed 's/^>//' | cut -d' ' -f1 | sort) \
  <(grep '^>' ${protein_file_basename}_filtered.faa | sed 's/^>//' | cut -d' ' -f1 | sort) > proteins_to_remove.txt
# make a version of this file that is the gene names rather than protein names
sed 's/.t1//' proteins_to_remove.txt > genes_to_remove.txt
sed -i 's/^/# start gene /' genes_to_remove.txt # add what will be before the gene name on the first line to remove from the gff

# then filter the gff predictions to remove these dubious proteins
# remove every line that matches any of the lines in the genes to remove file and every line after it up to and including a line that is ###
awk '
NR==FNR {rm[$0]; next}
{
    if ($0 in rm) skip=1
    if (!skip) print
    if (skip && $0=="###") skip=0
}
' genes_to_remove.txt $protein_file_basename.gff > ${protein_file_basename}_badrm.gff


#############################################################################
#############################################################################

srun --partition defq --cpus-per-task 32 --mem 100g --time 24:00:00 --pty bash
source $HOME/.bash_profile
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag
cd $wkdir
protein_file_basename=ragtag.scaffolds_only_augustus

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

# run interproscan
interproscan.sh \
  -i ${protein_file_basename}_filtered.faa \
  -f tsv,gff3,xml \
  -dp \
  -goterms \
  -iprlookup \
  -pa \
  -cpu 32
conda deactivate

# clean up the output
awk '
BEGIN { FS=OFS="\t" }

{
    prot = $1
    analysis = $4
    sig = $5
    ipr = $12
    ipr_desc = $13
    go = $14

    # Clean GO column
    if (go != "-" && go != "--") {
        gsub(/\([^)]*\)/, "", go)   # remove "(PANTHER)"
    } else {
        go = "-"
    }

    keep = 0

    # Keep InterPro rows
    if (ipr ~ /^IPR[0-9]+/) keep = 1

    # Keep Pfam rows
    if (analysis == "Pfam" || sig ~ /^PF[0-9]+/) keep = 1

    # Keep GO-only rows
    if (go ~ /GO:[0-9]+/) keep = 1

    if (keep) {
        print prot, analysis, sig, ipr, ipr_desc, go
    }
}
' ${protein_file_basename}_filtered.faa.tsv > ${protein_file_basename}_filtered.faa_clean.tsv

# remove the proteins not good enough to keep retrospectively
awk -F'\t' 'NR==FNR {a[$1]; next} !($1 in a)' proteins_to_remove.txt ${protein_file_basename}_filtered.faa_clean.tsv > ${protein_file_basename}_filtered.faa_clean_badrm.tsv

# count the number of genes with GO terms assigned to them
grep "GO:" ${protein_file_basename}_filtered.faa_clean.tsv | cut -f1 | sort -u | wc -l
# 17,339
grep "GO:" ${protein_file_basename}_filtered.faa_clean_badrm.tsv | cut -f1 | sort -u | wc -l
# 14,962 (for the unscaffolded asm)
# 14,935 (for the scaffolded asm)

#############################################################################
#############################################################################

srun --partition defq --cpus-per-task 16 --mem 80g --time 12:00:00 --pty bash
source $HOME/.bash_profile
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag
cd $wkdir
protein_file_basename=ragtag.scaffolds_only_augustus

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

# remove the proteins not good enough to keep retrospectively
awk -F'\t' 'NR==FNR {a[$1]; next} !($1 in a)' proteins_to_remove.txt $protein_file_basename-ko-annotations-filtered-sighits.tsv > $protein_file_basename-ko-annotations-filtered-sighits_badrm.tsv

# count the genes that were assigned a KO pathway
cat $protein_file_basename-ko-annotations-filtered-sighits.tsv | wc -l # then minus 1 for header line
# 16,084
cat $protein_file_basename-ko-annotations-filtered-sighits_badrm.tsv | wc -l # then minus 1 for header line
# 14,065 (for the unscaffoled asm)
# 14,074 (for the scaffolded asm)

#############################################################################
#############################################################################

srun --partition defq --cpus-per-task 16 --mem 80g --time 12:00:00 --pty bash
source $HOME/.bash_profile
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag
cd $wkdir
protein_file_basename=ragtag.scaffolds_only_augustus

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

# remove the proteins not good enough to keep retrospectively
awk -F'\t' 'NR==FNR {a[$1]; next} !($1 in a)' proteins_to_remove.txt $protein_file_basename-blast-swissprot-tophits-signif.tsv > $protein_file_basename-blast-swissprot-tophits-signif_badrm.tsv

# count the genes that had a blast hit in the swissprot databasse
cat $protein_file_basename-blast-swissprot-tophits-signif.tsv | wc -l
# 24,906
cat $protein_file_basename-blast-swissprot-tophits-signif_badrm.tsv | wc -l
# 20,604
# 20,511

#############################################################################
#############################################################################

### merge all the results into a single gff annotation file and a single table
conda activate python3.12
python 45_merge_annotations.py
conda deactivate





#############################################################################
#############################################################################

## # DIDNT RUN THIS IN THE END DECIDED WE HAVE ENOUGH
## ### Try also with eggnog mapper
## #conda create --name eggnog bioconda::eggnog-mapper
## conda activate eggnog
## 
## # run the eggnog annotation mapper
## emapper.py \
## --cpu 16 \
## -i $protein_file_basename.faa \
## -o 




#############################################################################
#############################################################################

### SECTION NOT USED
## ### merge all this information together
## #conda create --name agat bioconda::agat -y
## conda activate agat
## agat_sp_add_functional_annotation.pl \
##   --gff augustus.gff \
##   --ipr proteins.faa.gff3 \
##   -o augustus_functional.gff
## conda deactivate





