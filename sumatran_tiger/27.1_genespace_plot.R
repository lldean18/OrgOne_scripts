#########################################################################
# Load libraries
library(GENESPACE)


#########################################################################
# set paths for genespace to use 
genomeRepo <- "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace/data"
wd <- "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace"
path2mcscanx <- "~/software_bin/miniconda3/envs/genespace4/bin/MCScanX"



#########################################################################
# download the practice data
urls <- c(
  human ="000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_",
  mouse = "000/001/635/GCF_000001635.27_GRCm39/GCF_000001635.27_GRCm39_",
  platypus = "004/115/215/GCF_004115215.2_mOrnAna1.pri.v4/GCF_004115215.2_mOrnAna1.pri.v4_",
  chicken = "016/699/485/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b/GCF_016699485.2_bGalGal1.mat.broiler.GRCg7b_",
  sandLizard = "009/819/535/GCF_009819535.1_rLacAgi1.pri/GCF_009819535.1_rLacAgi1.pri_")

genomes2run <- names(urls)
urls <- file.path("https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF", urls)
translatedCDS <- sprintf("%stranslated_cds.faa.gz", urls)
geneGff <- sprintf("%sgenomic.gff.gz", urls)

names(translatedCDS) <- genomes2run
names(geneGff) <- genomes2run
writeDirs <- file.path(genomeRepo, genomes2run)
names(writeDirs) <- genomes2run
for(i in genomes2run){
  print(i)
  if(!dir.exists(writeDirs[i]))
    dir.create(writeDirs[i])
  download.file(
    url = geneGff[i], 
    destfile = file.path(writeDirs[i], basename(geneGff[i])))
  download.file(
    url = translatedCDS[i], 
    destfile = file.path(writeDirs[i], basename(translatedCDS[i])))
}


#########################################################################
# use genespace to parse the annotations
genomes2run <- c("human", "mouse", "platypus", "chicken", "sandLizard")
parsedPaths <- parse_annotations(
  rawGenomeRepo = genomeRepo,
  genomeDirs = genomes2run,
  genomeIDs = genomes2run,
  presets = "ncbi",
  genespaceWd = wd)




#########################################################################
# initialise the genespace run and set the run parameters
gpar <- init_genespace(
  wd = wd,
  path2mcscanx = path2mcscanx)

# run genespace
out <- run_genespace(gpar, overwrite = T)




#########################################################################
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
