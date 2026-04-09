#!/bin/bash
# Laura Dean
# 9/4/26

# script to generate tar archive for OrgOne ENA submission

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --tasks-per-node=1
#SBATCH --mem=10g
#SBATCH --time=48:00:00
#SBATCH --job-name=generate_tar_archive
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


cd /share/deepseq/matt/Ctenella/

# generate tar archive
tar -czf /share/deepseq/laura/ctenella/ctenella_chagius_pod5s.tar.gz \
IC_213/Ctenella_P3/20260126_1744_P2I-00136-A_PBG21759_b90d191e/pod5 \
IC_213/ctenella_p3/20260202_1648_P2I-00136-B_PBG21759_1a4a3b36/pod5

# generate md5 checksums
cd /share/deepseq/laura/ctenella
md5sum ctenella_chagius_pod5s.tar.gz > ctenella_chagius_pod5s.md5

