#*****************************************************************
#*      Cary Institute of Ecosystem Studies (Millbrook, NY)      *
#*                                                               *
#* TITLE:   dam_collation.r                                      *
#* AUTHOR:  Bethel Steele                                        *
#* SYSTEM:  Lenovo WorkCentre, Win 10, R 3.6.3                   *
#* DATE:    01Jan2016                                            *
#* PROJECT: Lake Sunapee WS projects (CNH-GLM)                   *
#* PURPOSE: collate dam data                                     *
#* LAST MODIFIED: 29Sept2020                                     *
#* BY:      B. Steele                                            *
#* UPDATES: v29Sept2020 updated through 2019 modified for better *
#*          interoperability                                     *
#*****************************************************************
#*                     folder tree structure                     *
#*                            Drobpox                            *
#*                               |                               *
#*                          Lake Sunapee                         *
#*                               |                               *
#*                           monitoring                          *
#*                               |                               *
#*               DES Sunapee dam station data                    *
#*                               |                               *
#*               historical water level data                     *
#*****************************************************************

library(zoo)
library(tidyverse)
library(readxl)

#in DES Sunapee dam station data: 'Sunapee Historical Data (1982-2010)'
des.dam.dir = "historical_water_level_data/"

names = c('date', 'local_lake_elev_f', 'usgs_elev_f', 'gage_elec', 'riv_stage_f', 'flow_out_cfs',
          'change_lake_f', 'change_storage_cfs', 'est_inflow_cfs', 'strdwtr', 'memo', 'time', 'est', 'este')
names2 = c('date', 'local_lake_elev_f', 'usgs_elev_f', 'precip')
names3 = c('date', 'local_lake_elev_f', 'usgs_elev_f', 'precip', 'rstage', 'avedisch')

names19_elev = c('data_status', 'location', 'parameter', 'date', 'usgs_elev_f')
names19_temp = c('data_status', 'location', 'parameter', 'date', 'air_temp_F')
names19_precip = c('data_status', 'location', 'parameter', 'date', 'precip')
names19_disc = c('data_status', 'location', 'parameter', 'date', 'flow_out_cfs')

###*** LAKE LEVEL DATA ***###
#bring in historical data: 1982-2010, 2010-2016, 2016, 2017, 2018
dam82_10 <- read_csv(paste0(des.dam.dir, "modified_by_BGS/sun_hist_data_82-10_forR.csv"), 
                     skip=3, 
                     col_names = names, 
                     col_types = 'cnnnnnnnnccccc',
                     na = '') %>% 
  mutate(date = base::as.Date(date, '%m/%d/%Y'))
head(dam82_10)
tail(dam82_10)
dam11_15 <- read_xlsx(paste0(des.dam.dir, 'original_data_from_DES/Sunapee Data 2010-2018.xlsx'), 
                      sheet = '10-15',
                      skip=1, 
                      col_names=names2, 
                      na = '') %>% 
  filter(date>='2011-01-01'& date<'2016-01-01') %>% 
  mutate(date = base::as.Date(date))
head(dam11_15)
dam16 <- read_xlsx(paste0(des.dam.dir, 'original_data_from_DES/Sunapee Data 2010-2018.xlsx'),
                   sheet = '2016',
                   skip = 1,
                   col_names = names3,
                   na = '') %>% 
  mutate(date = base::as.Date(date))
head(dam16)
dam17 <- read_xlsx(paste0(des.dam.dir, 'original_data_from_DES/Sunapee Data 2010-2018.xlsx'),
                   sheet = '2017',
                   skip = 1,
                   col_names = names3,
                   na = '')%>% 
  mutate(date = base::as.Date(date))
head(dam17)
dam18 <- read_xlsx(paste0(des.dam.dir, 'original_data_from_DES/Sunapee Data 2010-2018.xlsx'),
                   sheet = '2018',
                   skip = 1,
                   col_names = names3,
                   na = '')%>% 
  mutate(date = base::as.Date(date, '%m/%d/%Y'))
head(dam18)

#2019 data in a new format
dam19_hourly_elev <- read_xlsx(paste0(des.dam.dir, 'original_data_from_DES/Sunapee Data - hourly - 2019.xlsx'),
                               sheet = 'SUNAPEE LK-OBSERVED LAKE ELEVAT',
                               skip = 1,
                               col_names = names19_elev) %>% 
  select(date, usgs_elev_f)
head(dam19_hourly_elev)
dam19_hourly_flow <- read_xlsx(paste0(des.dam.dir, 'original_data_from_DES/Sunapee Data - hourly - 2019.xlsx'),
                               sheet = 'SUNAPEE LK-OBSERVED FLOW (HOUR)',
                               skip = 1,
                               col_names = names19_disc) %>% 
  select(date, flow_out_cfs)
head(dam19_hourly_flow)
dam19_hourly_precip <- read_xlsx(paste0(des.dam.dir, 'original_data_from_DES/Sunapee Data - hourly - 2019.xlsx'),
                               sheet = 'SUNAPEE LK-PRECIPITATION INCREM',
                               skip = 1,
                               col_names = names19_precip) %>% 
  select(date, precip)
head(dam19_hourly_precip)

dam19_hourly <- full_join(dam19_hourly_elev, dam19_hourly_flow) %>% 
  full_join(., dam19_hourly_precip)

