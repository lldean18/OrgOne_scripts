# to enter the genespace software env
#conda activate genespace4
#R

#########################################################################
# Load libraries
library(GENESPACE)

#########################################################################
# set paths for genespace to use
wd <- "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours8"
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
load('/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours8/results/gsParams.rda', verbose = TRUE)



########################################################################
# genespace6/7/8 with final versions of ASMs to be included in the main figure

# set the chromosomes to be plotted inverted
invchr <- data.frame(
  genome = c("hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10","hifiasm10","hifiasm10", "hifiasm10","hifiasm10","hifiasm10",
             "LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome","LigerHaplome",
             "RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10","RaftHifiasmAsm10",
             "Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4","Flye4"),
  chr = c("ptg000003l","ptg000005l","ptg000006l","ptg000007l","ptg000010l","ptg000011l","ptg000013l","ptg000014l","ptg000017l","ptg000019l","ptg000021l","ptg000022l","ptg000023l","ptg000024l","ptg000026l","ptg000027l","ptg000029l","ptg000030l","ptg000031l","ptg000032l","ptg000033l","ptg000046l",
          "Contig9","Contig29","Contig31","Contig33","Contig34","Contig35","Contig36","Contig25","Contig26","Contig27","Contig3","Contig23","Contig52","Contig38","Contig13","Contig46","Contig53",
          "ptg000027l","ptg000017l","ptg000035l","ptg000015l","ptg000001l","ptg000019l","ptg000034l","ptg000029l","ptg000024l","ptg000003l","ptg000007l","ptg000018l","ptg000006l","ptg000020l","ptg000002l","ptg000008l","ptg000010l","ptg000016l",
          "contig_50","contig_67","contig_68","contig_60","contig_321","contig_354","contig_2","contig_1","contig_228","contig_343","contig_339","contig_687","contig_25","contig_685","contig_248","contig_163","contig_393","contig_276","contig_667","contig_555","contig_617","contig_139","contig_165","contig_271","contig_674","contig_227","contig_116"))





########################################################################
# customise your riparian plot
ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/MyOrder.rip.pdf", sep = ""),
  refGenome = "DomesticCat",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("DomesticCat","LigerHaplomeHiC"),
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("Flye4", "RaftHifiasmAsm10", "hifiasm10", "LigerHaplome","LigerHaplomeHiC", "DomesticCat"),
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
  pdfFile = paste(gsParam$paths$riparian, "/CatUnscaf_LigerUnscaf_hifiasm10_raft10.rip.pdf", sep = ""),
  refGenome = "DomesticCatContig",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("RaftHifiasmAsm10", "hifiasm10"),
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("RaftHifiasmAsm10", "hifiasm10", "LigerHaplome", "DomesticCatContig"),
  forceRecalcBlocks = FALSE)

#############################
# plot with all scaffolded HiC assemblies

ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/HiC_Cat_liger_hifiasm10.rip.pdf", sep = ""),
  refGenome = "DomesticCat",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  xlabel = NULL,
  labelTheseGenomes = c("DomesticCat","LigerHaplomeHiC","hifiasm10HiC"),
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("hifiasm10HiC","LigerHaplomeHiC", "DomesticCat"),
  forceRecalcBlocks = FALSE)



