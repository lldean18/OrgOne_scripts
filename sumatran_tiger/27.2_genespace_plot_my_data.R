# to enter the genespace software env
#conda activate genespace4
#R


#########################################################################
# Load libraries
library(GENESPACE)


#########################################################################
# set paths for genespace to use 
genomeRepo <- "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours/data"
wd <- "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours"
path2mcscanx <- "~/software_bin/miniconda3/envs/genespace4/bin/"




##########################################################################
## set the genomes you want it to run on
#genomes2run <- c("hifiasm10", "RaftHifiasmAsm9")



#########################################################################
# initialise the genespace run and set the run parameters
gpar <- init_genespace(
  wd = wd,
  path2mcscanx = path2mcscanx)

# run genespace
# This is the bit that should be run with srun or the whole thing via sbatch
# In testing it took... I think less than an hour 
out <- run_genespace(gpar, overwrite = T)



