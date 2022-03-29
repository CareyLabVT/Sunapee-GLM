library(tidyverse)
library(lubridate)

# what about manual measurements?
# download manual data from zenodo: https://zenodo.org/record/4652076#.YKKBbqhKg2x
manual <- read.csv("./data/manual-data/master files/LSPALMP_1986-2020_v2021-03-29.csv")

manual <- manual %>% 
  filter(site_type=='lake') %>% 
  filter(station =='220') %>% 
  mutate(depth_m = round(depth_m, digits = 0))

ggplot(data = manual, aes(x = date, y = value)) +
  geom_point(aes(col = as.factor(year(date)), shape = as.factor(layer))) +
  facet_wrap(~parameter, scales = 'free_y')

oxy <- manual %>% 
  filter(parameter=='DO_mgl')
oxy$date <- as.Date(oxy$date)

ggplot(data = oxy, aes(x = date, y = depth_m)) +
  geom_point(aes(col = value)) +
  scale_y_reverse()

ggplot(data = oxy[oxy$depth_m < 10,], aes(x = date, y = value)) +
  geom_point(aes(col = as.factor(year(date)))) 

ggplot(data = oxy[oxy$depth_m > 10,], aes(x = date, y = value)) +
  geom_point(aes(col = as.factor(year(date)))) 

oxy_avg <- oxy %>% 
  mutate(year = year(date)) %>% 
  mutate(layer = ifelse(depth_m > 10, 'bottom', 'surface')) %>% 
  group_by(year, layer) %>% 
  mutate(oxy_avg = mean(value, na.rm = TRUE)) %>% 
  distinct(year, .keep_all = TRUE)

ggplot(data = oxy_avg, aes(x = year, y = oxy_avg)) +
  geom_line(aes(group = layer)) +
  geom_point(aes(col = layer, group = layer, size = 2)) +
  geom_smooth(aes(group = layer))

ggplot(data = oxy, aes(x = value, color = as.factor(month(date)), fill = as.factor(month(date)))) +
  geom_histogram(alpha = 0.5, position = 'identity')