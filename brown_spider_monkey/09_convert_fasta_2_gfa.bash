

# create conda environment
conda create -n graphtagger python=3.8

# activate conda environment
conda activate graphtagger

# install graphtagger
pip install git+https://github.com/Adamtaranto/GraphTagger.git

# convert fasta assembly to gfa format
# ran in a few seconds on a login node
fa2gfa \
-i /share/StickleAss/OrgOne/brown_spider_monkey/brown_spider_monkey_flye_asm/01_rundir/genome.nextpolish.fasta \
-o /share/StickleAss/OrgOne/brown_spider_monkey/brown_spider_monkey_flye_asm/01_rundir/genome.nextpolish.gfa



