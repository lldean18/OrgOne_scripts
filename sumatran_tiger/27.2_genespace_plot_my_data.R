# to enter the genespace software env
#conda activate genespace4
#R


#########################################################################
# Load libraries
library(GENESPACE)

#########################################################################
# set paths for genespace to use 
wd <- "/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours3"
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
load('/gpfs01/home/mbzlld/data/OrgOne/sumatran_tiger/genespace_ours3/results/gsParams.rda', verbose = TRUE)

# set the chromosomes to be plotted inverted
invchr <- data.frame(
  genome = c("hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10", "hifiasm10","hifiasm10","hifiasm10", "hifiasm10","hifiasm10","hifiasm10",
	     "RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9","RaftHifiasmAsm9"),
  chr = c("ptg000003l","ptg000005l","ptg000006l","ptg000007l","ptg000010l","ptg000011l","ptg000013l","ptg000014l","ptg000017l","ptg000019l","ptg000021l","ptg000022l","ptg000023l","ptg000024l","ptg000026l","ptg000027l","ptg000029l","ptg000030l","ptg000031l","ptg000032l","ptg000033l","ptg000046l",
	  "ptg000001l","ptg000002l","ptg000006l","ptg000007l","ptg000008l","ptg000009l","ptg000010l","ptg000015l","ptg000016l","ptg000017l","ptg000018l","ptg000019l","ptg000022l","ptg000024l","ptg000025l","ptg000026l","ptg000029l","ptg000031l","ptg000034l","ptg000035l"))

# customise your riparian plot
ripDat <- plot_riparian(
  gsParam = gsParam,
  pdfFile = paste(gsParam$paths$riparian, "/MyOrder_SmlChrs.rip.pdf", sep = ""),
  refGenome = "DomesticCat",
  syntenyWeight = 1,
  minChrLen2plot = 0,
  invertTheseChrs = invchr,
  chrLabFun = function(x) gsub("^0", "", gsub("^anams1.0|chr|scaf|contig|chromosome|scaffold|^lg|_|^ptg000|l$", "", tolower(x))),
  genomeIDs = c("Flye4", "RaftHifiasmAsm9", "hifiasm10", "LigerHaplome", "DomesticCat"),
  forceRecalcBlocks = FALSE)

