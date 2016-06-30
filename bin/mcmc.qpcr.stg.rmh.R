##=============================================================================================================#
## Script created by Rayna Harris, rayna.harris@utexas.edu
## Script created in version R 3.3.1 
## This script is for analyzing data related to the STG qpcr projects
##=============================================================================================================#

##script stored in "Z:/NSB_2016/IntegrativeNeuroscience/STGsingleneuron2015/bin"
## set path to data dir
setwd("Z:/NSB_2016/IntegrativeNeuroscience/STGsingleneuron2015/data_xls")


## The process:
## 1. Loop over all experimental prjoect files and create one big "rawdata" dataframe
## 2. Clean the data to make numbers numbers and rename important columns
## 3. Wrangle standard curve data with dplyr and plyr package into a dataframe called dilutions
## 4. Calculate primer efficiences with MCMC.qpcr PrimEFF function
## 5. Wrangle sample info a with dplyr packag
## 6. Analyze data with MCMC.qpcr package

#install.packages("xlsx", dependencies = TRUE) #note, must have Java installed on computer
#install.packages("plyr")
#install.packages("dplyr")
#install.packages("MCMC.qpcr")
#install.packages("reshape2")
library(xlsx)
library(dplyr)
library(plyr)
library(MCMC.qpcr)
library(reshape2)

## 1. Loop over all experimental prjoect files and create one big "rawdata" dataframe
## uses read.xlsx function to read 1 sheet, sharting at row 8, nothing imported as a factor


file_list <- list.files() #creates a string will all the files in a diretory for us to loop through

rm(rawdata) # first removed any dataframe called rawdata

for (file in file_list){
  
  # if the merged dataset doesn't exist, create it
  if (!exists("rawdata")){
    rawdata <- read.xlsx(file, sheetIndex = 1, startRow=8, stringsAsFactors=FALSE)
  }
  
  # if the merged dataset does exist, append to it
  if (exists("rawdata")){
    temp_dataset <-read.xlsx(file, sheetIndex = 1, startRow=8, stringsAsFactors=FALSE)
    rawdata<-rbind(rawdata, temp_dataset)
    rm(temp_dataset)
  }
  
}


names(rawdata)
str(rawdata)

## 2. Clean data

cleandata <- rawdata
cleandata <- rename(cleandata, c("Sample.Name"="sample", "Target.Name"="gene",  "CÑ."="cq", "Quantity"="dna")) 
names(cleandata)
str(cleandata)
cleandata$dna <- as.numeric(cleandata$dna, na.rm = TRUE)
cleandata$cq <- as.numeric(cleandata$cq, na.rm = TRUE)
cleandata$gene <- as.factor(cleandata$gene)
str(cleandata)

## 2. Create dilutions dataframe with quantiry, target name, and ct. 
##    Then rename for MCMC.qpcr
dilutions <- cleandata %>%
  filter(Task == "STANDARD") %>%
  select(dna, cq, gene) 
str(dilutions)


## 3. Calculate primer efficiences with MCMC.qpcr PrimEFF function
PrimEff(dilutions) # makes a plot with the primer efficiencies
amp.eff <- PrimEff(dilutions) #creates a table with the primer efficiencies


## 4. create counts dataframe 
counts <- cleandata %>%
  filter(Task == "UNKNOWN") %>%
  select(Well, sample, gene,  cq) %>%
  dcast(Well + sample ~ gene )

## 5. Join count and sample info, sort by sample, order in logical fashion
samples <- read.csv("Z:/NSB_2016/IntegrativeNeuroscience/STGsingleneuron2015/sample_info/sample_info_2015.csv", header=TRUE, sep="," )

data <- inner_join(counts, samples) %>%
  arrange(sample) %>%
  select(sample, condition, CbNaV, IH, inx1, inx2)

## 6. Turn cq into counts

dd=cq2counts(
  data=data,
  genecols=c(3:6), # where the Cq data are in the data table
  condcols=c(1:2), # which columns contain factors
  effic=amp.eff,
  Cq1=37
)
head(dd)

## 7. Mixed model
mm=mcmc.qpcr(
  fixed="condition",
  random="sample",
  data=dd
)
summary(mm)

## 8. Mixed model with diagnostic plots
mmd=mcmc.qpcr(
  fixed="condition",
  random="sample",
  data=dd,
  pr=T,
  pl=T
)

diagnostic.mcmc(
  model=mmd,
  col="grey50",
  cex=0.8
)

## 9. Plot the data

HPDplot(
  model=mm,
  factors="conditionstg",
  main="STG vs Muscle"
)

s1=HPDsummary(model=mm,data=dd)
s0=HPDsummary(model=mm,data=dd,relative=TRUE)
