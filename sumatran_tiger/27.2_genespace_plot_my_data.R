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




#########################################################################
# set the genomes you want it to run on
genomes2run <- c("hifiasm10", "RaftHifiasmAsm9")

# use genespace to parse the annotations
# this took a minute or so to run on the login node
parsedPaths <- parse_annotations(
  rawGenomeRepo = genomeRepo,
  genomeDirs = genomes2run,
  genomeIDs = genomes2run,
  gffString = "gff",
  faString = "fasta",
  headerEntryIndex = 1,
  gffIdColumn = "GeneID",
  genespaceWd = wd)



#  presets = "ncbi",



parsedPaths <- parse_annotations(
  rawGenomeRepo = "/genomeRepo", 
  genomeDirs = "species4_genoZ_v1.0_otherRepo",
  genomeIDs = "species4",
  gffString = "gff3",
  faString = "fa",
  headerEntryIndex = 1, 
  gffIdColumn = "GeneID",
  genespaceWd = "/path/to/GENESPACE/workingDir")



#########################################################################
# initialise the genespace run and set the run parameters
gpar <- init_genespace(
  wd = wd,
  path2mcscanx = path2mcscanx)

# run genespace
# This is the bit that should be run with srun or the whole thing via sbatch
# In testing it took... I think less than an hour 
out <- run_genespace(gpar, overwrite = T)



# This bit wasn't necessary as all the plots generated automatically
##########################################################################
## generate riparian plot
#ripd <- plot_riparian(
#  gsParam = out,
#  refGenome = "human", 
#  useRegions = FALSE)
#
## generate dotplot
#hits <- read_allBlast(
#  filepath = file.path(out$paths$syntenicHits, 
#                       "mouse_vs_human.allBlast.txt.gz"))
#ggdotplot(hits = hits, type = "all", verbose = FALSE)
