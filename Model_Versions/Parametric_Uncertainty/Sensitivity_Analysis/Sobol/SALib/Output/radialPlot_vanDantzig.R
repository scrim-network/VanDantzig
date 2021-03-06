###################################
# file: radialPlot_vanDantzig.R
###################################
# Author and copyright: Perry Oddo
# Pennsylvania State University
# poddo@psu.edu
###################################
# Adapted from 'radialConvergeTest.R'
# Originally authored by: Calvin Whealton
# Cornell University
# caw324@cornell.edu
#################################### 
# Code for radial Sobol Analysis plot
# Original code available at:
# https://github.com/calvinwhealton/SensitivityAnalysisPlots
#################################### 

# Set working directory
# setwd("~/vanDantzig/Model_Versions/Uncertainty_SLR_GEV/Sensitivity_Analysis/Sobol/SALib/Output")

# Libraries----
library(RColorBrewer) # good color palettes
library(graphics)     # used when plotting polygons
library(plotrix)      # used when plotting circles

# Functions in other files
source('SensitivityAnalysisPlots-master/sigTests.R')
source('SensitivityAnalysisPlots-master/groupAssign.R')
source('SensitivityAnalysisPlots-master/plotRadSAinds.R')
source('../Scripts/upper.diag.R')

# Set number of parameters being analyzed
n_params = 7

# Set Sobol indices file name 
Sobol_file = "sobolIndices_damages.txt"

#################################### 
# Import data from sensitivity analysis

# First- and total-order indices
s1st <- read.csv(Sobol_file,#[i],
                  sep=' ',
                  header=TRUE,
                  nrows = n_params, 
                  as.is=c(TRUE,rep(FALSE,4)))

# Import second-order indices
s2_table <- read.csv(Sobol_file,#[i],
               sep=' ',
               skip = n_params+1,
               header=TRUE,
               as.is=c(TRUE,rep(FALSE,4)))

# Convert second-order to upper-triangular matrix
s2 <- matrix(nrow=n_params, ncol = n_params, byrow = FALSE)
s2[1:(n_params-1), 2:n_params] = upper.diag(s2_table$S2)
s2 <- as.data.frame(s2)
colnames(s2) <- rownames(s2) <- s1st$Parameter

# Convert confidence intervals to upper-triangular matrix
s2_conf <- matrix(nrow=n_params, ncol = n_params, byrow = FALSE)
s2_conf[1:(n_params-1), 2:n_params] = upper.diag(s2_table$S2_conf)
s2_conf <- as.data.frame(s2_conf)
colnames(s2_conf) <- rownames(s2_conf) <- s1st$Parameter

#################################### 
# Determine which indices are statistically significant
# S1 & ST: using the confidence intervals
#s1st1 <- stat_sig_s1st(s1st
#                      ,method="sig"
#                      ,sigCri='either')

# S1 & ST: using greater than a given value
s1st1 <- stat_sig_s1st(s1st
                      ,method="gtr"
                      ,greater=0.01
                      ,sigCri='either')

# S2: using the confidence intervals
#s2_sig1 <- stat_sig_s2(s2
#                       ,s2_conf
#                       ,method='sig')

# S2: using greater than a given value
s2_sig1 <- stat_sig_s2(s2
                       ,s2_conf
                       ,greater=0.01
                       ,method='gtr')

#################################### 
# Define groups for the variables and the color schemes
# Defining lists of the variables for each group
name_list1 <- list('Economic' = c('V_p', 'delta_prime_p', 'k_p')
                   ,'Sea Level' = c('subs_rate', 'sea_level_rate')
                   ,'Storm Surge' = c('p_zero_p', 'alpha_p'))

# add Parameter symbols to plot
name_symbols <- c(expression(p[0]), expression(alpha), 'V', expression(delta~"'"), 'k', expression(eta), expression(phi))

# Parameter descriptions
param_desc <- c("Initial flood freq.", "Flood freq. constant", "Value of goods", "Discount rate", 
                "Construction cost", "Subsidence Rate", "Sea level rate")

# defining color schemes
source("../Scripts/mycolors.R")

colScheme1 <- c(myblue, "red3", mygreen)

# defining list of colors for each group
col_list1 <- list("Economic" = colScheme1[1]
                  ,"Sea Level" = colScheme1[2]
                  ,"Storm Surge"=colScheme1[3])

# using function to assign variables and colors based on group
s1st1 <- gp_name_col(name_list1
                     ,col_list1
                     ,s1st1)

s1st1$symbols <- name_symbols

s1st1$desc <- param_desc

#s1st2 <- gp_name_col(name_list2
#                     , col_list2
#                     ,s1st2)

# plotting results
#pdf("Figures/test.pdf")
plotRadCon(df=s1st1
           ,s2=s2
           ,scaling = 1
           ,s2_sig=s2_sig1
           ,filename = 'Figures/damages5' 
           ,plotType = 'EPS'
           ,legLoc = "bottomcenter",cex = 1.5
            )

#dev.off()