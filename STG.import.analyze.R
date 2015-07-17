###setwd to source file location
library(reshape2) #for data wrangling
library(MCMC.qpcr) # for qPCR analysis
#read ct file and convert to wide formate
ct <- read.csv("STGct.csv", header=TRUE)
ct_wide <- dcast(ct, sample + well + method + tissue + cell ~ gene, value.var="ct")

#read eff data
eff <- read.csv("STGeff2.csv", header=TRUE)

#convert ct to counts
qs=cq2counts(data=ct_wide, effic=eff, genecols=c(6:10),condcols=c(1:5), Cq1=37)

#model effects of RNA isolation
method=mcmc.qpcr(data=qs, fixed="method", random=c("well", "sample"), pr=TRUE,pl=TRUE, singular.ok=TRUE )
diagnostic.mcmc(model=method, col="grey50")
summary(method)
poltb=HPDsummary(model=method,data=qs,relative=TRUE)
polta=HPDsummary(model=method,data=qs,relative=F)

#model effects of cell type differences
cell=mcmc.qpcr(data=qs, fixed="cell", pr=TRUE,pl=TRUE, singular.ok=TRUE )
diagnostic.mcmc(model=cell, col="grey50")
summary(cell)
poltb=HPDsummary(model=cell,data=qs,relative=TRUE)
polta=HPDsummary(model=cell,data=qs,relative=F)

