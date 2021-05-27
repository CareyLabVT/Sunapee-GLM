# combine manual and high frequency buoy data

library(tidyverse)
library(lubridate)

sim_folder <- getwd()

# download manual data from zenodo: https://zenodo.org/record/4652076#.YKKBbqhKg2x
manual <- read.csv(paste0(sim_folder, "/data/manual-data/master files/LSPALMP_1986-2020_v2021-03-29.csv"))
manual <- manual %>% 
  filter(parameter == 'temp_C') %>% 
  mutate(date = as.Date(date)) %>% 
  select(date, depth_m, parameter, value, station) %>% 
  pivot_wider(names_from = parameter, values_from = value) %>% 
  unchop(everything()) # do this bc of strange formating with pivot wider

#ggplot(manual, aes(x = date, y = temp_C)) +
#  geom_point() +
#  facet_wrap(~station)

manual <- manual %>% 
  filter(station == 210) %>%  # this is the deep hole site
  mutate(time = hms("12:00:00")) %>% 
  mutate(DateTime = as.POSIXct(date, format = "%Y-%m-%d %H:%M:%S", tz = 'UTC+5') + 60*60*16) %>% 
  select(DateTime, depth_m, temp_C, station) %>% 
  mutate(method = 'manual')
colnames(manual) <- c('DateTime', 'Depth', 'Temp', 'site', 'method')  

buoy <- read.csv(paste0(sim_folder, '/data/formatted-data/field_temp_noon_obs.csv'))
buoy$site <- '210' # set up buoy site to 210?
buoy$method <- 'buoy'

ggplot(buoy, aes(x = DateTime, y = Temp)) +
  geom_line()

# combine the two datasets
temp_data <- rbind(manual, buoy)

ggplot(temp_data, aes(x = DateTime, y = Temp)) +
  geom_line(aes(color = method))
