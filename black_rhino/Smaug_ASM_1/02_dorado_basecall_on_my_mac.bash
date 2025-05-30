
# transfer a couple rhino pod5 files from smaug to my mac
scp mbzlld@10.157.200.14:/data/test_data/org_one/black_rhino/pod5_files/pod5_P1/PAM45394_c4a641a4_d3469262_94.pod5 ./rhino_pod5/
scp mbzlld@10.157.200.14:/data/test_data/org_one/black_rhino/pod5_files/pod5_P1/PAM45394_c4a641a4_d3469262_8.pod5 ./rhino_pod5/
scp mbzlld@10.157.200.14:/data/test_data/org_one/black_rhino/pod5_files/pod5_P1/PAM45394_c4a641a4_d3469262_50.pod5 ./rhino_pod5/

# install dorado using the code in install_dorado.bash in deepseq info folder

# download the basecalling models you want to use
cd ~/dorado_models
dorado download --model dna_r10.4.1_e8.2_400bps_fast@v4.2.0
dorado download --model dna_r10.4.1_e8.2_400bps_hac@v4.2.0
dorado download --model dna_r10.4.1_e8.2_400bps_sup@v4.2.0
# Turns out 4.2.0 has sampling at 5khz and the rhino data was collected with sampling at 4khz so reduce to compatable version
dorado download --model dna_r10.4.1_e8.2_400bps_fast@v4.1.0
dorado download --model dna_r10.4.1_e8.2_400bps_hac@v4.1.0
dorado download --model dna_r10.4.1_e8.2_400bps_sup@v4.1.0

# run the basecaller
speed=sup
dorado basecaller \
--emit-fastq \
~/dorado_models/dna_r10.4.1_e8.2_400bps_${speed}@v4.1.0 \
~/rhino_pod5/ > rhino_calls/black_rhino_${speed}_calls.fastq

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


