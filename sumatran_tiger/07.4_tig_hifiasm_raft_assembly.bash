#!/bin/bash
# Laura Dean
# 19/4/24
# for running on Ada

#SBATCH --partition=hmemq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=1495g
#SBATCH --time=168:00:00
#SBATCH --job-name=tig_hifiasm4
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

source $HOME/.bash_profile

####### PREPARE ENVIRONMENT #######
# create conda environment
#conda create --name hifiasm -c conda-forge -c bioconda hifiasm
conda activate hifiasm

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
attempt=4

# list the duplex reads and merge them for input to hifiasm
cd $wkdir/basecalls
duplex=$(find . -type f -name '*duplex.fastq*')
cat $duplex > all_duplex.fastq.gz

# list the simplex reads, including the ultra long P3 reads and merge for the final hifiasm step
cd $wkdir/basecalls/sumatran_tiger_P1
simplexP1=$(find ~+ -type f -name '*calls.fastq*')
cd $wkdir/basecalls/sumatran_tiger_P2
simplexP2=$(find ~+ -type f -name '*calls.fastq*')
cd $wkdir/basecalls/sumatran_tiger_P3
simplexP3=$(find ~+ -type f -name '*calls.fastq*')
cd $wkdir/basecalls/sumatran_tiger_P4
simplexP4=$(find ~+ -type f -name '*calls.fastq*')
cat $simplexP1 $simplexP2 $simplexP3 $simplexP4 > $wkdir/basecalls/all_simplex_simplex.fastq.gz

# make directory for the assembly & move to it
mkdir -p $wkdir/raft_hifiasm_asm$attempt
cd $wkdir/raft_hifiasm_asm$attempt


####### STEP 1 ########
# run hifiasm on all duplex reads to obtain error corrected reads and coverage estimate
hifiasm \
-o errorcorrect \
-t 96 \
--write-ec \
$wkdir/basecalls/all_duplex.fastq.gz 2> errorcorrect.log
COVERAGE=$(grep "homozygous" errorcorrect.log | tail -1 | awk '{print $6}')

echo "step 1 is complete, the coverage for duplex reads is:"
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
-r 3 \
-ul $wkdir/basecalls/all_simplex_simplex.fastq.gz fragmented.reads.fasta 2> finalasm.log

echo "step 4 is complete, th final assembly files are:"

# list the final assembly files
ls finalasm*p_ctg.gfa

# convert the final assembly to fasta format
awk '/^S/{print ">"$2;print $3}' finalasm.bp.p_ctg.gfa > finalasm.bp.p_ctg.fasta









