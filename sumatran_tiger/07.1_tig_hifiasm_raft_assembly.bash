#!/bin/bash
# Laura Dean
# 13/3/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=96
#SBATCH --mem=350g
#SBATCH --time=48:00:00
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
# #export PATH=$PATH:/gpfs01/home/mbzlld/software_bin/RAFT

# set environment variables
species=sumatran_tiger
wkdir=/gpfs01/home/mbzlld/data/OrgOne/$species # set the working directory

# make directory for the assembly & move to it
mkdir -p $wkdir/raft_hifiasm_asm
cd $wkdir/raft_hifiasm_asm

# get the list of duplex reads for input to hifiasm
cd /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/
find . -type f -name '*duplex.fastq.gz'


# ####### STEP 1 ########
# # ran in 30 mins on 96 cores with 52G memory usage (given 300GB)
# # run hifiasm on duplex reads to obtain error corrected reads and coverage estimate
# hifiasm \
# -o errorcorrect \
# -t 96 \
# --write-ec \
# $wkdir/basecalls/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/pod5_fail/SUPlatest_calls_duplex.fastq.gz \
# $wkdir/basecalls/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/pod5_pass/SUPlatest_calls_duplex.fastq.gz \
# $wkdir/basecalls/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/pod5_fail/SUPlatest_calls_duplex.fastq.gz \
# $wkdir/basecalls/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/pod5_pass/SUPlatest_calls_duplex.fastq.gz \
# $wkdir/basecalls/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/pod5_fail/SUPlatest_calls_duplex.fastq.gz \
# $wkdir/basecalls/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/pod5_pass/SUPlatest_calls_duplex.fastq.gz \
# $wkdir/basecalls/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/pod5_fail/SUPlatest_calls_duplex.fastq.gz \
# $wkdir/basecalls/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/pod5_pass/SUPlatest_calls_duplex.fastq.gz \
# $wkdir/basecalls/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/pod5_fail/SUPlatest_calls_duplex.fastq.gz \
# $wkdir/basecalls/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/pod5_pass/SUPlatest_calls_duplex.fastq.gz 2> errorcorrect.log
COVERAGE=$(grep "homozygous" errorcorrect.log | tail -1 | awk '{print $6}')

# echo $COVERAGE
# coverage was 9


# ####### STEP 2 ########
# # ran in 14 minutes on 96 cores with 52 GB memory used (given 300GB)
# # run hifiasm again to obtain all-vs-all read overlaps as a paf file
# hifiasm \
# -o getOverlaps \
# -t 96 \
# --dbg-ovec \
# errorcorrect.ec.fa 2> getOverlaps.log
# # Merge cis and trans overlaps
# cat getOverlaps.0.ovlp.paf getOverlaps.1.ovlp.paf > overlaps.paf



# ####### STEP 3 ########
# ran in 7 minutes on 1 core with 33GB memory used (given 100GB)
# # use raft to fragment the error corrected reads
# raft \
# -e ${COVERAGE} \
# -o fragmented \
# errorcorrect.ec.fa overlaps.paf



####### STEP 4.1 ########
# ran in 50 minutes on 96 cores with 93 GB memory used (given 100GB, this was close!)
# run hifiasm a third & final time to obtain assembly of fragmented reads
# integrate ultra long reads here as well
# A single round of error correction (-r1) is enough here
hifiasm \
-o finalasm \
-t 96 \
-ul $wkdir/basecalls/sumatran_tiger_P3/20230119_1328_1G_PAM34749_b65364c2/pod5/SUPlatest_calls.fastq.gz \
-r 1 \
fragmented.reads.fasta 2> finalasm.log

# list the final assembly files
ls finalasm*p_ctg.gfa
# -rw-r-----. 1 mbzlld domain users 2.2G Mar 14 10:45 finalasm.bp.p_ctg.gfa
# -rw-r-----. 1 mbzlld domain users 1.8G Mar 14 10:45 finalasm.bp.hap1.p_ctg.gfa
# -rw-r-----. 1 mbzlld domain users 1.1G Mar 14 10:46 finalasm.bp.hap2.p_ctg.gfa


# convert the final assembly to fasta format
awk '/^S/{print ">"$2;print $3}' finalasm.bp.p_ctg.gfa > finalasm.bp.p_ctg.fasta









