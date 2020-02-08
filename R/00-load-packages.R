if (!require("pacman")) install.packages("pacman")

pacman::p_load(
  "tidyverse",  # Data analysis
  "ggplot2",    # Plotting
  "hrbrthemes", # Themes for ggplot2
  "vroom",      # Fast reading of delimited files (e.g. csv)
  "lubridate",  # Handling time series data
  "esquisse"
)
