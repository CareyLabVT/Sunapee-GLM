# this is an intermediate script until 2020 data are available, then this will be copied into 'dam_collation.R'

# this file appends the dam data that were downloaded from the DES website in preparation for the CIBR-FLARE project automated download

library(tidyverse)

damdir = 'C:/Users/steeleb/Dropbox/Lake Sunapee/monitoring/DES_sunapee_dam_data/historical_water_level_data/original_data_from_DES/'

damlist <- list.files(damdir, pattern = 'dam_download') 

collated_dam <- NULL #create a NULL dataframe
for(i in 1: length(damlist)){
  if (length(collated_dam) == 0) {
    collated_dam <- read.csv(file.path(damdir, damlist[i]), na.strings = '--') %>% 
    mutate(datetime = as.POSIXct(datetime, tz='UTC')) %>% 
    filter(!is.na(lake_elev_ft) | !is.na(obs_flow) | !is.na(obs_stage) | !is.na(precip_in) | !is.na(air_temp_degC)) #eliminate non-reporting data; sometimes these show up in other downloads
  } else {
    lastobs = max(collated_dam$datetime)
    b <- read.csv(file.path(damdir, damlist[i]), na.strings = '--') %>% 
      mutate(datetime = as.POSIXct(datetime, tz='UTC')) %>% 
      filter(!is.na(lake_elev_ft) | !is.na(obs_flow) | !is.na(obs_stage) | !is.na(precip_in) | !is.na(air_temp_degC)) %>% 
      filter(datetime > lastobs)
    collated_dam <- full_join(collated_dam, b) %>% 
      arrange(datetime)
  }
}

startdate <- format(min(collated_dam$datetime), '%Y%m%d_%H%M')
enddate <- format(max(collated_dam$datetime), '%Y%m%d_%H%M')

write.csv(collated_dam, row.names = F, file.path(damdir, paste0('sunapee_dam_data_', startdate, '-', enddate, '.csv')))

          