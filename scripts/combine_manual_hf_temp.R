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
colnames(manual) <- c('DateTime', 'Depth', 'Temp_manual', 'site', 'method')  
manual$site <- as.character(manual$site)
manual$DateDepth <- paste0(manual$DateTime, " ", manual$Depth)


buoy <- read.csv(paste0(sim_folder, '/data/formatted-data/field_temp_noon_obs.csv'))
buoy$DateTime <- as.POSIXct(buoy$DateTime)
buoy$site <- as.character('210') # set up buoy site to 210?
buoy$method <- 'buoy'
colnames(buoy) <- c('DateTime', 'Depth', 'Temp_buoy', 'site', 'method')
buoy <- na.omit(buoy)
buoy$DateDepth <- paste0(buoy$DateTime, " ", buoy$Depth)

ggplot(buoy, aes(x = DateTime, y = Temp_buoy)) +
  geom_line()

# remove days from buoy dataset where there is manual data
remove <- manual$DateTime

buoy <- buoy[!buoy$DateTime %in% remove,  ]

# combine the two datasets
temp_data <- full_join(manual, buoy)

data_nodups <- temp_data[!duplicated(temp_data[,1:2]),]

table(duplicated(data_nodups[,1:2]))
table(duplicated(temp_data[,1:2]))

ggplot(data_nodups[data_nodups$DateTime > '2018-01-01 00:00:00' & data_nodups$DateTime < '2019-01-01 00:00:00',], aes(x = DateTime, y = Temp_buoy)) +
  geom_line() +
  geom_line(aes(x= DateTime, y = Temp_manual, col = 'red')) 

  
ggplot(buoy[buoy$DateDepth > '2018-01-01 00:00:00' & buoy$DateDepth < '2019-01-01 00:00:00',], aes(x = DateTime, y = Temp_buoy)) +
  geom_line(aes(col = as.factor(Depth))) 
  
ggplot(manual[manual$DateDepth > '2018-01-01 00:00:00' & manual$DateDepth < '2019-01-01 00:00:00',], aes(x = DateTime, y = Temp_manual)) +
  geom_line(aes(col = as.factor(Depth))) 

data_nodups <- data_nodups %>% 
  mutate(Temp = ifelse(is.na(Temp_manual), Temp_buoy, Temp_manual)) %>% 
  select(DateTime, Depth, Temp)

write.csv(data_nodups, paste0(getwd(), "/data/formatted-data/manual_buoy_temp.csv"), row.names = FALSE)
