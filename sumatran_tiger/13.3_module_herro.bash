#!/bin/bash
# Laura Dean
# 15/5/24
# for running on Ada

#SBATCH --partition=ampereq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --gres=gpu:2
#SBATCH --mem=747g
#SBATCH --time=160:00:00
#SBATCH --job-name=herroTEST
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# load your bash environment (for using conda)
source $HOME/.bash_profile


# set variables
raw_fastq=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/basecalls/all_simplex_simplex.fastq.gz

# # preprocess reads input fastq, output prefix, number of threads, number of parts to split job into (if low mem)
# /gpfs01/home/mbzlld/software_bin/herro/scripts/preprocess.sh $raw_fastq ${raw_fastq%.*.*}_preprocessed 20 1
# # the command before this used one core
# # pigz used all 20 cores at max cpu and ~500GB memory
# # duplex_tools only used 1 core and ~30GB memory
# had to run this bit on the hmemq with 1495g mem 20 cores & 20 hours


# # minimap2 alignment and batching
# # get the read id's using seqkit
# #conda create --name seqkit
# conda activate seqkit
# #conda install -c conda-forge -c bioconda seqkit
# seqkit seq -ni --threads 40 ${raw_fastq%.*.*}_preprocessed.fastq.gz > ${raw_fastq%.*.*}_preprocessed_readIDs
# conda deactivate

# conda activate herro
# # scripts/create_batched_alignments.sh <output_from_reads_preprocessing> <read_ids> <num_of_threads> <directory_for_batches_of_alignments> 
# /gpfs01/home/mbzlld/software_bin/herro/scripts/create_batched_alignments.sh \
# ${raw_fastq%.*.*}_preprocessed.fastq.gz ${raw_fastq%.*.*}_preprocessed_readIDs 40 ${raw_fastq%.*.*}_preprocessed_batches
# conda deactivate
# # ran this bit on hmemq with 40 cores and 1495g mem & 20 hours
# # it used the cores pretty efficiently, but max memory use was only ~90Gb so didn't need the hmemq. took 11hrs to run


echo "These are the CUDA_VISIBLE_DEVICES: $CUDA_VISIBLE_DEVICES
"

# load the herro module
module load herro-uon/gcc12.3.0/0.1.0

# run herro
# this bit will need the GPU partition
# herro inference --read-alns <directory_alignment_batches> -t <feat_gen_threads_per_device> -d <gpus> -m <model_path> -b <batch_size> <preprocessed_reads> <fasta_output> 
# -b (batch size) Recommended batch size is 64 for GPUs with 40 GB (possibly also for 32 GB) of VRAM and 128 for GPUs with 80 GB of VRAM.
# -t number of threads per GPU card
# -d names of the GPUs
herro inference \
--read-alns ${raw_fastq%.*.*}_preprocessed_batches \
-t 8 \
-d $CUDA_VISIBLE_DEVICES \
-m /gpfs01/home/mbzlld/software_bin/herro/model_v0.1.pt \
-b 128 \
${raw_fastq%.*.*}_preprocessed.fastq.gz ${raw_fastq%.*.*}_herro_corrected_TEST.fa.gz


