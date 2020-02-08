data_path <- "../data/raw/household_power_consumption.txt"

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

semi_colon <- ";"

na_candidates <- c("", "NA", "NULL")

date_time_format <- "%d/%m/%Y %H:%M:%S"

date_format <- "%d/%m/%Y"

year_format <- "%Y"

month_format <- "%m"

df <- vroom(
  file       = data_path, 
  delim      = semi_colon, 
  col_names  = names(col_types_data),
  col_types  = col_types_data,
  na         = na_candidates) %>%
  slice(-1) %>%
  mutate(date_time = paste(date, time)) %>%
  mutate(date_time = as.POSIXct(date_time, format= date_time_format, tz=Sys.timezone())) %>%
  mutate(date = as.Date(date, format = date_format)) %>%
  mutate(year = format(date, year_format)) %>%
  mutate(year = as.numeric(year)) %>%
  mutate(month = format(date, month_format)) %>%
  mutate(month = as.numeric(month)) 
