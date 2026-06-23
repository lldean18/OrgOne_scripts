#!/bin/bash

# create conda environment with blobtools on my Mac
#conda create --name blobtools

# activate conda env
conda activate blobtools

#conda install python=3.11
#pip install blobtoolkit
#pip install blobtoolkit-host

# set variables
wkdir=~/black_rhino


## got the taxdump by:
#mkdir /Users/lauradean/software/NewTaxDump
#cd /Users/lauradean/software/NewTaxDump
#wget https://ftp.ncbi.nlm.nih.gov/pub/taxonomy/new_taxdump/new_taxdump.tar.gz
#gunzip -c /Users/lauradean/software/NewTaxDump/new_taxdump.tar.gz | tar xf - 
## found the taxid by:
# twycross's black rhino is an eastern black rhino (Diceros bicornis michaeli)
grep -i "Diceros bicornis michaeli" /Users/lauradean/software/NewTaxDump/names.dmp
# taxid is 310714

# move to the working directory
cd $wkdir

# download the rhino assembly from smaug
scp mbzlld@smaug:/data/test_data/org_one/black_rhino/black_rhino_asm_002/assembly.fasta ./

# create your blobtools dataset
blobtools create \
    --fasta ./assembly.fasta \
    --taxid 310714 \
    --taxdump /Users/lauradean/software/NewTaxDump \
    ./Rhino

# copy the busco output that blobtools uses to my laptop
scp mbzlld@smaug:/data/test_data/org_one/black_rhino/black_rhino_asm_002/buscos/assembly_buscos1/run_laurasiatheria_odb10/full_table.tsv ./

# add the information from the busco run
blobtools add \
	--busco full_table.tsv \
	./Rhino

# add what info I do have from the diamond runs that finished
blobtools add \
--hits Rhino_full_diamond.out \
--taxrule bestsumorder \
--taxdump /Users/lauradean/software/NewTaxDump \
--replace \
./Rhino

# view the blobtools analysis
blobtools view \
--local Rhino

