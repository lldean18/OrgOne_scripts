
# create conda environment
#conda create --name n50 -c bioconda n50
conda activate n50

# Set the assembly file you want to get stats for
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/raft_hifiasm_asm9/finalasm.bp.p_ctg.fasta
assembly=/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/hifiasm_asm11/ONTasm.bp.p_ctg.fasta

# print the n50 to the screen
n50 $assembly

