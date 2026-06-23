#!/bin/bash

# Working out which Dorado model I want to use for the Rhino ONdata

# checked out the run info by copying this html file to my laptop & viewing it in chrome
/mnt/waterprom/org_one/Black_Rhino_P1/20230118_1701_3G_PAM45394_c4a641a4/report_PAM45394_20230118_1707_c4a641a4.html

## analyte type = dna
## pore type = r10.4.1        FLO-PRO114M
## chemistry type = e8.2       SQK-LSK114 # this is v14 chemistry type
# translocation speed = ?      this was probably 400, that is the default but check
# model type = hac there are 3 types,The fast model is the quickest, sup is the most accurate, and hac provides a balance between speed and accuracy. For most users, the hac model is recommended.
# model version number = 


# will use...
dna_r10.4.1_e8.2_400bps_sup@v4.2.0
# this one wouldn't work because it was 5khz and our data was done at 4khz so...
dna_r10.4.1_e8.2_400bps_sup@v4.1.0

# on the prom server on my tmux screen
export NXF_SINGULARITY_CACHEDIR=/data/graeme/sing_cache/
export SINGULARITY_TMPDIR=/data/graeme/sing_tmp/

wkdir=/data/laura
# Then, an example command to start the basecalling would be something like:

  nextflow run epi2me-labs/wf-basecalling \
    -profile singularity \
    --sample_name $SAMPLE \
    --input $wkdir/pod5_practice_files \
    --dorado_ext pod5 \
    --out_dir $wkdir/rhino_calls \
    --output_bam \
    --basecaller_cfg "dna_r10.4.1_e8.2_400bps_sup@v4.1.0" \
    --basecaller_basemod_threads 32




#--dorado_ext pod5 
#--remora_cfg "dna_r10.4.1_e8.2_400bps_sup@v4.2.0_5mCG_5hmCG@v2"
#--ref /path/to/reference.fa
#    -c my_config.cfg \
#    -resume
