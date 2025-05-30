
## create conda env for graph viewer and install it
#conda create -c almiheenko -c bioconda -n graph_viewer agb

# activate envionment
conda activate graph_viewer

# set env variables
spp_dir=/data/test_data/org_one/black_rhino # data directory for your species

assembly_dir=black_rhino_asm_002 # name of assembly directory
assembly_dir=Rhino_001_asm


# visualise assembly graph using flye output folder
 agb.py \
 -i $spp_dir/$assembly_dir \
 -o $spp_dir/$assembly_dir/agb_output \
 -a flye


