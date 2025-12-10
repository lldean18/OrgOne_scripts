#!/bin/bash
# Laura Dean
# 29/4/25
# 10/12/25
# for running on the UoN HPC Ada

# script to assess telomere presence and draw telomere plots

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=15g
#SBATCH --time=1:00:00
#SBATCH --job-name=telo_explorer
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# create and load conda env
source $HOME/.bash_profile
#cd ~/software_bin
#git clone git@github.com:aaranyue/quarTeT.git
# added the path /gpfs01/home/mbzlld/software_bin/quarTeT to my path in .bashrc
#conda create -n quartet Python Minimap2 MUMmer4 trf CD-hit BLAST tidk R R-RIdeogram R-ggplot2 gnuplot -y
conda activate quartet
#conda install conda-forge::r-jpeg





# set environmental variables
#wkdir=~/data/OrgOne/sumatran_tiger/hifiasm_asm10
#genome=ONTasm.bp.p_ctg_100kb.fasta

#wkdir=~/data/OrgOne/sumatran_tiger/hifiasm_asm9
#genome=ONTasm.bp.p_ctg_100kb.fasta
#genome=ONTasm.bp.p_ctg_100kb_3Mb.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference
##genome=GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta
#genome=GCA_018350195.2_scaff_only_names.fasta.gz
#genome=GCA_018350195.2_scaff_only_names_split_contigs.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag
#genome=ragtag.scaffold.fasta
#genome=ragtag.scaffold_3Mb.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm10
#genome=finalasm.bp.p_ctg_100kb.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/flye_asm5
#genome=assembly_100kb_3Mb.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/domestic_cat_reference
#genome=AnAms1.0.genome_split_contigs_100kb.fasta
#genome=AnAms1.0.genome.fa

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/HiC2/ONTasm.bp.p_ctg_100kb_yahs_scaffolds_final_ragtag
#genome=ragtag.scaffold_1Mb.fasta
#genome=ragtag.scaffold_3Mb.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm12
#genome=finalasm.bp.p_ctg_100kb.fasta
#genome=finalasm.bp.p_ctg_100kb_3Mb.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/flye_asm5
#genome=assembly_100kb.fasta

#wkdir=~/data/OrgOne/sumatran_tiger/hifiasm_asm12
#genome=ONTasm.bp.p_ctg_100kb_3Mb.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm13
#genome=ONTasm.bp.p_ctg_100kb_3Mb.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm12/finalasm.bp.p_ctg_100kb_ragtag
#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm11/ONTasm.bp.p_ctg_100kb_ragtag
#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/flye_asm5/assembly_100kb_ragtag
#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag
#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm13/ONTasm.bp.p_ctg_100kb_ragtag
#genome=ragtag.scaffolds_only.fasta

#wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/NextDenovo_asm/03.ctg_graph
#genome=nd.asm.fasta


wkdir=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/NextDenovo_asm/03.ctg_graph/nd.asm_ragtag
genome=ragtag.scaffolds_only.fasta


# move to working directory
cd $wkdir


# unzip the input fasta file if it is gzipped and reassign its name
if [[ "$genome" == *.gz ]]; then
    gunzip -k $genome
    echo "Unzipped: $genome"
    genome=${genome%.*}
else
    echo "The input genome does not have a .gz extension so it won't be decompressed."
fi



# Check if the file contains multiline sequences and convert them to single line if it does
if awk '/^>/ {if (seqlen > 1) exit 0; seqlen=0} !/^>/ {seqlen++} END {if (seqlen > 1) exit 0; exit 1}' "$genome"; then
    echo "The FASTA file contains multiline sequences, converting to single line..."
    conda activate seqkit
    seqkit seq -w 0 $genome -o tmp.fasta && mv tmp.fasta $genome
    conda deactivate
    echo "Conversion to single line fasta format complete."
else
    echo "The FASTA file already contains single-line sequences. No conversion needed."
fi





# run the telomere explorer
python ~/software_bin/quarTeT/quartet.py TeloExplorer \
	-i $genome \
	-c animal \
	-p ${genome%.*}_quartet

conda deactivate


