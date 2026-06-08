#!/bin/bash
# 5/6/2026


#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=50g
#SBATCH --time=100:00:00
#SBATCH --job-name=ENA_bam_submission
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out


# set bam file for upload
#bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P1/20230111_1737_3D_PAM34692_e5400fa7/pod5/tig_P1_SUP_basecalls.bam
#bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P2/20230113_1342_3F_PAM70827_70386f08/pod5/tig_P2_SUP_basecalls.bam
#bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P3/20230119_1328_1G_PAM34749_b65364c2/pod5/tig_P3_SUP_basecalls.bam
#bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_P4/20230207_1523_1C_PAO11037_b4b86f62/pod5_pass/tig_P4_SUP_basecalls_pass.bam
#bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/pod5_pass/tig_duplex_SUP_basecalls_pass.bam
#bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/pod5_pass/tig_duplex_P2_SUP_basecalls_pass.bam
#bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/pod5_pass/tig_duplex_P3_SUP_basecalls_pass.bam
#bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/pod5_pass/tig_duplex_ns_222_SUP_basecalls_pass.bam
bam=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/pod5_pass/tig_duplex_ns_223_SUP_basecalls_pass.bam


# submit the bam file to ENA
curl --upload-file $bam --user Webin-154:******** ftp://webin2.ebi.ac.uk

echo "finished submission for file $bam"


