#!/bin/bash
# 1/6/26

# How i finally downloaded camel pod5 tar archives
# wget would not connect on Ada
# so ran in tumx window on balrog


# on balrog in tmux
wget ftp://ftp.sra.ebi.ac.uk/vol1/run/ERR128/ERR12834987/bactrian_camel_P1_207_pod5s.tar.gz
# checked md5sum and its correct
# now extract the tarball
tar -xvzf bactrian_camel_P1_207_pod5s.tar.gz
# then copy the archive to Ada (from ada in tmux)
srun --partition defq --cpus-per-task 1 --mem 10g --time 40:00:00 --pty bash
rsync -vha balrog:/data/laura/camel/20230207_1523_1E_PAM70941_44ae0edc /gpfs01/home/mbzlld/data/OrgOne/camel/pod5s/






# for the next one
wget ftp.sra.ebi.ac.uk/vol1/run/ERR128/ERR12834988/bactrian_camel_P1_209_pod5s.tar.gz
md5sum bactrian_camel_P1_209_pod5s.tar.gz
# extract
tar -xvzf bactrian_camel_P1_209_pod5s.tar.gz
# copy across








