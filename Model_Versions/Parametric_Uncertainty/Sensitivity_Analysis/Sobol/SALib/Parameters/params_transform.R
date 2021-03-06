###################################
# file: params.R
###################################
# Author and copyright: Perry Oddo
# Pennsylvania State University
# poddo@psu.edu
###################################
# Generates parameter files for SALib
# Sobol Sensitivity analysis
#################################### 

# Compile
rm(list = ls())
graphics.off()

# Set seed for reproducibility 
set.seed(1)

# Number of observations
n_obs = 10^4

# Prior parameter values - Section 6 "The Doubtful Constants," van Dantzig (1956)
source("../../../Scripts/priors.R")

# Sample parameters with LHS function
# Creates data.frame with parameter PDFs
source("Scripts/LHS.R")

# Number of Sobol samples [2N(p+1)]
n_samp = 2*1000*(length(priors)+1)

# Sample uniformly between [0,1]
q = seq(0,1, length.out = n_samp)

# Determine minimum/maximum Parameter values by finding 0% and 100% quantiles of distribution
min_param = 0

max_param = 1

params = data.frame(names(Parameters), min_param, max_param)

# Write .txt table for parameter names and values
write.table(params,
      file = "Parameters/params.txt",
      quote = FALSE,
      col.names = FALSE,
      row.names = FALSE,
      sep = " ")

