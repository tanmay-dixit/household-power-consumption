# Explore DF
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

print(daily_gap)

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

print(weekly_gap)

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

print(monthly_gap)