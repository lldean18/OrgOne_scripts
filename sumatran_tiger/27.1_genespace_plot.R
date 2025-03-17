
# Load libraries
library(GENESPACE)

# set paths for genespace to use 
genomeRepo <- "~/path/to/store/rawGenomes"
wd <- "~/path/to/genespace/workingDirectory"
path2mcscanx <- "~/path/to/MCScanX/"

# initialise the genespace run and set the run parameters
gpar <- init_genespace(
  wd = wd,
  path2mcscanx = path2mcscanx)

# run genespace
out <- run_genespace(gpar, overwrite = T)

# generate riparian plot
ripd <- plot_riparian(
  gsParam = out,
  refGenome = "human", 
  useRegions = FALSE)

# generate dotplot
hits <- read_allBlast(
  filepath = file.path(out$paths$syntenicHits, 
                       "mouse_vs_human.allBlast.txt.gz"))
ggdotplot(hits = hits, type = "all", verbose = FALSE)

