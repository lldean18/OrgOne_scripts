#!/bin/bash
# Laura Dean
# 8/12/25
# script written for running on the UoN HPC Ada

# script to run the merqury tool on a genome assembly to assess quality.
# the tool is designed to work with an assembly and illumnina data but
# we dont have short reads so seeing how it works with duplex reads instead.

#SBATCH --job-name=merqury
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=65
#SBATCH --mem=200g
#SBATCH --time=6:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


## set variables specific to assembly
#cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb_ragtag/ragtag.scaffolds_only.fasta

#cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9
#assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm9/ONTasm.bp.p_ctg_100kb.fasta

cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm12
assembly=finalasm.bp.p_ctg_100kb.fasta


# set variables that are always the same
duplex=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_extracted_duplex_duplex.fastq.gz

source $HOME/.bash_profile
#conda create --name merqury -c conda-forge -c bioconda merqury -y
conda activate merqury

##################################
### prepare the meryl database ###
##################################

# # estimate best k-mer size (by giving genome size in bp)
# bash $MERQURY/best_k.sh 2451351749
# # suggests k= 20.6 but the tool suggests in most cases k=31 is optimal so will begin with that

# # build the database
# meryl k=31 count $duplex output ${duplex%.*.*}.meryl



#######################################
### perform k-mer genome evaluation ###
#######################################

$MERQURY/merqury.sh \
${duplex%.*.*}.meryl \
$assembly \
meryl





conda deactivate


