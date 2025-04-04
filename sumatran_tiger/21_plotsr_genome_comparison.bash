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
# set mapping variable (select level based on estimated sequence divergence)
# for reference asm5/asm10/asm20 = 0.1%/1%/5% sequence divergence
#asm=asm5 # 0.1% sequence divergence
asm=asm10 # 1% sequence divergence
#asm=asm20 # 5% sequence divergence

# load software
source $HOME/.bash_profile
module load samtools-uoneasy/1.18-GCC-12.3.0

# first I fixed the fact that there were no spaces between > symbol and fasta headers with this line
#sed -i 's/>/> /' GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta
# decided this was how it should be so set it back to have no space
#sed -i 's/> />/' GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta
# then proceeded
# in the end I didn't do this bit as it caused further issues!!

#############################################
#### assign our fragments to chromosomes ####
#############################################

# generate a regions file for filtering
echo "generating a regions file for filtering..."
##conda create --name bioawk bioawk -y
#conda activate bioawk
#bioawk -c fastx '{print $name ":" 1 "-" length($seq)}' $reference > ${reference%.*}_regions_file.txt
#conda deactivate
# Bioawk was no longer working after fixing the issue of no space between > and the fasta header so use normal awk
awk '/^>/ {header=substr($0,2); next} {seq[header]=seq[header] $0} END {for (h in seq) print h ":1-" length(seq[h])}' "$reference" > ${reference%.*}_regions_file.txt
echo -e "Done\n\n"

# align our assembly to the reference
echo "aligning our assembly to the reference for naming our chrs the same as theirs..."
conda activate minimap2
minimap2 -x asm5 -t 16 $reference $asm1 > ${asm1%.*}_alignment.paf
conda deactivate
echo -e "Done\n\n"

# identify the best matching chromosomes for each of our fragments
echo "identifying the best matching chromosomes for each of our fragments..."
awk '{print $1, $6, $8-$7}' ${asm1%.*}_alignment.paf | sort -k1,1 -k3nr | awk '!seen[$1]++' > ${asm1%.*}_contig_assignments.txt
sed -i -r 's/[^ ]*$//' ${asm1%.*}_contig_assignments.txt # get rid of the contig lengths at the ends of the lines
sed -i -r 's/ /\t/' ${asm1%.*}_contig_assignments.txt # replace spaces with tabs
echo -e "Done\n\n"

# rename contigs in our assembly based on their assignments
echo "renaming contigs in our assembly based on their assignments relative to the reference..."
conda activate seqkit
seqkit replace -p "^(.*)" -r "{kv}" --kv-file ${asm1%.*}_contig_assignments.txt $asm1 > ${asm1%.*}_ref_renamed_contigs.fasta
echo -e "Done\n\n"

# create a version of the ref renamed contig file for other uses that has unique names
conda activate seqkit
seqkit rename -n -o ${asm1%.*}_ref_renamed_contigs_unique.fasta ${asm1%.*}_ref_renamed_contigs.fasta

# filter so that only the longest contig for each match to the reference is retained
echo "retaining only the longest contig for each match to the reference..."
seqkit seq -j 4 -w 0 ${asm1%.*}_ref_renamed_contigs.fasta | seqkit rename | seqkit sort -l -r | sed 's/_[0-9][0-9]*//' | seqkit rmdup > ${asm1%.*}_ref_renamed_contigs_longest_sequences.fasta
conda deactivate
echo -e "Done\n\n"

# Filter so that only contigs that are in our assembly are in a new version of the reference
# because syri won't work with differing numbers of chromosomes in the same assembly
echo "making a list of the fasta headers to filter with..."
# make a text file of the headers to search for
grep ">" ${asm1%.*}_ref_renamed_contigs_longest_sequences.fasta > ${asm1%.*}_ref_renamed_contigs_longest_sequences_headers.txt
sed -i 's/>//' ${asm1%.*}_ref_renamed_contigs_longest_sequences_headers.txt
sed -i 's/[[:space:]]*$//' ${asm1%.*}_ref_renamed_contigs_longest_sequences_headers.txt
echo -e "Done\n\n"

