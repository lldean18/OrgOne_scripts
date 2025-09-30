#!/bin/bash
# Laura Dean
# 15/9/25
# script designed for running on the UoN HPC Ada

#SBATCH --job-name=syri_plotsr
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=150g
#SBATCH --time=6:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# load software
source $HOME/.bash_profile

## get the cat ref file in order to match the contig names in the tiger assemblies
#sed 's/.*_/>/' AnAms1.0.genome.fa > AnAms1.0.genome_named_contigs.fa # remove prefix of contig names
#sed -i '/>unplaced/,$d' AnAms1.0.genome_named_contigs.fa # remove the unplaced contig
#sed -i 's/F1/F3/' AnAms1.0.genome_named_contigs.fa # because F1 in the cat is homologous to F3 in the tiger, rename F1 to F3 for compatability

# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/inversions
cat=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference/AnAms1.0.genome_named_contigs.fa
reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/ragtag.scaffolds_only.fasta
cd $wkdir


#################################################
#### Align assemblies that will be compared #####
#################################################

##asm=asm5 # 0.1% sequence divergence
##asm=asm10 # 1% sequence divergence
##asm=asm20 # 5% sequence divergence

## align assemblies to be compared
#conda activate minimap2
#minimap2 -ax asm5 -t 16 --eqx $cat $reference | samtools sort -O BAM - > alignment.bam
#samtools index alignment.bam
#minimap2 -ax asm5 -t 16 --eqx $reference $assembly | samtools sort -O BAM - > alignment2.bam
#samtools index alignment2.bam
#conda deactivate

## write the names of the assemblies to a file for use by plotsr
#echo -e ""$cat"\tDomestic_cat
#"$reference"\tTiger_haplome
#"$assembly"\tHifiasm_ONT" > plotsr_assemblies_list.txt

###############################################################
#### Identify structural rearrangements between assemblies ####
###############################################################

#echo "identifying structural rearrangements between assemblies with syri..."
## create your syri environment
##conda create --name syri1.7.1 syri -y
#conda activate syri1.7.1

## Run syri to find structural rearrangements between your assemblies
#echo "running syri for cat and ref..."
#syri \
#-c alignment.bam \
#-r $cat \
#-q $reference \
#-F B \
#--dir $wkdir \
#--prefix Cat_Ref_

#echo "running syri for red and asm..."
#syri \
#-c alignment2.bam \
#-r $reference \
#-q $assembly \
#-F B \
#--dir $wkdir \
#--prefix Ref_Asm_

#conda deactivate

############################
#### create plotsr plot ####
############################

echo "plotting structural rearrangements with plotsr..."
#conda activate plotsr
#conda create --name plotsr1.1.0 plotsr -y
conda activate plotsr1.1.0

#plotsr \
#--sr Cat_Ref_syri.out \
#--sr Ref_Asm_syri.out \
#--genomes plotsr_assemblies_list.txt \
#-o plotsr_plot_CatRefAsm.png

# customise the plot for the paper
plotsr \
	-o plotsr_plot_CatRefAsm_new2.png \
	--sr Cat_Ref_syri.out \
	--sr Ref_Asm_syri.out \
	--genomes plotsr_assemblies_list.txt \
	-H 10 \
	-W 20 \
	-f 11 \
	--cfg base.cfg

# custom plot with only the inversion chromosomes
plotsr \
	-o plotsr_plot_CatRefAsm_inv_only.png \
	--sr Cat_Ref_syri.out \
	--sr Ref_Asm_syri.out \
	--genomes plotsr_assemblies_list.txt \
	-H 10 \
	-W 20 \
	--cfg base.cfg \
	--chr E1 \
	--chr E2 \
	--chr D4 \
	-f 11



#conda deactivate



