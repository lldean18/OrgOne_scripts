#!/bin/bash
# Laura Dean
# 31/1/25
# script designed for running on the UoN HPC Ada

#SBATCH --job-name=plotsr
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50g
#SBATCH --time=4:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/plotsr
reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta
asm1=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm10/ONTasm.bp.p_ctg_100kb.fasta

# load software
source $HOME/.bash_profile
module load samtools-uoneasy/1.18-GCC-12.3.0

# assign our fragments to chromosomes
# index the reference assembly
conda create --name bioawk bioawk -y
conda activate bioawk
bioawk -c fastx '{print $name ":" 1 "-" length($seq)}' $reference > ${reference%.*}regions_file.txt
conda deactivate




# The chromosome names have to match across files

## remove the _RagTag suffix from the chromosome names in the fasta files
#sed 's/_RagTag//' /gpfs01/share/StickleAss/plotsr/marine_Duin.fasta > /gpfs01/share/StickleAss/plotsr/Duin_clean.fasta
#sed 's/_RagTag//' /gpfs01/share/StickleAss/plotsr/freshwater_Scad.fasta > /gpfs01/share/StickleAss/plotsr/Scad_clean.fasta



## Remove all of the scaffolds from the fastq files that are still not assigned to chromosomes with samtools faidx
## Duin
#samtools faidx /gpfs01/share/StickleAss/plotsr/Duin_clean.fasta \
#--region-file /gpfs01/home/mbzlld/code_and_scripts/Regions_files/V5_regions_file.txt > /gpfs01/share/StickleAss/plotsr/Duin_cleaner.fasta
##[faidx] Truncated sequence: chrUn:0-19879834
##[faidx] Truncated sequence: chrX:0-17985176
##[faidx] Truncated sequence: chrXIX:0-20580295
##[faidx] Truncated sequence: chrXXI:0-17421465
##[faidx] Truncated sequence: chrY:0-15859692

## Scad
#samtools faidx /gpfs01/share/StickleAss/plotsr/Scad_clean.fasta \
#--region-file /gpfs01/home/mbzlld/code_and_scripts/Regions_files/V5_regions_file.txt > /gpfs01/share/StickleAss/plotsr/Scad_cleaner.fasta
##[faidx] Truncated sequence: chrUn:0-19879834
##[faidx] Truncated sequence: chrX:0-17985176
##[faidx] Truncated sequence: chrY:0-15859692



# # activate minimap
# source $HOME/.bash_profile
# conda activate minimap

# # load modules you want to use
# module load samtools-uoneasy/1.18-GCC-12.3.0

# # specify the directory you want to write to
# working_dir=/gpfs01/share/StickleAss/plotsr

# # specify the locations of the assemblies you want to align
# #duin_assembly=/gpfs01/home/mbzlld/data/Long_read_data/Duin_v1_ont_blobs.fa
# #scad_assembly=/gpfs01/home/mbzlld/data/Long_read_data/Scad_v1_ont_blobs.fa
# duin_assembly=Duin_cleaner.fasta
# scad_assembly=Scad_cleaner.fasta

# # look at the ~chromosome names in the two fasta files
# grep ">" $working_dir/$duin_assembly
# grep ">" $working_dir/$scad_assembly


# # align the genomes
# #asm=asm5
# asm=asm10
# #asm=asm20

# # should also try -asm10 and -asm20 for up to 1% / 5% sequence divergence
# minimap2 -ax $asm -t 16 --eqx $working_dir/$duin_assembly $working_dir/$scad_assembly -o $working_dir/duin_scad.sam
# samtools sort $working_dir/duin_scad.sam -o $working_dir/duin_scad_$asm.bam
# rm $working_dir/duin_scad.sam

# # write the names of the assemblies to a file for use by plotsr
# echo -e ""$working_dir"/"$duin_assembly"\tDuin
# "$working_dir"/"$scad_assembly"\tScad" > /gpfs01/home/mbzlld/code_and_scripts/File_lists/plotsr_assemblies_list.txt

# module unload samtools-uoneasy/1.12-GCC-9.3.0
# conda deactivate


# # create your syri environment (only have to do this once)
# #conda create -y --name syri -c bioconda -c conda-forge -c anaconda python=3.8 syri

# # activate your syri environment and output the environment info...
# conda activate syri
# conda info

# # Run syri to find structural rearrangements between your assemblies
# syri -c $working_dir/duin_scad_$asm.bam -r $working_dir/$duin_assembly -q $working_dir/$scad_assembly -F B --dir $working_dir --prefix duin_scad_$asm\_

# conda deactivate


# conda activate plotsr

# plotsr \
# --sr $working_dir/duin_scad_$asm\_syri.out \
# --genomes /gpfs01/home/mbzlld/code_and_scripts/File_lists/plotsr_assemblies_list.txt \
# -o $working_dir/duin_scad_$asm\_plot.png

# conda deactivate

