rm(list = ls())

# Load data.table & dtplyr interface
library(data.table)
library(dplyr)
library(dtplyr)

# Core Tidyverse - Loads dplyr
library(tidyverse)
library(ggplot2)
library(hrbrthemes)
# Fast reading of delimited files (e.g. csv)
library(vroom) # vroom()

# Timing operations
library(tictoc)
library(lubridate)

# Table Printing
library(knitr) # kable()
library(esquisse)

# Read data
path_data <- "household_power_consumption.txt"

col_types_data <- list(
  date                            = col_character(),
  time                            = col_character(),
  global_active_power             = col_double(),
  global_reactive_power           = col_double(),
  voltage                         = col_double(),
  global_intensity                = col_double(),
  sub_metering_1                  = col_double(),
  sub_metering_2                  = col_double(),
  sub_metering_3                  = col_double()
)

df <- vroom(
  file       = path_data, 
  delim      = ";", 
  col_names  = names(col_types_data),
  col_types  = col_types_data,
  na         = c("", "NA", "NULL")) %>%
  slice(-1) %>%
  mutate(date_time = paste(date, time)) %>%
  mutate(date_time = as.POSIXct(date_time, format="%d/%m/%Y %H:%M:%S", tz=Sys.timezone())) %>%
  mutate(date = as.Date(date, format = "%d/%m/%Y")) %>%
  mutate(year = format(date, "%Y")) %>%
  mutate(year = as.numeric(year)) %>%
  mutate(month = format(date, "%m")) %>%
  mutate(month = as.numeric(month)) 

glimpse(df)

# Daily GAP
daily_gap <- df %>%
  group_by(date) %>%
  summarise(global_active_power = median(global_active_power)) %>%
  mutate(year = format(date, "%Y")) %>%
  mutate(year = as.numeric(year)) %>%
  mutate(month = format(date, "%m")) %>%
  mutate(month = as.numeric(month)) %>%
  ggplot() +
  aes(x = date, y = global_active_power, colour = month) +
  geom_line(size = 1L) +
  scale_color_distiller(palette = "Spectral") +
  labs(x = "Year", y = "Global Active Power", title = "Daily Global Active Power") +
  theme_ft_rc()

daily_gap

# Weekly GAP
weekly_gap <- df %>%
  mutate(week = isoweek(date)) %>%
  group_by(year, week) %>%
  summarise(global_active_power = median(global_active_power, na.rm = TRUE),
            date = min(date),
            month = median(month)) %>%
  ggplot() +
  aes(x = date, y = global_active_power, colour = month) +
  geom_line(size = 1L) +
  labs(x = "Year", y = "Global Active Power", title = "Weekly Global Active Power") +
  scale_color_distiller(palette = "Spectral") +
  theme_ft_rc()

weekly_gap

# Monthly GAP
monthly_gap <- df %>%
  group_by(year, month) %>%
  summarise(global_active_power = median(global_active_power, na.rm = TRUE),
            date = min(date)) %>%
  ggplot() +
  aes(x = date, y = global_active_power, colour = month) +
  geom_line(size = 1L) +
  labs(x = "Year", y = "Global Active Power", title = "Monthly Global Active Power") +
  scale_color_distiller(palette = "Spectral") +
  theme_ft_rc()

monthly_gap