#!/bin/bash
# Laura Dean
# 10/12/25
# script designed for running on the UoN HPC Ada

# script to plot synteny between the nextdenovo and hifiasm ONT assemblies

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

# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/plotsr_nextdenovo
assembly1=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/ragtag.scaffolds_only.fasta
assembly2=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/NextDenovo_asm/03.ctg_graph/nd.asm_ragtag/ragtag.scaffolds_only.fasta
cd $wkdir

# hashing out this block because it already ran once successfully
# # fix the contig name in the homology scaffolded version
# sed 's/F1/F3/' $assembly2 > ${assembly2%.*}_renamed.fasta # because F1 in the cat is homologous to F3 in the tiger, rename F1 to F3 for compatability



################################################
### Align assemblies that will be compared #####
################################################

# hashing out this block because it already ran once successfully
#asm=asm5 # 0.1% sequence divergence
#asm=asm10 # 1% sequence divergence
#asm=asm20 # 5% sequence divergence

# align assemblies to be compared
conda activate minimap2
minimap2 -ax asm5 -t 16 --eqx $assembly1 $assembly2 | samtools sort -O BAM - > alignment.bam
samtools index alignment.bam
conda deactivate

# write the names of the assemblies to a file for use by plotsr
echo -e ""$assembly1"\tHifiasm_ONT
"$assembly2"\tNextDenovo" > plotsr_assemblies_list.txt

##############################################################
### Identify structural rearrangements between assemblies ####
##############################################################

# hashing out this block because it already ran once successfully
echo "identifying structural rearrangements between assemblies with syri..."
# create your syri environment
#conda create --name syri1.7.1 syri -y
conda activate syri1.7.1

# Run syri to find structural rearrangements between your assemblies
echo "running syri for asm1 and asm2..."
syri \
-c alignment.bam \
-r $assembly1 \
-q $assembly2 \
-F B \
--dir $wkdir \
--prefix asm1_asm2_

conda deactivate

###########################
### create plotsr plot ####
###########################

echo "plotting structural rearrangements with plotsr..."
#conda activate plotsr
#conda create --name plotsr1.1.0 plotsr -y
conda activate plotsr1.1.0

# hashing out this block because it already ran once successfully
# plotsr \
# --sr asm1_asm2_syri.out \
# --genomes plotsr_assemblies_list.txt \
# -o plotsr_plot.png

## customise the plot for the paper
plotsr \
	-o plotsr_plot.png \
	--sr asm1_asm2_syri.out \
	--genomes plotsr_assemblies_list.txt \
	-H 23 \
	-W 20 \
	-f 14 #\
	#--cfg base.cfg


## make the genomes.txt file with custom line widths for genomes
#echo -e ""$cat"\tDomestic_cat\tlw:2.5
#"$reference"\tTiger_haplome\tlw:2.5
#"$assembly"\tHifiasm_ONT\tlw:2.5" > genomes.txt



conda deactivate



