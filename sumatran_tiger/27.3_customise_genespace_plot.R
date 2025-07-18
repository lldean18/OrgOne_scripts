# to enter the genespace software env
#conda activate genespace4
#R

#########################################################################
# Load libraries
library(GENESPACE)

#########################################################################
# set paths for genespace to use
wd <- "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours11"
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
#load('/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours6/results/gsParams.rda', verbose = TRUE)
#load('/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours7/results/gsParams.rda', verbose = TRUE)
#load('/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours8/results/gsParams.rda', verbose = TRUE)
#load('/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours9/results/gsParams.rda', verbose = TRUE)
load('/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours10/results/gsParams.rda', verbose = TRUE)
load('/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours11/results/gsParams.rda', verbose = TRUE)



########################################################################
# genespace6/7/8/9 with final versions of ASMs to be included in the main figure

# set the chromosomes to be plotted inverted
invchr <- data.frame(
  genome = c("hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10","hifiasm10","hifiasm10", "hifiasm10","hifiasm10","hifiasm10",
             "LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome",
             "RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10",
             "Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4",
	     "hifiasm10HiC","hifiasm10HiC",
	     "hifiasm9","hifiasm9","hifiasm9","hifiasm9","hifiasm9","hifiasm9","hifiasm9","hifiasm9","hifiasm9","hifiasm9","hifiasm9","hifiasm9"),
  chr = c("ptg000003l","ptg000005l","ptg000006l","ptg000007l","ptg000010l","ptg000011l","ptg000013l","ptg000014l","ptg000017l","ptg000019l","ptg000021l","ptg000022l","ptg000023l","ptg000024l","ptg000026l","ptg000027l","ptg000029l","ptg000030l","ptg000031l","ptg000032l","ptg000033l","ptg000046l",
          "Contig9","Contig29","Contig31","Contig33","Contig34","Contig35","Contig36","Contig25","Contig26","Contig27","Contig3","Contig23","Contig52","Contig38","Contig13","Contig46","Contig53",
          "ptg000027l","ptg000017l","ptg000035l","ptg000015l","ptg000001l","ptg000019l","ptg000034l","ptg000029l","ptg000024l","ptg000003l","ptg000007l","ptg000018l","ptg000006l","ptg000020l","ptg000002l","ptg000008l","ptg000010l","ptg000016l",
          "contig_50","contig_67","contig_68","contig_60","contig_321","contig_354","contig_2","contig_1","contig_228","contig_343","contig_339","contig_687","contig_25","contig_685","contig_248","contig_163","contig_393","contig_276","contig_667","contig_555","contig_617","contig_139","contig_165","contig_271","contig_674","contig_227","contig_116",
	  "scaffold_3", "scaffold_12",
	  "ptg000022l","ptg000010l","ptg000004l","ptg000019l","ptg000007l","ptg000008l","ptg000002l","ptg000024l","ptg000018l","ptg000013l","ptg000009l","ptg000016l"))








# make the background white so I can read the chr names easier
ggthemes <- ggplot2::theme(
  panel.background = ggplot2::element_rect(fill = "white"))


