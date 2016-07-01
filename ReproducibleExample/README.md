# Reproducible Example

The directory contains the R script and data necessary to create the plot in the results folder. 

## bin/mcmc.qpcr.stg.rmh.R
The `mcmc.qpcr.stg.rmh.R` script was written with two main goals:
  
1. reproducibly import raw qPCR data and wrangle it for analysis
2. analyze the data and generate some pretty plots  

In practice, this is a multi-step process, but I think the script details all the steps well. 

For an in depth tutorial on using the **MCMC.qpcr R package**, check out [the MCMC.qpcr tutorial](http://www.bio.utexas.edu/research/matz_lab/matzlab/Methods.html) on the Matz lab website. Aso, be sure to [read the paper](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0071448)!

## data
This directory contains three types of data files:  

1. `.sds` files from the StepOne Plus.
2. `.xlxs` files that were exported from the StepOne Plus. Note, these files have not be hand-curated. If you have the StepOnePlusSoftware, you can export them for yourself and rerun the analysis.
3. a `.csv` file with additional sample information was recorded during the tissue collection and processing steps (but not input into the qPCR machine)

The data was collected in 2015 by students in the NS&B coures. We were comparing two different RNA isolation methods: Maxwell and Zymo. **Disclaimer**: When I was making this example, I couldn't find the raw data that contained the serial dilution series necessary to generate the standard curve, so I just made up some cq data for the gene efficiencies, based on the data from Misha's tutorial (see 000000_std_data.xls). 

## Results
There are a number of intermediate dataframe created in R that could be saved as results, but I prefer to just leave those in the R environment. I also create a handful of plots, but I only save 1 of them. You can view it here!
![Plot](results/HPDsummary.png) 
