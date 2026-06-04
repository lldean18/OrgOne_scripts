#!/bin/bash
# 4/6/26

# script to run busco on a de novo genome assembly

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=80g
#SBATCH --time=8:00:00
#SBATCH --job-name=busco
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup environment
source $HOME/.bash_profile
conda activate busco6.0.0
mkdir -p /share/deepseq/org_one/SNT052/busco
cd /share/deepseq/org_one/SNT052/busco
assembly=/share/deepseq/org_one/SNT052/dorado_polish/turtle.bp.p_ctg_polished_36-55GC_10-100X_100kb.fasta
lineage_dataset=sauropsida_odb12


# download all the busco datasets (only do this once in a while if new datasets are released)
#busco --download_path ~/busco_downloads --download all

# decide what lineage dataset you will use for your species
#busco --list-datasets

# run busco
# --in : input assembly in fasta format
# --lineage_dataset nearest class in the busco database for your species
# --mode specify you are working on a genome assembly
# --out name the output files (busco will create a folder with this name)
# --out_path specify the path to your desired output directory
# --cpu specify number of cores to use
busco \
--in $assembly \
--lineage_dataset $lineage_dataset \
--mode genome \
--out buscos_$(basename ${assembly%.*})_$lineage_dataset \
--out_path ./ \
--cpu 16 \
-f \
--download_path ~/busco_downloads

# deactivate conda
conda deactivate

