#!/bin/bash

# Working out which Dorado model I want to use for the Rhino ONdata

# checked out the run info by copying this html file to my laptop & viewing it in chrome
#/mnt/waterprom/org_one/Black_Rhino_P1/20230118_1701_3G_PAM45394_c4a641a4/report_PAM45394_20230118_1707_c4a641a4.html

## analyte type = dna
## pore type = r10.4.1        FLO-PRO114M
## chemistry type = e8.2       SQK-LSK114 # this is v14 chemistry type
# translocation speed = ?      this was probably 400, that is the default but check
# model type = hac there are 3 types,The fast model is the quickest, sup is the most accurate, and hac provides a balance between speed and accuracy. For most users, the hac model is recommended.
# model version number = 


# Model to use for rhino data
#dna_r10.4.1_e8.2_400bps_sup@v4.1.0

# from Smaug, Rsync the pod5 files to oldprom
rsync -rvh --progress /data/test_data/org_one/black_rhino/pod5_files prom@10.157.252.10:/data/Laura/

# on the prom server on my tmux screen

# set variables
wkdir=/data/Laura/Rhino

# # download the basecalling models you want to use
# cd ~/dorado_models
# dorado download --model dna_r10.4.1_e8.2_400bps_fast@v4.1.0
# dorado download --model dna_r10.4.1_e8.2_400bps_hac@v4.1.0
# dorado download --model dna_r10.4.1_e8.2_400bps_sup@v4.1.0

# run the basecaller
/data/dorado-0.5.0-linux-x64/bin/dorado basecaller \
--recursive \
sup@latest \
$wkdir/pod5_files/ > $wkdir/rhino_calls/rhino_SUPlatest_calls.bam

#--emit-fastq \
#--modified-bases 5mCG_5hmCG / # add this line to also call methylation

# using the fast model dorado called the 3 files in 2 minutes (set batch size to 768, Simplex reads basecalled: 12000, Basecalled @ Samples/s: 1.412214e+07)
# using the hac model dorado called the 3 files in about 20 minutes (set batch size to 768, Simplex reads basecalled: 11999, Simplex reads filtered: 1, Basecalled @ Samples/s: 1.461328e+06)
# using the sup model dorado called the 3 files in about hilariously it estimates about 7 hours! (set batch size to 768, )


# to get some info on the basecalls
# create a conda install of fastcat software
#conda create --name fastcat -c conda-forge -c bioconda -c nanoporetech fastcat
conda activate fastcat
cd ~/rhino_calls

fastcat \
--file=black_rhino_calls.summary \
black_rhino_fast_calls.fastq black_rhino_hac_calls.fastq > tmp.fastq

conda deactivate


