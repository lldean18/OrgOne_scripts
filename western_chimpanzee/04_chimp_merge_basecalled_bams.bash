#!/bin/bash
# Laura Dean
# 5/3/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=50g
#SBATCH --time=24:00:00
#SBATCH --job-name=chimp_merge
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

## location of chimp basecalled bams to be merged:
#/gpfs01/home/mbzlld/data/OrgOne/western_chimpanzee/basecalls

# set the species name
species=western_chimpanzee

# set the working directory
wkdir=/gpfs01/home/mbzlld/data/OrgOne/$species/basecalls

# set the bam list
bam_list=/gpfs01/home/mbzlld/code_and_scripts/File_lists/${species}_bam_list.txt


# generate the list of bams to be merged
cd $wkdir
# list all bam files & write to config file
find . -type f -name '*bam' | sort -u > $bam_list
# add the start of the filepath to the config file (bc we cd'd to the basecalls dir, it only prints from there)
sed -i "s/[.]/\/gpfs01\/home\/mbzlld\/data\/OrgOne\/$species\/basecalls/" $bam_list



# load modules
module load samtools-uoneasy/1.18-GCC-12.3.0

# merge the bams
samtools merge \
-o $wkdir/${species}.bam \
-b $bam_list \
--threads 40 \
--write-index

