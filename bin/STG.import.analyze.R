###setwd to source file location
library(reshape2) #for data wrangling
library(MCMC.qpcr) # for qPCR analysis
library(cowplot)
library(ggplot2)
#read ct file and convert to wide formate
ct <- read.csv("STGct.fixed.csv", header=TRUE)
ct_wide <- dcast(ct, sample + well + method + tissue + cell ~ gene, value.var="ct")

#read eff data
eff <- read.csv("STGeff2.csv", header=TRUE)

#convert ct to counts
qs=cq2counts(data=ct_wide, effic=eff, genecols=c(6:10),condcols=c(1:5), Cq1=37)

#model effects of RNA isolation
method=mcmc.qpcr(data=qs, fixed="method", random=c("well", "sample"), pr=TRUE,pl=TRUE)
diagnostic.mcmc(model=method, col="grey50")
summary(method)
plota=HPDsummary(model=method,data=qs,relative=F)
#plotb=HPDsummary(model=method,data=qs,relative=TRUE)

#model effects of cell type differences
cell=mcmc.qpcr(data=qs, fixed="cell", random=c("well", "sample"), pr=TRUE,pl=TRUE)
diagnostic.mcmc(model=cell, col="grey50")
summary(cell)
plotc=HPDsummary(model=cell,data=qs,relative=TRUE)
plotd=HPDsummary(model=cell,data=qs,relative=F)



#log transform
par(mfrow=c(1,1))
qs$log2counts<-log2((qs$count))
ggplot(qs, aes(x = cell, y = log2counts, fill = cell)) +
  geom_boxplot() +
  facet_wrap(~ gene)

par(mfrow=c(1,1))
ggplot(qs, aes(x = cell, y = count, fill = cell)) +
  geom_boxplot() +
  facet_wrap(~ gene)


ggplot(qs, aes(x = gene, y = log2counts, fill = cell)) +
  geom_boxplot() +
  facet_wrap(~ cell)


##correlations
qs_wide <- dcast(qs, sample + well + method + tissue + cell ~ gene, value.var="count")
write.table <- (qs_wide, "wide.csv")
pairs(~CbNaV+IH+inx1+inx2+shal,data=qs_wide, 
      main="Simple Scatterplot Matrix")

library(car)
scatterplot.matrix(~CbNaV+IH+inx1+inx2+shal|cell, data=qs_wide,
                   main="Three Cylinder Options")

library(car) 
scatterplot(inx1~inx2 | cell, data=qs.wide, 
            xlab="Weight of Car", ylab="Miles Per Gallon", 
            main="Enhanced Scatter Plot", 
            labels=row.names(mtcars))


#####muscle data
muscle <- read.csv("071715_inx1inx2_data.csv", header=TRUE)

#read eff data
eff <- read.csv("STGeff2.csv", header=TRUE)

#convert ct to counts
qs.muscle=cq2counts(data=muscle, effic=eff, genecols=c(4:6),condcols=c(1:3), Cq1=37)
qs.muscle$log2counts<-log2((qs.muscle$count))
#write.csv(qs.muscle, "qsmuscle.csv")
muscle.wide<-read.csv("qsmuscle.csv")

muscle=mcmc.qpcr(data=qs.muscle, fixed="crab+muscle+muscle:crab", random=c( "sample"), pr=TRUE,pl=TRUE, singular.ok=TRUE)
diagnostic.mcmc(model=muscle, col="grey50")
summary(muscle)
plotc=HPDsummary(model=muscle,data=qs.muscle,relative=TRUE)
plotd=HPDsummary(model=muscle,data=qs.muscle,relative=F)

muscle=mcmc.qpcr(data=qs.muscle, fixed="muscle", random=c( "sample"), pr=TRUE,pl=TRUE, singular.ok=TRUE)
diagnostic.mcmc(model=muscle, col="grey50")
summary(muscle)
plotc=HPDsummary(model=muscle,data=qs.muscle,relative=TRUE)
plotd=HPDsummary(model=muscle,data=qs.muscle,relative=F)

par(mfrow=c(1,1))
ggplot(qs.muscle, aes(x = muscle, y = log2counts, fill = muscle)) +
  geom_boxplot() +
  facet_wrap(~ gene)

par(mfrow=c(1,1))
ggplot(qs.muscle, aes(x = gene, y = log2counts, fill = gene)) +
  geom_boxplot() +
  facet_wrap(~ muscle)

attach(muscle.wide)
plot(inx1, inx2, main="Scatterplot Example", 
     xlab="Car Weight ", ylab="Miles Per Gallon ", pch=19)
attach(muscle.wide)
plot(inx1, ccapr, main="Scatterplot Example", 
     xlab="Car Weight ", ylab="Miles Per Gallon ", pch=19)

pairs(~inx1+inx2+ccapr,data=muscle.wide, 
      main="Simple Scatterplot Matrix")

library(corrplot)

M <- cor(muscle.wide)
corrplot(M, method = "ellipse")
