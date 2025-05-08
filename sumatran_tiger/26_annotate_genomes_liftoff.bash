#!/bin/bash
# Laura Dean
# 2/5/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=liftoff_annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=50g
#SBATCH --time=1:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

# set variables
reference_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome.fa
reference_gff=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0r1.0.2.gff

#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta # worked after using no spaces
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta # Worked
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm9/finalasm.bp.p_ctg.fasta # worked
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/sumatran_tiger_flye_asm4/assembly.fasta # worked
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm11/ONTasm.bp.p_ctg_100kb.fasta # worked
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm12/ONTasm.bp.p_ctg_100kb.fasta # worked
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm10/finalasm.bp.p_ctg_100kb.fasta # worked
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_scaff_only_names_split_contigs.fasta
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome_split_contigs.fa
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final.fa
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag/ragtag.scaffold.fasta
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta
#target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC2/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag/ragtag.scaffold.fasta
target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm12/finalasm.bp.p_ctg_100kb.fasta

# load software
#conda create --name liftoff -c bioconda liftoff
conda activate liftoff

# annotate assembly by lifting over genes from the closely related source assembly
liftoff \
	-g $reference_gff \
	-o ${target_assembly%.*}_liftoff.gff \
	-p 32 \
	$target_assembly $reference_assembly

#         -chroms ${reference_assembly%.*}_chr_match_file.txt \
#         -unplaced ${reference_assembly%.*}_unplaced.txt \

# unload software
conda deactivate



# load software
conda activate gffread

# convert the gff file to bed format for input to genespace
# this command seems to retain only the genes anyway so no need for further filtering
gffread \
${target_assembly%.*}_liftoff.gff \
--bed \
-o ${target_assembly%.*}_liftoff_genes.bed


# generate protein fasta file as this is also required as input to genespace
# -S flag uses * instead of . for stop codon translation
gffread \
${target_assembly%.*}_liftoff.gff \
-S \
-g $target_assembly \
-y ${target_assembly%.*}_proteins.fasta

# unload software
conda deactivate





