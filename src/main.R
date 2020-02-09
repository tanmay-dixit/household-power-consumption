# This master script is responsible for running data analysis

rm(list = ls())

# curr_dir <- "../household-power-consumption/R"
# setwd(curr_dir)
  
source("00-load-packages.R")
source("01-read-raw-data.R")
source("02-generate-seasonal-plots.R")