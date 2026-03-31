#!/bin/bash
# 30/3/26

# script to call variants for ctenella 12

#SBATCH --partition=defq
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=48
#SBATCH --mem=180g
#SBATCH --time=90:00:00
#SBATCH --job-name=Clair3_variant_call
#SBATCH --output=/gpfs01/home/mbzlld/code_and_scripts/slurm_out_scripts/slurm-%x-%j.out
#SBATCH --array=1-12
# --partition=ampere-mq
# --gres=gpu:A100-mig:1

# setup config
CONFIG=~/code_and_scripts/config_files/ctenella_the_twelve_config.txt
ind=$(awk -v ArrayTaskID=$SLURM_ARRAY_TASK_ID '$1==ArrayTaskID {print $2}' $CONFIG)
echo "slurm array = $SLURM_ARRAY_TASK_ID calling variants for sample $ind"


# install clair3
source $HOME/.bash_profile
#conda create -n clair3 -c conda-forge -c bioconda python=3.11 samtools whatshap parallel zstd xz zlib bzip2 automake make gcc gxx curl pigz
conda activate clair3
##  pip install uv
##  uv pip install torch torchvision --index-url https://download.pytorch.org/whl/cu126
##  cd ~/software_bin
##  git clone https://github.com/HKU-BAL/Clair3.git
##  cd Clair3
##  export CLAIR3_PATH=$(pwd)
##  uv pip install numpy h5py hdf5plugin numexpr tqdm cffi torchmetrics
##  cd ${CLAIR3_PATH}
##  make PREFIX=${CONDA_PREFIX}
##  wget https://downloads.python.org/pypy/pypy3.11-v7.3.20-linux64.tar.bz2
##  tar -xjf pypy3.11-v7.3.20-linux64.tar.bz2
##  rm pypy3.11-v7.3.20-linux64.tar.bz2
##  # Create symlinks for pypy3 and pypy into the conda environment bin directory
##  ln -s $(pwd)/pypy3.11-v7.3.20-linux64/bin/pypy3 ${CONDA_PREFIX}/bin/pypy3
##  ln -s $(pwd)/pypy3.11-v7.3.20-linux64/bin/pypy3 ${CONDA_PREFIX}/bin/pypy
##  # Install required packages for pypy3
##  pypy3 -m ensurepip
##  pypy3 -m pip install mpmath==1.2.1
##  #WARNING: The scripts pip3 and pip3.11 are installed in '/gpfs01/home/mbzlld/software_bin/Clair3/pypy3.11-v7.3.20-linux64/bin' which is not on PATH.
##  # Download pre-trained PyTorch models
##  cd ${CLAIR3_PATH}
##  mkdir -p models
##  wget -r -np -nH --cut-dirs=2 -R "index.html*" -P ./models https://www.bio8.cs.hku.hk/clair3/clair3_models_pytorch/
##  # test the install
##  ${CLAIR3_PATH}/run_clair3.sh
##  pip install -U --force-reinstall numpy # fix for error on first install
#module load cuda-uoneasy/12.6.0
cd /gpfs01/home/mbzlld/data/ctenella/the_twelve
mkdir -p variants

# set variables
CLAIR3_PATH=/gpfs01/home/mbzlld/software_bin/Clair3
MODEL_NAME=r1041_e82_400bps_sup_v500


# run clair3 to call variants for each ind
python3 ${CLAIR3_PATH}/run_clair3.py \
  --bam_fn=bams/map_sort_barcode${ind}_filtered_named.bam \
  --ref_fn=../ctenella_chagius_asm.fasta \
  --threads=48 \
  --platform="ont" \
  --model_path="${CLAIR3_PATH}/models/${MODEL_NAME}" \
  --output=variants/${ind} \
  --include_all_ctgs \
  --sample_name=barcode${ind} \
  --gvcf #\
#  --use_gpu


conda deactivate


