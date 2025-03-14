#!/bin/bash
# Laura Dean
# 13/3/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=liftoff_annotate
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=50g
#SBATCH --time=1:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
reference_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome.fa
reference_gff=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0r1.0.2.gff
target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names.fasta # failed so far! :(
target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta # Worked successfully
target_assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm9/finalasm.bp.p_ctg.fasta


## generate the chr matching file for the cat to our tiger genomes
#echo "AnAms1.0_A1,A1
#AnAms1.0_A2,A2
#AnAms1.0_A3,A3
#AnAms1.0_B1,B1
#AnAms1.0_B2,B2
#AnAms1.0_B3,B3
#AnAms1.0_B4,B4
#AnAms1.0_C1,C1
#AnAms1.0_C2,C2
#AnAms1.0_D1,D1
#AnAms1.0_D2,D2
#AnAms1.0_D3,D3
#AnAms1.0_D4,D4
#AnAms1.0_E1,E1
#AnAms1.0_E2,E2
#AnAms1.0_E3,E3
#AnAms1.0_F2,F2
#AnAms1.0_X,X" > ${reference_assembly%.*}_chr_match_file.txt
#
## generate the unplaced file for the unassigned scaffold in the cat genome
#echo "AnAms1.0_F1
#AnAms1.0_unplaced" > ${reference_assembly%.*}_unplaced.txt


## load software
#source $HOME/.bash_profile
##conda create --name liftoff -c bioconda liftoff
#conda activate liftoff
#
## annotate assembly by lifting over genes from the closely related source assembly
#liftoff \
#	-g $reference_gff \
#	-o ${target_assembly%.*}_liftoff.gff \
#	-p 32 \
#	$target_assembly $reference_assembly
#
##         -chroms ${reference_assembly%.*}_chr_match_file.txt \
##         -unplaced ${reference_assembly%.*}_unplaced.txt \
#
## unload software
#conda deactivate



# load software
conda activate gffread

# convert the gff file to bed format for input to genespace
gffread \
${target_assembly%.*}_liftoff.gff \
--bed | awk '$4 == "gene"' > ${target_assembly%.*}_liftoff_genes.bed

# generate protein fasta file as this is also required as input to genespace
gffread \
${target_assembly%.*}_liftoff.gff \
-g $target_assembly \
-y ${target_assembly%.*}_proteins.fasta

# unload software
conda deactivate





