#!/bin/bash
# 20/4/26

# script to downsample the ref reads so they can be processed alongside the twelve

#SBATCH --job-name=prep_ref_ind
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=50g
#SBATCH --time=24:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out

# setup env
source $HOME/.bash_profile
conda activate minimap2
cd /gpfs01/home/mbzlld/data/ctenella/new_flowcell_calls

# start by mapping the raw ctenella ref reads to the polished reference
minimap2 \
-ax map-ont \
-t 16 \
/gpfs01/home/mbzlld/data/ctenella/ctenella_chagius_asm.fasta \
/gpfs01/home/mbzlld/data/ctenella/new_flowcell_calls/Ctenella_sup_3.5kb.fastq |
samtools sort --threads 16 -o Ctenella_sup_3.5kb.bam
samtools index --threads 16 Ctenella_sup_3.5kb.bam

# filter to retain only good mappings
samtools view \
-b \
-q 30 \
-F 260 \
Ctenella_sup_3.5kb.bam |
samtools sort --threads 16 -o Ctenella_sup_3.5kb_flt.bam
samtools index --threads 16 Ctenella_sup_3.5kb_flt.bam

# compute the current coverage of the reference bam
samtools depth \
Ctenella_sup_3.5kb_flt.bam |
awk '{sum+=$3} END {print sum/NR}' > Ctenella_sup_3.5kb_flt.bam.depth

# randomly subsample to the desired coverage
rasusa aln \
--coverage 22 \
Ctenella_sup_3.5kb_flt.bam |
samtools sort --threads 16 -o /gpfs01/home/mbzlld/data/ctenella/the_twelve/bams/remap_sort_barcoderef.bam
samtools index --threads 16 /gpfs01/home/mbzlld/data/ctenella/the_twelve/bams/remap_sort_barcoderef.bam
# save the final ind same as others but barcode ref

# check final depth
echo "the final depth of the downsampled bam file is:"
samtools depth \
/gpfs01/home/mbzlld/data/ctenella/the_twelve/bams/remap_sort_barcoderef.bam \
| awk '{sum+=$3} END {print sum/NR}'


conda deactivate

