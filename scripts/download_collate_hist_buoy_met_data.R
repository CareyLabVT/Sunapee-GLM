# download buoy met data from 2007 - present

#install.packages('LakeMetabolizer')
library(LakeMetabolizer)
library(tidyverse)

# air temp 
data  <-  "https://pasta.lternet.edu/package/data/eml/edi/234/4/1af6f9a538dd5b88de15811f26f9a04a" 
dir.create(paste0(getwd(), '/data/buoy-data/met'))
destination <- paste0(getwd(), '/data/buoy-data/met') # some location on your computer
try(download.file(data,destfile = paste0(destination, '/hist_buoy_air_temp.csv'),method="curl"))

# PAR
data  <-  "https://pasta.lternet.edu/package/data/eml/edi/234/4/fa0aa3a53ea63fe082fa1816be5f2545" 
destination <- paste0(getwd(), '/data/buoy-data/met') # some location on your computer
try(download.file(data,destfile = paste0(destination, '/hist_buoy_PAR.csv'),method="curl"))


# Wind
data  <-  "https://pasta.lternet.edu/package/data/eml/edi/234/4/495bb93448cbf23198d53ba5476463df" 
destination <- paste0(getwd(), '/data/buoy-data/met') # some location on your computer
try(download.file(data,destfile = paste0(destination, '/hist_buoy_wind.csv'),method="curl"))

hist_temp <- read.csv(paste0(getwd(), '/data/buoy-data/met/hist_buoy_air_temp.csv'))
hist_par <- read.csv(paste0(getwd(), '/data/buoy-data/met/hist_buoy_PAR.csv'))
hist_wind <- read.csv(paste0(getwd(), '/data/buoy-data/met/hist_buoy_wind.csv'))

hist_data <- left_join(hist_temp, hist_par)
hist_data <- left_join(hist_data, hist_wind)

# remove any data except for when out at loon island (maybe we will want harbor data later?)
hist_data <- hist_data[hist_data$location=='loon',]

hist_data <- hist_data %>% 
  # maybe should filter some of the flags?
  mutate(WindSpeed = ifelse(is.na(AveWindSp_ms), WindSp_ms, AveWindSp_ms)) %>% 
  select(datetime, PAR_umolm2s, AirTemp_degC, WindSpeed) 

colnames(hist_data) <- c('time', 'par', 'AirTemp', 'WindSpeed')

hist_data <- hist_data %>% 
  mutate(ShortWave = par.to.sw.base(par = hist_data$par)) %>% 
  select(time, ShortWave, AirTemp, WindSpeed)
# calc.lw.net for longwave??

write.csv(hist_data, paste0(getwd(),'/data/formatted-data/hist_buoy_met.csv' ), row.names = FALSE)
