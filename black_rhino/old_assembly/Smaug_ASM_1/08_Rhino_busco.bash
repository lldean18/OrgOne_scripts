###########################################################
# Run in Tmux window

# load your bash profile for using conda
source $HOME/.bash_profile

# create conda env with busco install (had to use mamba, conda hung forever)
#mamba create -n busco
mamba activate busco
#mamba install -c conda-forge -c bioconda busco=5.5.0 -y



###########################################################
# run busco for all assemblies you want to compare by changing the assembly folder below

# set environment variables
spp_dir=/data/test_data/org_one/black_rhino # data directory for your species
#assembly_dir=black_rhino_asm_002 # name of my new assembly directory
#assembly_dir=Rhino_001_asm # name of the original assembly directory
assembly_dir=Rhino_asm_PASSonly
assembly_name=assembly # name of assembly fasta file

# make a directory to put the busco results in
mkdir -p $spp_dir/$assembly_dir/buscos

# decide what lineage dataset you will use for your species
#busco --list-datasets

# run busco
# --in : input assembly in fasta format
# --lineage_dataset nearest class in the busco database for your species
# --mode specify you are working on a genome assembly
# --out name the output files
# --out_path specify the path to your desired output directory
# --cpu specify number of cores to use
busco \
--in $spp_dir/$assembly_dir/${assembly_name}.fasta \
--lineage_dataset laurasiatheria_odb10 \
--mode genome \
--out ${assembly_name}_buscos1 \
--out_path $spp_dir/$assembly_dir/buscos \
--cpu 8

# deactivate conda
mamba deactivate

