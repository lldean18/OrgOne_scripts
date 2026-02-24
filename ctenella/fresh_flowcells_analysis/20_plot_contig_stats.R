
cd 
conda activate r
R


library(ggplot2)
options(scipen = 999)

df <- read.table("final_table.tsv", header = T)

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



