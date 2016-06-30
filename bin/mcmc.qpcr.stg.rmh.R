##=============================================================================================================#
## Script created by Rayna Harris, rayna.harris@utexas.edu
## Script created in version R 3.3.1 
## This script is for analyzing data related to the STG qpcr projects
##=============================================================================================================#

##script stored in "Z:/NSB_2016/IntegrativeNeuroscience/qPCR-mouse/Rayna/bin"
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
#install.packages("dplyr")
#install.packages("plyr")
#install.packages("MCMC.qpcr")
library(xlsx)
library(dplyr)
library(plyr)
library(MCMC.qpcr)


## 1. Loop over all experimental prjoect files and create one big "rawdata" dataframe
## uses read.xlsx function to read 1 sheet, sharting at row 8, nothing imported as a factor
## NOTE! besure to clean enviornment before running this!

file_list <- list.files() #creates a string will all the files in a diretory for us to loop through

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



## 2. Create dilutions dataframe with quantiry, target name, and ct. 
##    Then rename for MCMC.qpcr
dilutions <- cleandata %>%
  filter(Task == "STANDARD") %>%
  select(dna, cq, gene) 
str(dilutions)


## 3. Calculate primer efficiences with MCMC.qpcr PrimEFF function
PrimEff(dilutions) # makes a plot with the primer efficiencies
eff <- PrimEff(dilutions) #creates a table with the primer efficiencies


## 4. create counts dataframe 
counts <- cleandata %>%
  filter(Task == "UNKNOWN") %>%
  select(sample, gene,  cq)
str(counts)



