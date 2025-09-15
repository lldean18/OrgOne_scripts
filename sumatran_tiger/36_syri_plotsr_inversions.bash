#!/bin/bash
# Laura Dean
# 15/9/25
# script designed for running on the UoN HPC Ada

#SBATCH --job-name=syri_plotsr
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50g
#SBATCH --time=24:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# load software
source $HOME/.bash_profile

# set variables
wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/inversions
reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/ragtag.scaffolds_only.fasta
cd $wkdir


#################################################
#### Align assemblies that will be compared #####
#################################################

## align assemblies to be compared
#conda activate minimap2
#minimap2 -ax asm5 -t 16 --eqx $reference $assembly | samtools sort -O BAM - > alignment.bam
#samtools index alignment.bam
##asm=asm5 # 0.1% sequence divergence
##asm=asm10 # 1% sequence divergence
##asm=asm20 # 5% sequence divergence
#conda deactivate
#
## write the names of the assemblies to a file for use by plotsr
#echo -e ""$assembly"\tHifiasmONT
#"$reference"\tTiger_haplome" > plotsr_assemblies_list.txt

###############################################################
#### Identify structural rearrangements between assemblies ####
###############################################################

echo "identifying structural rearrangements between assemblies with syri..."
# create your syri environment
#conda create -y --name syri -c bioconda -c conda-forge -c anaconda python=3.8 syri
conda activate syri

# Run syri to find structural rearrangements between your assemblies
syri \
-c alignment.bam \
-r $reference \
-q $assembly \
-F B \
--dir $wkdir \
--prefix HifiasmONT_

conda deactivate

############################
#### create plotsr plot ####
############################

echo "plotting structural rearrangements with plotsr..."
conda activate plotsr

plotsr \
--sr HifiasmONT_syri.out \
--genomes plotsr_assemblies_list.txt \
-o plotsr_plot.png

conda deactivate



