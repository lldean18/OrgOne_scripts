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

## generate a regions file for filtering
#echo "generating a regions file for filtering..."
##conda create --name bioawk bioawk -y
#conda activate bioawk
#bioawk -c fastx '{print $name ":" 1 "-" length($seq)}' $reference > ${reference%.*}_regions_file.txt
#conda deactivate
#echo "Done"

## align our assembly to the reference
#echo "aligning our assembly to the reference..."
#conda activate minimap2
#minimap2 -x asm5 -t 16 $reference $asm1 > ${asm1%.*}_alignment.paf
#conda deactivate
#echo "Done"

## identify the best matching chromosomes for each of our fragments
#echo "identifying the best matching chromosomes for each of our fragments..."
#awk '{print $1, $6, $8-$7}' ${asm1%.*}_alignment.paf | sort -k1,1 -k3nr | awk '!seen[$1]++' > ${asm1%.*}_contig_assignments.txt
#sed -i -r 's/[^ ]*$//' ${asm1%.*}_contig_assignments.txt # get rid of the contig lengths at the ends of the lines
#sed -i -r 's/ /\t/' ${asm1%.*}_contig_assignments.txt # replace spaces with tabs
#echo "Done"

## rename contigs in our assembly based on their assignments
#echo "renaming contigs in our assembly based on their assignments relative to the reference..."
#conda activate seqkit
#seqkit replace -p "^(.*)" -r "{kv}" --kv-file ${asm1%.*}_contig_assignments.txt $asm1 > ${asm1%.*}_ref_renamed_contigs.fasta
#echo "Done"

## filter so that only the longest contig for each match to the reference is retained
#echo "retaining only the longest contig for each match to the reference..."
#seqkit seq -j 4 -w 0 ${asm1%.*}_ref_renamed_contigs.fasta | seqkit rename | seqkit sort -l -r | sed 's/_[0-9][0-9]*//' | seqkit rmdup > ${asm1%.*}_ref_renamed_contigs_longest_sequences.fasta
#conda deactivate
#echo "Done"

###########################################
#### map our assembly to the reference ####
###########################################

echo "Mapping our assembly to the reference..."
conda activate minimap2

# align the genomes
#asm=asm5
asm=asm10
#asm=asm20

# should also try -asm10 and -asm20 for up to 1% / 5% sequence divergence
minimap2 \
-ax $asm \
-t 16 \
--eqx ${asm1%.*}_ref_renamed_contigs_longest_sequences.fasta $reference \
-o $wkdir/tmp.sam
samtools sort $wkdir/tmp.sam \
-o $wkdir/$(basename ${asm1%.*})_$asm.bam
rm $wkdir/tmp.sam
conda deactivate

# index the bam file
samtools index -bc $wkdir/$(basename ${asm1%.*})_$asm.bam

# write the names of the assemblies to a file for use by plotsr
echo -e ""${asm1%.*}_ref_renamed_contigs_longest_sequences.fasta"\tHifiasm10
"$reference"\tReference" > $wkdir/$(basename ${asm1%.*})_plotsr_assemblies_list.txt

module unload samtools-uoneasy/1.18-GCC-12.3.0
echo "Done"

###############################################################
#### Identify structural rearrangements between assemblies ####
###############################################################

echo "identifying structural rearrangements between assemblies with syri..."
# create your syri environment
#conda create -y --name syri -c bioconda -c conda-forge -c anaconda python=3.8 syri
conda activate syri

# Run syri to find structural rearrangements between your assemblies
syri \
-c $wkdir/$(basename ${asm1%.*})_$asm.bam \
-r $reference \
-q ${asm1%.*}_ref_renamed_contigs_longest_sequences.fasta \
-F B \
--dir $wkdir \
--prefix $(basename ${asm1%.*})_${asm}_syri

conda deactivate
echo "Done"

############################
#### create plotsr plot ####
############################

echo "plotting structural rearrangements with plotsr..."
conda activate plotsr

plotsr \
--sr $(basename ${asm1%.*})_${asm}_syri.out \
--genomes $wkdir/$(basename ${asm1%.*})_plotsr_assemblies_list.txt \
-o $wkdir/$(basename ${asm1%.*})_${asm}_plot.png

conda deactivate
echo "Done"