# set the chromosomes to be plotted inverted
invchr <- data.frame(
  genome = c("hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10","hifiasm10","hifiasm10", "hifiasm10","hifiasm10","hifiasm10",
             "Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger","Tiger",
             "HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm","HERRORAFThifiasm",
             "Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye","Flye",
             "hifiasm10HiC","hifiasm10HiC",
             "hifiasmONT","hifiasmONT","hifiasmONT","hifiasmONT","hifiasmONT","hifiasmONT","hifiasmONT","hifiasmONT","hifiasmONT","hifiasmONT","hifiasmONT","hifiasmONT"),
  chr = c("ptg000003l","ptg000005l","ptg000006l","ptg000007l","ptg000010l","ptg000011l","ptg000013l","ptg000014l","ptg000017l","ptg000019l","ptg000021l","ptg000022l","ptg000023l","ptg000024l","ptg000026l","ptg000027l","ptg000029l","ptg000030l","ptg000031l","ptg000032l","ptg000033l","ptg000046l",
          "Contig9","Contig29","Contig31","Contig33","Contig34","Contig35","Contig36","Contig25","Contig26","Contig27","Contig3","Contig23","Contig52","Contig38","Contig13","Contig46","Contig53",
          "ptg000005l","ptg000017l","ptg000035l","ptg000015l","ptg000001l","ptg000019l","ptg000034l","ptg000029l","ptg000024l","ptg000012l","ptg000007l","ptg000018l","ptg000006l","ptg000002l","ptg000014l","ptg000016l","ptg000023l","ptg000025l","ptg000011l","ptg000022l","ptg000033l","ptg000030l",
          "contig_127","contig_554","contig_214","contig_299","contig_308","contig_565","contig_167","contig_38","contig_322","contig_5","contig_53","contig_55","contig_67","contig_595","contig_285","contig_641","contig_215","contig_248","contig_681","contig_450",
	  "scaffold_3", "scaffold_12",
	  "ptg000022l","ptg000010l","ptg000004l","ptg000019l","ptg000007l","ptg000008l","ptg000002l","ptg000024l","ptg000018l","ptg000013l","ptg000009l","ptg000016l"))



#############################
# Main plot for MS

ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/MS_plot_no_synteny.rip.pdf", sep = ""),
  refGenome = "DomesticCat",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("hifiasmONT","Tiger","HERRORAFThifiasm","Flye"),
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("Flye","HERRORAFThifiasm","hifiasmONT", "Tiger", "DomesticCat"),
  forceRecalcBlocks = FALSE)

#,
#  addThemes = ggthemes


#############################
# PLot for supp mat

ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/MS_plot_supp_duplex.rip.pdf", sep = ""),
  refGenome = "DomesticCat",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("hifiasmONT","Tiger","HERRORAFThifiasm","Flye"),
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("HifiasmDuplex","Flye","HERRORAFThifiasm","hifiasmONT", "Tiger", "DomesticCat"),
  forceRecalcBlocks = FALSE)







########################################################################
# customise your riparian plot
ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/with_hifiasm11.rip.pdf", sep = ""),
  refGenome = "DomesticCat",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("DomesticCat"),
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("Flye4", "RaftHifiasmAsm10", "hifiasm10", "LigerHaplome","hifiasm11", "DomesticCat"),
  forceRecalcBlocks = FALSE)


#############################
# plot with only cat liger-hic and liger

ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/Cat_ligerHiC_liger.rip.pdf", sep = ""),
  refGenome = "DomesticCat",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("DomesticCat","LigerHaplomeHiC"),
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("LigerHaplome","LigerHaplomeHiC", "DomesticCat"),
  forceRecalcBlocks = FALSE)

#############################
# plot with only cat hifiasm10 and raft10

ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/Cat_hifiasm10_raft10.rip.pdf", sep = ""),
  refGenome = "DomesticCat",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = "DomesticCat",
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("RaftHifiasmAsm10", "hifiasm10", "DomesticCat"),
  forceRecalcBlocks = FALSE)

#############################
# plot with only cat-unscaffolded liger-ubnscaffolded and  hifiasm10 and raft10

ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/CatUnscaf_LigerUnscaf_hifiasm9_hifiasm10_raft10.rip.pdf", sep = ""),
  refGenome = "DomesticCatContig",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("hifiasm9"),
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("RaftHifiasmAsm10", "hifiasm10","hifiasm9", "LigerHaplome", "DomesticCatContig"),
  forceRecalcBlocks = FALSE)

#############################
# plot with all scaffolded HiC assemblies

ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/Scaffolded_cat_liger_hifiasm9.rip.pdf", sep = ""),
  refGenome = "DomesticCat",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("DomesticCat","LigerHaplomeHiC","hifiasm9HiC"),
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("hifiasm9HiC","LigerHaplomeHiC", "DomesticCat"),
  forceRecalcBlocks = FALSE)



