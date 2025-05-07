#!/bin/bash
# Laura Dean
# 7/5/25
# for running on Ada

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=48:00:00
#SBATCH --job-name=tig_raft_hifiasm12
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

####### PREPARE ENVIRONMENT #######
# activate conda environment
conda activate hifiasm_0.24.0

# # install raft
# cd ~/software_bin/
# git clone https://github.com/at-cg/RAFT.git
# cd RAFT/
# make
# # save the path to your bashrc
# #add /gpfs01/home/mbzlld/software_bin/RAFT to your path in bashrc

# set environment variables
species=sumatran_tiger
wkdir=/gpfs01/home/mbzlld/data/OrgOne/$species # set the working directory
attempt=12

#reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/duplex_and_herro_simplex.fa.gz
#reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_duplex.fa.gz
reads=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_simplex_simplex_herro_corrected.fa.gz

# the duplex reads that I converted to fasta alone work fine with a coverage of 9X
# the simplex reads output from herro also work fine with a coverage of 46X
# the merged file does not run

# make directory for the assembly & move to it
mkdir -p $wkdir/raft_hifiasm_asm$attempt
cd $wkdir/raft_hifiasm_asm$attempt

echo "running the raft / hifiasm pipeline with hifiasm version 0.24.0 without the --ont flag with the
input data: $reads
writing the results to the dir: $wkdir/raft_hifiasm_asm$attempt
"

####### STEP 1 ########
# run hifiasm on error corrected (with herro) simplex reads to obtain error corrected reads and coverage estimate
hifiasm \
-o errorcorrect \
-t 96 \
--write-ec \
$reads 2> errorcorrect.log
COVERAGE=$(grep "homozygous" errorcorrect.log | tail -1 | awk '{print $6}')

echo "step 1 is complete, the coverage for duplex & herro error corrected simplex reads reads is:"
echo $COVERAGE


####### STEP 2 ########
# run hifiasm again to obtain all-vs-all read overlaps as a paf file
hifiasm \
-o getOverlaps \
-t 96 \
--dbg-ovec \
errorcorrect.ec.fa 2> getOverlaps.log
# Merge cis and trans overlaps
cat getOverlaps.0.ovlp.paf getOverlaps.1.ovlp.paf > overlaps.paf

echo "step 2 is complete"

####### STEP 3 ########
# use raft to fragment the error corrected reads
raft \
-e ${COVERAGE} \
-o fragmented \
errorcorrect.ec.fa overlaps.paf

echo "step 3 is complete"

####### STEP 4 ########
# run hifiasm a third & final time to obtain assembly of fragmented reads
# integrate ultra long reads here as well
# A single round of error correction (-r1) is enough here
hifiasm \
-o finalasm \
-t 96 \
-r 1 \
fragmented.reads.fasta 2> finalasm.log

echo "step 4 is complete, th final assembly files are:"

# list the final assembly files
ls finalasm*p_ctg.gfa

# convert the final assembly to fasta format
awk '/^S/{print ">"$2;print $3}' finalasm.bp.p_ctg.gfa > finalasm.bp.p_ctg.fasta



# deactivate software
conda deactivate






