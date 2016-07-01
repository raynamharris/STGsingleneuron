# STG Molecular Biology

## some problems
Okay, so this isn't a perfect repo. This is a hodgepod of data from the summer of 2015 when some students were doing qPCR data.
I'm not sure where their standard curve data are, so I just made up some cq data for the gene efficiencies. 
Also, I'm not really sure what the M and the Z stand for in the sample names, so they don't really fall into two conditions like muscle and stg nicely.

## So what's the point?!?
The whole reason I put this up on github is because I've perfected the data import and wrangling part of this process! Before, it took a lot of hand curation to get the data ready for MCMC.qpcr, but now we're all good.

## The good bits
- /bin/mcmc.qpcr.stg.rmh.R This is the script that is reproducible!
- /data_xls This is the directory with all the data exported from the machine. I know, why am I importing .xlxs files? Because that's what the machine spits out. :(
- /sample_info This is the directory with the sample info. I could have put this with the qpcr export files, but it seemed like a good idea to keep them separate

 
