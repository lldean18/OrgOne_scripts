#!/bin/bash
# 28/7/26

# trying repeatmasker with the docker container

#SBATCH --job-name=repeatmasker
#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=17
#SBATCH --mem=50g
#SBATCH --time=50:00:00
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out



# setup env
module load singularity/3.8.5
#cd ~/software_bin/singularity
#singularity build tetools.sif docker://dfam/tetools:latest
mkdir -p /gpfs01/home/mbzlld/data/ctenella/repeatmodeler
cd /gpfs01/home/mbzlld/data/ctenella/repeatmodeler
WKDIR=/gpfs01/home/mbzlld/data/ctenella/repeatmodeler
cp /gpfs01/home/mbzlld/data/ctenella/ctenella_chagius_asm.fasta ctenella_chagius_asm.fasta
assembly=ctenella_chagius_asm.fasta



# build repeatmasker database
echo "Running singularity contianer to build repeatmodeler database"
singularity exec -B ${WKDIR}:${WKDIR} ~/software_bin/singularity/tetools.sif BuildDatabase -name ctenella $assembly



# run repeatmodeler
echo "Running singularity contianer to run repeatmodeler"
singularity exec -B ${WKDIR}:${WKDIR} ~/software_bin/singularity/tetools.sif RepeatModeler -database ctenella -threads 16


## run repeat masker
#RepeatMasker -pa 16 -lib ctenella-families.fa -xsmall -gff $assembly


# cleanup env
module unload singularity/3.8.5

