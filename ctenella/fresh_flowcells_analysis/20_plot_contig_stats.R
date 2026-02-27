
cd /gpfs01/home/mbzlld/data/ctenella/hifiasm_asm4 
conda activate r
R


library(ggplot2)
##install.packages("plotly")
#library(plotly)
#install.packages("scatterplot3d")
library(scatterplot3d)
options(scipen = 999)

df <- read.table("final_table.tsv", header = T)


##################################################
# 3D plot of contig length, depth and GC content #
##################################################

#Dplot <- plot_ly(x=df$length, y=df$GC, z=df$coverage, type="scatter3d", mode="markers", color=as.factor(df$taxid))

Dplot <- scatterplot3d(x=df$length, y=df$GC, z=df$coverage)
png(Dplot, 
       filename = "scatterplot3D.pdf"
       )



############################
# GC against contig length #
############################

plot <- ggplot(df, aes(length, GC, colour = as.factor(taxid))) +
	geom_point() +
	xlab("Contig length") +
	ylab("GC content") +
	scale_color_discrete(name = "TaxID")

ggsave(plot, 
       filename = "plot_1.pdf",
       device = "pdf",
       height = 6, width = 10, units = "in")


###############################
# depth against contig length #
###############################

plot <- ggplot(df, aes(length, coverage, colour = as.factor(taxid))) +
        geom_point() +
        xlab("Contig length") +
        ylab("depth of coverage") +
        scale_color_discrete(name = "TaxID")

ggsave(plot,
       filename = "plot_2.pdf",
       device = "pdf",
       height = 6, width = 10, units = "in")


############################
# depth against GC content #
############################

plot <- ggplot(df, aes(coverage, GC, colour = as.factor(taxid))) +
        geom_point() +
        xlab("depth of coverage") +
        ylab("GC content") +
        scale_color_discrete(name = "TaxID")

ggsave(plot,
       filename = "plot_3.pdf",
       device = "pdf",
       height = 6, width = 10, units = "in")



