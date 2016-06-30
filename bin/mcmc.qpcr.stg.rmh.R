##=============================================================================================================#
## Script created by Rayna Harris, rayna.harris@utexas.edu
## Script created in version R 3.3.1 
## This script is for analyzing data related to the STG qpcr projects
##=============================================================================================================#

##script stored in "Z:/NSB_2016/IntegrativeNeuroscience/qPCR-mouse/Rayna/bin"
## set path to data dir
setwd("Z:/NSB_2016/IntegrativeNeuroscience/STGsingleneuron2015/data_xls")

## The process:
## 1. Read raw data xlsx package then clean
## 2. Wrangle standard curve data with dplyr and plyr package into a dataframe called dilutions
## 3. Calculate primer efficiences with MCMC.qpcr PrimEFF function
## 4. Wrangle sample info a with dplyr packag
## 4. Analyze data with MCMC.qpcr package

#install.packages("xlsx", dependencies = TRUE) #note, must have Java installed on computer
#install.packages("dplyr")
#install.packages("plyr")
#install.packages("MCMC.qpcr")
library(xlsx)
library(dplyr)
library(plyr)
library(MCMC.qpcr)

## 1. read raw data starting with row 42, then make quanitity a real number, then rename
setwd("target_dir/")

file_list <- list.files()

for (file in file_list){
  
  # if the merged dataset doesn't exist, create it
  if (!exists("dataset")){
    dataset <- read.table(file, header=TRUE, sep="\t")
  }
  
  # if the merged dataset does exist, append to it
  if (exists("dataset")){
    temp_dataset <-read.table(file, header=TRUE, sep="\t")
    dataset<-rbind(dataset, temp_dataset)
    rm(temp_dataset)
  }
  
}





rawdata <- read.xlsx("071715_inx1inx2_data.xls", sheetIndex = 1, startRow=8, stringsAsFactors=FALSE)
names(rawdata)
str(rawdata)
rawdata <- rename(rawdata, c("Sample.Name"="sample", "Target.Name"="gene",  "CÑ."="cq", "Quantity"="dna")) 
names(rawdata)
rawdata$dna <- as.numeric(rawdata$dna)
rawdata$cq <- as.numeric(rawdata$cq, na.rm = TRUE)



## 2. Create dilutions dataframe with quantiry, target name, and ct. 
##    Then rename for MCMC.qpcr
dilutions <- rawdata %>%
  filter(Task == "STANDARD") %>%
  select(dna,  cq, gene)
str(dilutions)


## 3. Calculate primer efficiences with MCMC.qpcr PrimEFF function
PrimEff(dilutions) # makes a plot with the primer efficiencies
eff <- PrimEff(dilutions) #creates a table with the primer efficiencies


## 4. create counts dataframe 
counts <- rawdata %>%
  filter(Task == "UNKNOWN") %>%
  select(sample, gene,  cq)
str(counts)



