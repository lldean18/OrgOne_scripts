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

#############################################
#### assign our fragments to chromosomes ####
#############################################

# # generate a regions file for filtering
# #conda create --name bioawk bioawk -y
# conda activate bioawk
# bioawk -c fastx '{print $name ":" 1 "-" length($seq)}' $reference > ${reference%.*}_regions_file.txt
# conda deactivate

# # align our assembly to the reference
# conda activate minimap2
# minimap2 -x asm5 -t 16 $reference $asm1 > ${asm1%.*}_alignment.paf
# conda deactivate

# # identify the best matching chromosomes for each of our fragments
# awk '{print $1, $6, $8-$7}' ${asm1%.*}_alignment.paf | sort -k1,1 -k3nr | awk '!seen[$1]++' > ${asm1%.*}_contig_assignments.txt
# sed -i -r 's/[^ ]*$//' ${asm1%.*}_contig_assignments.txt # get rid of the contig lengths at the ends of the lines
# sed -i -r 's/ /\t/' ${asm1%.*}_contig_assignments.txt # replace spaces with tabs

# # rename contigs in our assembly based on their assignments
# conda activate seqkit
# seqkit replace -p "^(.*)" -r "{kv}" --kv-file ${asm1%.*}_contig_assignments.txt $asm1 > ${asm1%.*}_ref_renamed_contigs.fasta
# conda deactivate

###########################################
#### map our assembly to the reference ####
###########################################

conda activate minimap2

# align the genomes
#asm=asm5
asm=asm10
#asm=asm20

# should also try -asm10 and -asm20 for up to 1% / 5% sequence divergence
minimap2 \
-ax $asm \
-t 16 \
--eqx $asm1 $reference \
-o $wkdir/tmp.sam
samtools sort $wkdir/tmp.sam \
-o $wkdir/$(basename ${asm%.*})_$asm.bam
rm $wkdir/tmp.sam
conda deactivate

# write the names of the assemblies to a file for use by plotsr
echo -e ""$asm1"\tHifiasm10
"$reference"\tReference" > $wkdir/$(basename ${asm1%.*})_plotsr_assemblies_list.txt

module unload samtools-uoneasy/1.12-GCC-9.3.0



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

