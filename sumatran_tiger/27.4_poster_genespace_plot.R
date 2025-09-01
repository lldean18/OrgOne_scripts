# to enter the genespace software env
conda activate genespace4
R

#########################################################################
# Load libraries
library(GENESPACE)

#########################################################################
# set paths for genespace to use
wd <- "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours12"
path2mcscanx <- "~/software_bin/miniconda3/envs/genespace4/bin/"

#########################################################################
# initialise the genespace run and set the run parameters
gpar <- init_genespace(
  wd = wd,
  path2mcscanx = path2mcscanx)

#########################################################################
# run genespace
# This is the bit that should be run with srun or the whole thing via sbatch
# In testing it took... I think less than an hour
out <- run_genespace(gpar, overwrite = T)

#########################################################################
# once you ran genespace, you can load the out object back into R using
load('/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours12/results/gsParams.rda', verbose = TRUE)




#########################################################################
# make the plot for the poster

# make the background white
ggthemes <- ggplot2::theme(
  panel.background = ggplot2::element_rect(fill = "white"))

# set the chromosomes to be plotted inverted
invchr <- data.frame(
  genome = c("hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10","hifiasm10","hifiasm10", "hifiasm10","hifiasm10","hifiasm10",
             "TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome","TigerHaplome",
             "HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm","HerroRaftHifiasm",
             "Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye",
             "hifiasm10HiC","hifiasm10HiC",
             "HifiasmOnt","HifiasmOnt","HifiasmOnt","HifiasmOnt","HifiasmOnt","HifiasmOnt","HifiasmOnt","HifiasmOnt","HifiasmOnt","HifiasmOnt","HifiasmOnt","HifiasmOnt"),
  chr = c("ptg000003l","ptg000005l","ptg000006l","ptg000007l","ptg000010l","ptg000011l","ptg000013l","ptg000014l","ptg000017l","ptg000019l","ptg000021l","ptg000022l","ptg000023l","ptg000024l","ptg000026l","ptg000027l","ptg000029l","ptg000030l","ptg000031l","ptg000032l","ptg000033l","ptg000046l",
          "Contig9","Contig29","Contig31","Contig33","Contig34","Contig35","Contig36","Contig25","Contig26","Contig27","Contig3","Contig23","Contig52","Contig38","Contig13","Contig46","Contig53",
          "ptg000005l","ptg000017l","ptg000035l","ptg000015l","ptg000001l","ptg000019l","ptg000034l","ptg000029l","ptg000024l","ptg000012l","ptg000007l","ptg000018l","ptg000006l","ptg000002l","ptg000014l","ptg000016l","ptg000023l","ptg000025l","ptg000011l","ptg000022l","ptg000033l","ptg000030l",
          "contig_127","contig_554","contig_214","contig_299","contig_308","contig_565","contig_167","contig_38","contig_322","contig_5","contig_53","contig_55","contig_67","contig_595","contig_285","contig_641","contig_215","contig_248","contig_681","contig_450",
	  "scaffold_3", "scaffold_12",
	  "ptg000022l","ptg000010l","ptg000004l","ptg000019l","ptg000007l","ptg000008l","ptg000002l","ptg000024l","ptg000018l","ptg000013l","ptg000009l","ptg000016l"))



#############################
# Main plot for poster

customPal <- colorRampPalette(
  c("darkorange","yellow", "skyblue", "darkblue", "purple", "darkred", "salmon"))

ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/Poster_plot.rip.pdf", sep = ""),
  refGenome = "DomesticCatScaffolded",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("HifiasmOntScaffolded","DomesticCatScaffolded"),
  invertTheseChrs = invchr,
  braidAlpha = .85,
  palette = customPal,
  addThemes = ggthemes,
  chrFill = "lightgrey",
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("Flye", "HerroRaftHifiasm", "HifiasmOnt", "HifiasmOntScaffolded","DomesticCatScaffolded"),
  forceRecalcBlocks = FALSE)