# filter the reference with this file
echo "filtering the reference so that it only contains sequences that are in our assembly..."
conda activate seqkit
seqkit grep -f ${asm1%.*}_ref_renamed_contigs_longest_sequences_headers.txt $reference > ${reference%.*}_contigfilt.fasta
conda deactivate
echo -e "Done\n\n"

################################################################################################
#### Flip the orientation of our sequences that are on the opposite strand to the reference ####
################################################################################################

# flip the orientation of our sequences that are on the wrong strand
echo "flipping the orientation of our sequences so that they match the reference..."
conda activate seqkit
# define output
touch ${asm1%.*}_ref_renamed_contigs_longest_sequences_orient.fasta

# Loop through sequences in our assembly fasta file
seqkit seq --seq-type dna -n ${asm1%.*}_ref_renamed_contigs_longest_sequences.fasta | while read name; do
    # Extract sequences
    seq1=$(seqkit grep -p "$name" ${asm1%.*}_ref_renamed_contigs_longest_sequences.fasta | seqkit seq --seq)
    seq2=$(seqkit grep -p "$name" ${reference%.*}_contigfilt.fasta | seqkit seq --seq)

    # Save sequences to temporary files
    echo -e ">$name\n$seq1" > ~/seq1.fasta
    echo -e ">$name\n$seq2" > ~/seq2.fasta
    echo -e ">$name\n$(seqkit seq --seq-type dna --reverse --complement ~/seq2.fasta | seqkit seq --seq)" > ~/seq2_rc.fasta

    # Align both orientations with MAFFT
    mafft --quiet ~/seq1.fasta ~/seq2.fasta > ~/aligned1.fasta
    mafft --quiet ~/seq1.fasta ~/seq2_rc.fasta > ~/aligned2.fasta

    # Calculate alignment scores
    score1=$(awk '/identity/ {print $3}' <(seqkit fx2tab -n -i -p ~/aligned1.fasta | seqkit stats))
    score2=$(awk '/identity/ {print $3}' <(seqkit fx2tab -n -i -p ~/aligned2.fasta | seqkit stats))

    # Choose best orientation
    if (( $(echo "$score1 >= $score2" | bc -l) )); then
        cat seq2.fasta >> ${asm1%.*}_ref_renamed_contigs_longest_sequences_orient.fasta
    else
        seqkit seq --reverse --complement seq2.fasta >> ${asm1%.*}_ref_renamed_contigs_longest_sequences_orient.fasta
    fi
done

# Cleanup
rm seq1.fasta seq2.fasta seq2_rc.fasta aligned1.fasta aligned2.fasta
conda deactivate
echo -e "Done\n\n"

###########################################
#### map our assembly to the reference ####
###########################################

echo "Mapping our assembly to the reference..."
conda activate minimap2

# align the genomes

# for reference asm5/asm10/asm20 = 0.1%/1%/5% sequence divergence
minimap2 \
-ax $asm \
-t 16 \
--eqx ${asm1%.*}_ref_renamed_contigs_longest_sequences_orient.fasta ${reference%.*}_contigfilt.fasta \
-o $wkdir/tmp.sam
samtools sort $wkdir/tmp.sam \
-o $wkdir/$(basename ${asm1%.*})_$asm.bam
rm $wkdir/tmp.sam
conda deactivate

# index the bam file
samtools index -bc $wkdir/$(basename ${asm1%.*})_$asm.bam

# write the names of the assemblies to a file for use by plotsr
echo -e ""${asm1%.*}_ref_renamed_contigs_longest_sequences_orient.fasta"\tHifiasm10
"${reference%.*}_contigfilt.fasta"\tReference" > $wkdir/$(basename ${asm1%.*})_plotsr_assemblies_list.txt

module unload samtools-uoneasy/1.18-GCC-12.3.0
echo -e "Done\n\n"


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
-r ${reference%.*}_contigfilt.fasta \
-q ${asm1%.*}_ref_renamed_contigs_longest_sequences_orient.fasta \
-F B \
--dir $wkdir \
--prefix $(basename ${asm1%.*})_${asm}_syri

conda deactivate
echo -e "Done\n\n"

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



