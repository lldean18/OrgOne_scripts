#!/bin/bash
# code and info for download of the latest domestic cat genome



# move to where I will store the assembly files
cd ~/data/OrgOne/sumatran_tiger/domestic_cat_reference



# download the most recent version of the domestic cat genome assembly
# this was published in 2024
# the associated paper is here: https://doi.org/10.1016/j.jare.2024.10.023
# the website for downloading the genome and its associated files is here: https://cat.annotation.jp/download/AnAms1.0/
wget https://cat.annotation.jp/download/AnAms1.0/AnAms1.0.genome.fa.gz



# download the annotation file to go with the assembly
wget https://cat.annotation.jp/download/AnAms1.0/AnAms1.0r1.0.2.gff.gz

