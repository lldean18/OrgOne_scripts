#!/bin/bash
# Laura Dean
# 2/12/24
# for running on UoN HPC Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=50g
#SBATCH --time=48:00:00
#SBATCH --job-name=black_lemur_busco
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set variables
species=black_and_white_ruffed_lemur
wkdir=/share/StickleAss/OrgOne/$species # set the working directory
assembly_dir=hifiasm_asm1 # set the name of the directory containing the assembly
assembly=ONTasm.bp.p_ctg.fasta # set the name of the fasta assembly
#lineage_dataset=laurasiatheria_odb10 # for bactrian camel
#lineage_datase48primates_odb10 # for western chimpanzee
lineage_dataset=eutheria_odb10 # for black and white ruffed lemur

# load your bash profile for using conda
source $HOME/.bash_profile

# load conda environment
conda activate busco

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
--in $wkdir/$assembly_dir/$assembly \
--lineage_dataset $lineage_dataset \
--mode genome \
--out buscos \
--out_path $wkdir/$assembly_dir \
--cpu 8

# deactivate conda
conda deactivate
