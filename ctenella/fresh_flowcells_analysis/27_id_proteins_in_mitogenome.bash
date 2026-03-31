#!/bin/bash
# Laura Dean
# 11/3/26

# script to search the ctenella mitochondrial genome for mitochondiral genes

#SBATCH --job-name=map_proteins_2_mitogenome
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=150g
#SBATCH --time=24:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set up for software
source $HOME/.bash_profile

# move to working directory
cd /gpfs01/home/mbzlld/data/ctenella/mitogenome

# set variables
mitogenome=flye_mito_asm_2/assembly.fasta
proteins=Galaxea_fascircularis_proteins.fa

# search mitogenome for mitochondrial proteins
conda activate miniprot
miniprot \
-t 32 \
-S \
-j 0 \
$mitogenome $proteins > flye_mito_asm_2/assembly_Galaxea_fascircularis_proteins.paf
conda deactivate

# count the number of mitochondrial genes thereare in the mitogenome assembly
echo "the number of mitochondrial genes in the mitoassembly is :"
awk '{print $1}' flye_mito_asm_2/assembly_Galaxea_fascircularis_proteins.paf | sort | uniq | wc



