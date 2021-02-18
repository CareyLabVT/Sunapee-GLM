#*****************************************************************
#*      Cary Institute of Ecosystem Studies (Millbrook, NY)      *
#*                                                               *
#* TITLE:   GLM_sunapee_volumearea_82-19.r                       *
#* AUTHOR:  Bethel Steele                                        *
#* SYSTEM:  Lenovo WorkCentre, Win 10, R 3.6.3                   *
#* DATE:    22Mar2017                                            *
#* PROJECT: GLM CIBR/FLARE                                       *
#* PURPOSE: using dam data and a true DEM of Sunapee's bathymetry*
#*          and surrounding elevation, calculate area and volume *
#*          for the historical dam record.                       *
#* LAST MODIFIED: 29Sept2020                                     *
#* BY:      B. Steele                                            *
#* NOTES:   v22Mar2017 this is a subset of code from             *
#*          LS_GLM_21Mar2017                                     *
#*          v29Sept2020 updates the data through 2019, corrects  *  
#*          storage and hyspography calculations                 *
#*****************************************************************

library(plyr)
library(reshape)
library(tidyverse)
library(readxl)

#set up directory paths
dump.dir <-  'C:/Users/steeleb/Dropbox/Lake Sunapee/misc/GLM/Final Data/lake level and storage/'
truedem.data.dir <-  "C:/Users/steeleb/Dropbox/Lake Sunapee/misc/GLM/GIS/"
des.dam.data.dir <- 'C:/Users/steeleb/Dropbox/Lake Sunapee/monitoring/DES_sunapee_dam_data/historical_water_level_data/'

dam82_19 <- read_csv(paste0(des.dam.data.dir, "r_program/r_output/historical interpolated dam data 82-19 lake depth subset.csv"))
head(dam82_19)

#use range to find the range of depths that we need area and volume data for
range(dam82_19$lake_depth_m)

## calculate storage from GIS true DEM ##
dem1000 <- read_csv(paste0(truedem.data.dir, "td200_1000.csv"))
dem1000$depth_m_asl <- dem1000$VALUE_/1000 #asl multiplied by 1000 to create a defined, exportable raster
dem1000$area_m2 <- dem1000$COUNT_* (1.300119 *1.300119) #to calculate area in m2 (this is the number of cells where the lake is of a certain elevation)

storage <- dem1000 %>% 
  select(depth_m_asl, area_m2)

#need storage calcs for 32.8 through 34.3 in 0.1m increments - doing 32.5-34.5 for good measure, though they will probably never be used.
depths_for_storage <- seq(32.5, 34.5, 0.1)
agg_by_depth <- NULL # initialize object
for (y in seq(32.5, 34.5, 0.1)) {
  subset <- storage %>% #subset for elevations pertinent to depth in question (depths_for_storage)
    filter(depth_m_asl <= y+299.443) %>% #299.443 is the lowest elevation of the basin, filter the data
    mutate(depth_m = round(y+299.43-depth_m_asl, 1), # calculate the depths, round to a single digit after decimal
           depth_index = as.factor(y)) #save depth info in new column as factor
  print(subset)
  name <- paste(y, 'depth', sep = ' ')
  agg_by_depth[[name]] <- subset
}
agg_by_depth_data <- ldply(agg_by_depth, data.frame)
head(agg_by_depth_data)
unique(agg_by_depth_data$depth_index)

subset_agg <- agg_by_depth_data %>% #aggregate by 0.1m increments
  group_by(depth_m, depth_index) %>% 
  summarise(area_m2 = sum(area_m2)) %>% 
  arrange(-depth_m) %>% 
  ungroup()
head(subset_agg)

subset_agg$total_area_m2 = 1.69 #initialize column with first observation. all others will be overwritten in loop

subset_agg_by_depth_comp <- NULL
for (i in depths_for_storage) { #need to calculate area for volume calucalations
  subset_agg_by_depth <- subset_agg %>% 
    filter(depth_index == i)
  for(x in 2:nrow(subset_agg_by_depth)){
    subset_agg_by_depth$total_area_m2[x] = subset_agg_by_depth$area_m2[x] + subset_agg_by_depth$total_area_m2[x-1]
  }
  name <- paste(i, 'depth', sep = ' ')
  subset_agg_by_depth_comp [[name]] <- subset_agg_by_depth
}

subset_agg_by_depth_comp_data <- ldply(subset_agg_by_depth_comp, data.frame)

subset_agg_by_depth_comp_data <- subset_agg_by_depth_comp_data %>% 
  mutate(vol_m3 = total_area_m2 * 0.1)
head(subset_agg_by_depth_comp_data)

storage_summary <- subset_agg_by_depth_comp_data %>% 
  group_by(depth_index) %>% 
  summarize(area_m2 = max(total_area_m2),
            volume_m3 = sum(vol_m3))

#plot to check
ggplot(storage_summary, aes(x = depth_index, y = volume_m3)) +
  geom_point() 
ggplot(storage_summary, aes(x = depth_index, y = area_m2)) +
  geom_point() 

summary(lm(storage_summary$volume_m3~as.numeric(storage_summary$depth_index)))


write_csv(storage_summary, paste0(dump.dir, 'storagecalc_matrix_0p1m_29Sept2020.csv'))

#### apply storage sumary to historical dam record ####
dam82_19 <- dam82_19 %>% 
  mutate(depth_index = as.factor(round(lake_depth_m, digits = 1))) %>% 
  left_join(., storage_summary)


#plot to check
ggplot(dam82_19, aes(x = lake_depth_m, y = volume_m3)) +
  geom_point()

#write storage and area data
write_csv(dam82_19, paste0(dump.dir, 'historical area and volume according to dam depth.csv'))

#### Lake Hypsography ####
#subset storage data for hypsography in 0.5m intervals

hyps_depths <- seq(0, 33.5, 0.5)

hypsography <- NULL
for(i in hyps_depths) {
  subset <- storage %>% #subset for elevations pertinent to depth in question (depths_for_storage)
    filter(depth_m_asl <= max(hyps_depths)+299.443) #299.443 is the lowest elevation of the basin, filter the data for the 
  hyps <- storage %>% 
    mutate(act_depth_m = max(hyps_depths) - i) %>% 
    filter(depth_m_asl <= i+299.43) %>% 
    group_by(act_depth_m) %>% 
    summarise(area_m2 = sum(area_m2))
  print(hyps)
  name <- as.character(i)
  hypsography[[name]] <- hyps
}

sun_hypsography <- ldply(hypsography, data.frame)

plot(sun_hypsography$act_depth_m, sun_hypsography$area_m2)

write_csv(sun_hypsography, paste0(truedem.data.dir, 'sunapee_hypsography_matrix_0p5m_29Sept2020.csv'))