rm(dam19_hourly_elev, dam19_hourly_flow, dam19_hourly_precip)

#create daily summay for 2019 data; mean elevation and flow, total precip
dam19 <- dam19_hourly %>% 
  mutate(cal_day = base::as.Date(date)) %>% 
  group_by(cal_day) %>% 
  summarize(usgs_elev_f = mean(usgs_elev_f, na.rm = T),
            flow_out_cfs = mean(flow_out_cfs, na.rm = T),
            precip = sum(precip, na.rm = T)) %>% 
  rename(date = cal_day) %>% 
  mutate(local_lake_elev_f = usgs_elev_f - 1093.15 + 10.5)


#merge for all data
dam82_19 <- full_join(dam82_10, dam11_15) %>% 
  full_join(., dam16) %>% 
  full_join(., dam17) %>% 
  full_join(., dam18) %>% 
  full_join(., dam19) %>% 
  select(date, local_lake_elev_f, usgs_elev_f, flow_out_cfs, avedisch, precip)
head(dam82_19)

date <- data.frame(date = seq(base::as.Date('1981-12-23'),
                              base::as.Date('2019-12-31'), 
                              'day'))
date$date_functional <- date$date
 
dam82_19 <- full_join(date, dam82_19) %>% 
  select(-date) %>% 
  rename(date = date_functional)

#export csv for other uses
write_csv(dam82_19, paste0(des.dam.dir, 'r_program/r_output/historical raw dam data 82-19.csv'))

#quick reality check - plot values over time
plot(dam82_19$date, dam82_19$local_lake_elev_f)

#add flag column for manipulated data - 1=dismissed; 2=adjusted; 3=interpolated
dam82_19$dataflag <- ''
#dismiss/correct values as necessary and add appropriate data flag
dam82_19$local_lake_elev_f [6286] = NA #lake depth reported at >800 feet
dam82_19$dataflag [6286] = 1
plot(dam82_19$date, dam82_19$local_lake_elev_f)

ix=which(dam82_19$local_lake_elev_f==0) #lake depth reported at 0
dam82_19$local_lake_elev_f[ix] = NA
dam82_19$dataflag[ix] = 1
plot(dam82_19$date, dam82_19$local_lake_elev_f)

dam82_19$local_lake_elev_f [6325] = 9.74 #lake depth reported at 4.74 feet the day after a 9.72 foot day - presumed transcription error
dam82_19$dataflag [6325] = 2
dam82_19$local_lake_elev_f [6326] = 9.77 #same as above - presumed transcription error
dam82_19$dataflag [6326] = 2
plot(dam82_19$date, dam82_19$local_lake_elev_f)

dam82_19$local_lake_elev_f [9763] = 9.75 #same as above - presumed transcription error; lake would have dropped 2 feet in one day.
dam82_19$dataflag [9763] = 2
plot(dam82_19$date, dam82_19$local_lake_elev_f)

ggplot(dam82_19, aes(x = date, y = local_lake_elev_f)) +
  geom_point()


#export csv for other uses
write_csv(dam82_19, paste0(des.dam.dir, 'r_program/r_output/historical QAQC dam data 82-19.csv'))


#interpolate data where necessary
dam82_19$inter_local_lake_elev_f <- na.approx(dam82_19$local_lake_elev_f)
#add data flag
dam82_19$dataflag [is.na(dam82_19$local_lake_elev_f)] = 3

#export csv for other uses
write_csv(dam82_19, paste0(des.dam.dir, 'r_program/r_output/historical interpolated dam data 82-19.csv'))

#calculate depth above sea level using usgs elevation: 1082.65=0 local (from DES metadata) - same as 1093.15 + 10.5
dam82_19 <- dam82_19 %>% 
  mutate(lake_level_asl_f = inter_local_lake_elev_f + 1082.65,
         lake_level_asl_m = lake_level_asl_f * 0.3048)

#according to the GIS bathymetry file, the lowest elevation of the lake is 299.443512m, so by subtracting that from the lake level asl, 
# that should give us average daily depth at the deep spot 
dam82_19$lake_depth_m <- (dam82_19$lake_level_asl_m - (299.443512))
#subset for desired columns
lakelevel82_19 <- subset(dam82_19, select=c('date', 'lake_depth_m', 'lake_level_asl_m', 'dataflag')) 
#quick reality check - plot values over time
plot(lakelevel82_19$date, lakelevel82_19$lake_depth_m)
plot(lakelevel82_19$date, lakelevel82_19$lake_level_asl_m)

#save as .csv
write_csv(lakelevel82_19, paste0(des.dam.dir, 'r_program/r_output/historical interpolated dam data 82-19 lake depth subset.csv'))

##subset for outflow data
dam_outflow <- subset(dam82_19, select=c('date', 'flow_out_cfs'))
dam_outflow <- subset(dam_outflow, subset=!is.na(flow_out_cfs))
dam_outflow$flow_out_m3s = dam_outflow$flow_out_cfs * 0.0283
dam_outflow <- subset(dam_outflow, select=c('date', 'flow_out_m3s'))
#quick reality check - plot values over time
plot(dam_outflow$date, dam_outflow$flow_out_m3s)

write_csv(dam_outflow, paste0(des.dam.dir, 'r_program/r_output/historical dam outflow 82-19.csv'))
