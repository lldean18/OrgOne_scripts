#!/bin/bash
# 15/4/26

# script to have a look at synteny between the assemblies for the ctenella twelve

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=12
#SBATCH --mem=50g
#SBATCH --time=48:00:00
#SBATCH --job-name=ctenella_synteny
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
source $HOME/.bash_profile
#conda create --name ntsynt -c bioconda -c conda-forge ntsynt
conda activate ntsynt
mkdir -p /gpfs01/home/mbzlld/data/ctenella/the_twelve/assemblies/ntsynt
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve/assemblies/ntsynt 

###  # fix to rename contigs in assemblies
###  conda activate seqkit
###  for i in {17,18,20,22,30}
###  do
###  seqkit replace -p "^" -r "barcode${i}_" /gpfs01/home/mbzlld/data/ctenella/the_twelve/assemblies/barcode$i/barcode${i}_ONTasm.bp.p_ctg.fasta > /gpfs01/home/mbzlld/data/ctenella/the_twelve/assemblies/barcode$i/barcode${i}_ONTasm_renamed.fasta
###  done
###  conda deactivate


###  # make a list of the assemblies to plot
###  echo "/gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4/ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb.fasta" > assemblies_list.txt
###  ls /gpfs01/home/mbzlld/data/ctenella/the_twelve/assemblies/barcode*/barcode*_ONTasm_renamed.fasta >> assemblies_list.txt
###  sed -i 's|^[^/]*/|/|' assemblies_list.txt 

# with all 13 genomes this failed without telling me why. Trying selecting fewer asms to compare

# calculate synteny between assemblies
ntSynt \
  -t 12 \
  --fastas_list assemblies_list.txt \
  --divergence 2 \
  --prefix ntSynt_d2

# make a list of the assembly .fai files
ls *.fai > fai_list.txt

# # plot synteny
# ntsynt_viz.py \
# --normalize \
# --blocks ntSynt_d2.k24.w1000.synteny_blocks.tsv \
# --fais fai_list.txt \
# --prefix ribbon_plot_d2 \
# --target-genome ONTasm.bp.p_ctg_Scleractinia_38-41GC_180-300X_100kb.fasta \
# --no-arrow \
# --seq_length 1000 \
# --length 1000 \
# --ribbon_adjust 0.25


# unload software
conda deactivate

