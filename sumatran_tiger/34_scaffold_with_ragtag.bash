#!/bin/bash
# Laura Dean
# 15/5/25
# 9/12/25
# script written for running on the UoN HPC Ada

#SBATCH --job-name=ragtag_scaffold
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=30g
#SBATCH --time=12:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set variables
reference=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/GCA_018350195.2_chrs_only_uniq_names_nospaces.fasta
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm12/finalasm.bp.p_ctg_100kb.fasta
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/flye_asm5/assembly_100kb.fasta
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm11/ONTasm.bp.p_ctg_100kb.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm13/ONTasm.bp.p_ctg_100kb.fasta

# scaffold assembly with ragtag
source $HOME/.bash_profile
conda activate ragtag
ragtag.py scaffold -t 16 -o ${assembly%.*}_ragtag $reference $assembly
conda deactivate


# get rid of the ragtag suffixes
sed -i 's/_RagTag//' ${assembly%.*}_ragtag/ragtag.scaffold.fasta

# set the file containing chromosome names to keep
keep=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/liger_reference/tiger_chrs.txt

# rename scaffolds and remove unplaced contigs
conda activate seqtk
seqtk subseq ${assembly%.*}_ragtag/ragtag.scaffold.fasta $keep > ${assembly%.*}_ragtag/ragtag.scaffolds_only.fasta
conda deactivate



