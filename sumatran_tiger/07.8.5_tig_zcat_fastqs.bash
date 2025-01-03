#!/bin/bash
# Laura Dean
# 17/12/24
# for running on Ada

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=100g
#SBATCH --time=36:00:00
#SBATCH --job-name=tig_merge_fqs
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out




zcat \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_simplex_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/pod5_fail/SUPlatest_calls_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex/20230221_1715_2D_PAK99090_77cd6ba1/pod5_pass/SUPlatest_calls_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/pod5_fail/SUPlatest_calls_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230223_1304_2D_PAK99090_d47818d2/pod5_pass/SUPlatest_calls_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/pod5_fail/SUPlatest_calls_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_ns/20230222_1213_2D_PAK99090_a9de44bc/pod5_pass/SUPlatest_calls_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/pod5_fail/SUPlatest_calls_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P2/20230307_1702_1G_PAK99084_16f44a88/pod5_pass/SUPlatest_calls_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/pod5_fail/SUPlatest_calls_simplex.fastq.gz \
/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/sumatran_tiger_duplex_P3/20230309_1159_2G_PAK98873_d39c7c8c/pod5_pass/SUPlatest_calls_simplex.fastq.gz | gzip > /gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/ALL_simplex_zcat.fastq.gz



