##
## File: plot_coverage.R
## 

library(ggplot2)

df = read.table(snakemake@input[["txt"]], comment.char="", header=TRUE)
colnames(df)[colnames(df) == "X.rname"] <- "rname"

png(snakemake@output[["png"]])
print(ggplot(df, aes(x=factor(rname), y=meandepth)) + geom_point() + theme(axis.text.x = element_text(angle=90)))
dev.off()
                
