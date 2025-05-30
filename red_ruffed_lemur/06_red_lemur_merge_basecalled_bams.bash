#!/bin/bash
# Laura Dean
# 14/5/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=40
#SBATCH --mem=50g
#SBATCH --time=24:00:00
#SBATCH --job-name=red_lemur_merge
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# set the species name
species=red_ruffed_lemur

# set the working directory
wkdir=/gpfs01/home/mbzlld/data/OrgOne/$species/basecalls

# set the bam lists
duplex_bam_list=/gpfs01/home/mbzlld/code_and_scripts/File_lists/${species}_duplex_bam_list.txt
simplex_bam_list=/gpfs01/home/mbzlld/code_and_scripts/File_lists/${species}_simplex_bam_list.txt


# # generate the list of bams to be merged
# cd $wkdir
# # FOR DUPLEX READS
# # list all bam files & write to config file
# find . -type f -name '*duplex.bam' | sort -u > $duplex_bam_list
# # add the start of the filepath to the config file (bc we cd'd to the basecalls dir, it only prints from there)
# sed -i "s/[.]/\/gpfs01\/home\/mbzlld\/data\/OrgOne\/$species\/basecalls/" $duplex_bam_list
# # FOR SIMPLEX ONLY (NOT SIMPLEX FROM DUPLEX)
# # list all bam files & write to config file
# find . -type f -name '*calls.bam' | sort -u > $simplex_bam_list
# # add the start of the filepath to the config file (bc we cd'd to the basecalls dir, it only prints from there)
# sed -i "s/[.]/\/gpfs01\/home\/mbzlld\/data\/OrgOne\/$species\/basecalls/" $simplex_bam_list
# sed -i '/duplex/d' $simplex_bam_list



# load modules
module load samtools-uoneasy/1.18-GCC-12.3.0

# merge the duplex bams
samtools merge \
-o $wkdir/${species}_all_duplex.bam \
-b $duplex_bam_list \
--threads 40 \
--write-index

# merge the simplex from simplex bams
samtools merge \
-o $wkdir/${species}_simplex.bam \
-b $simplex_bam_list \
--threads 40 \
--write-index

