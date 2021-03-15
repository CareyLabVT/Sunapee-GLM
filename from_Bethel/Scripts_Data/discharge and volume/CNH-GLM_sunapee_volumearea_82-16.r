#*****************************************************************
#*      Cary Institute of Ecosystem Studies (Millbrook, NY)      *
#*                                                               *
#* TITLE:   CNH-GLM_sunapee_volumearea_82-16.r                   *
#* AUTHOR:  Bethel Steele                                        *
#* SYSTEM:  Lenovo W530, Win 7, R 3.2.2                          *
#* DATE:    22Mar2017                                            *
#* PROJECT: CNH-GLM                                              *
#* PURPOSE: using dam data and a true DEM of Sunapee's bathymetry*
#*          and surrounding elevation, calculate area and volume *
#*          for the historical dam record.                       *
#* LAST MODIFIED: 22Mar2017                                      *
#* BY:      B. Steele                                            *
#* NOTES:   this is a subset of code from LS_GLM_21Mar2017       *
#*****************************************************************

library(gdata)
library(doBy)
library(ggplot2)
library(GGally)
library(reshape)

#load workspace. CNH-GLM_sunapee_inflowoutflow_begwrkspc has all the original data frames resulting from the 'read.csv' and 'read.xls' functions
#change this to the appropriate working directory
setwd("C:/Users/steeleb/Dropbox/Lake Sunapee/Lake Sunapee Lake Model/R Programs")
load("CNH-GLM_sunapee_volumearea_82-16_begwrkspc.RData")


#### bring in lake sunapee area and volume data for other calculations
#setwd("C:/Users/steeleb/Dropbox/Lake Sunapee/monitoring/DES Sunapee dam station data/historical water level data") #in begwrkspc
#dam82_16 <- read.csv("historical interpolated dam data 82-16 lake depth subset.csv", header=T) #in begwrkspc

dam82_16$date <- as.Date(dam82_16$date, format='%Y-%m-%d')

#use range to find the range of depths that we need area and volume data for
range(dam82_16$lake_depth_m)

## calculate storage from GIS true DEM ##
setwd("C:/Users/steeleb/Dropbox/Lake Sunapee/Lake Sunapee Lake Model/GIS")
dem1000 <- read.csv("td200_1000.csv", header=T)
dem1000$depth_m_asl <- dem1000$VALUE_/1000 #asl multiplied by 1000 to create a defined, exportable raster
dem1000$depthforbreaks <- (dem1000$depth_m_asl - (299.443)) #calculate depth from bottom to top - 299.443 is the deepest true dem value - this is only for determining which cells to include in the next steps
dem1000$area_m2 <- dem1000$COUNT_* (1.300119 *1.300119) #to calculate area in m2

storage <- subset(dem1000, select=c(depthforbreaks, area_m2))

#need storage calcs for 32.9 through 34.3 in 0.1m increments
stor32.9 <- subset(storage, subset=(depthforbreaks<=32.9)) 
stor33.0 <- subset(storage, subset=(depthforbreaks<=33.0)) 
stor33.1 <- subset(storage, subset=(depthforbreaks<=33.1)) 
stor33.2 <- subset(storage, subset=(depthforbreaks<=33.2)) 
stor33.3 <- subset(storage, subset=(depthforbreaks<=33.3)) 
stor33.4 <- subset(storage, subset=(depthforbreaks<=33.4)) 
stor33.5 <- subset(storage, subset=(depthforbreaks<=33.5)) 
stor33.6 <- subset(storage, subset=(depthforbreaks<=33.6)) 
stor33.7 <- subset(storage, subset=(depthforbreaks<=33.7)) 
stor33.8 <- subset(storage, subset=(depthforbreaks<=33.8)) 
stor33.9 <- subset(storage, subset=(depthforbreaks<=33.9)) 
stor34.0 <- subset(storage, subset=(depthforbreaks<=34.0)) 
stor34.1 <- subset(storage, subset=(depthforbreaks<=34.1)) 
stor34.2 <- subset(storage, subset=(depthforbreaks<=34.2)) 
stor34.3 <- subset(storage, subset=(depthforbreaks<=34.3)) 

#calculate actual depth by subracting depth for breaks from max depth
stor32.9$depth_m <- 32.9 - stor32.9$depthforbreaks
stor33.0$depth_m <- 33.0 - stor33.0$depthforbreaks
stor33.1$depth_m <- 33.1 - stor33.1$depthforbreaks
stor33.2$depth_m <- 33.2 - stor33.2$depthforbreaks
stor33.3$depth_m <- 33.3 - stor33.3$depthforbreaks
stor33.4$depth_m <- 33.4 - stor33.4$depthforbreaks
stor33.5$depth_m <- 33.5 - stor33.5$depthforbreaks
stor33.6$depth_m <- 33.6 - stor33.6$depthforbreaks
stor33.7$depth_m <- 33.7 - stor33.7$depthforbreaks
stor33.8$depth_m <- 33.8 - stor33.8$depthforbreaks
stor33.9$depth_m <- 33.9 - stor33.9$depthforbreaks
stor34.0$depth_m <- 34.0 - stor34.0$depthforbreaks
stor34.1$depth_m <- 34.1 - stor34.1$depthforbreaks
stor34.2$depth_m <- 34.2 - stor34.2$depthforbreaks
stor34.3$depth_m <- 34.3 - stor34.3$depthforbreaks

#calculate volume for each of the max depths for the lake
stor32.9$volume_m3 <- stor32.9$depth_m*stor32.9$area_m2 
stor33.0$volume_m3 <- stor33.0$depth_m*stor33.0$area_m2 
stor33.1$volume_m3 <- stor33.1$depth_m*stor33.1$area_m2 
stor33.2$volume_m3 <- stor33.2$depth_m*stor33.2$area_m2 
stor33.3$volume_m3 <- stor33.3$depth_m*stor33.3$area_m2 
stor33.4$volume_m3 <- stor33.4$depth_m*stor33.4$area_m2 
stor33.5$volume_m3 <- stor33.5$depth_m*stor33.5$area_m2 
stor33.6$volume_m3 <- stor33.6$depth_m*stor33.6$area_m2 
stor33.7$volume_m3 <- stor33.7$depth_m*stor33.7$area_m2 
stor33.8$volume_m3 <- stor33.8$depth_m*stor33.8$area_m2 
stor33.9$volume_m3 <- stor33.9$depth_m*stor33.9$area_m2 
stor34.0$volume_m3 <- stor34.0$depth_m*stor34.0$area_m2 
stor34.1$volume_m3 <- stor34.1$depth_m*stor34.1$area_m2 
stor34.2$volume_m3 <- stor34.2$depth_m*stor34.2$area_m2 
stor34.3$volume_m3 <- stor34.3$depth_m*stor34.3$area_m2 

stor32.9v <- sum(stor32.9$volume_m3)
stor33.0v <- sum(stor33.0$volume_m3)
stor33.1v <- sum(stor33.1$volume_m3)
stor33.2v <- sum(stor33.2$volume_m3)
stor33.3v <- sum(stor33.3$volume_m3)
stor33.4v <- sum(stor33.4$volume_m3)
stor33.5v <- sum(stor33.5$volume_m3)
stor33.6v <- sum(stor33.6$volume_m3)
stor33.7v <- sum(stor33.7$volume_m3)
stor33.8v <- sum(stor33.8$volume_m3)
stor33.9v <- sum(stor33.9$volume_m3)
stor34.0v <- sum(stor34.0$volume_m3) 
stor34.1v <- sum(stor34.1$volume_m3)
stor34.2v <- sum(stor34.2$volume_m3) 
stor34.3v <- sum(stor34.3$volume_m3)

for(i in 1:nrow(dam82_16))
{
  dam82_16$storage_m3 [dam82_16$lake_depth_m<=32.9] = stor32.9v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>32.9&dam82_16$lake_depth_m<=33.0] = stor33.0v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.0&dam82_16$lake_depth_m<=33.1] = stor33.1v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.1&dam82_16$lake_depth_m<=33.2] = stor33.2v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.2&dam82_16$lake_depth_m<=33.3] = stor33.3v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.3&dam82_16$lake_depth_m<=33.4] = stor33.4v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.4&dam82_16$lake_depth_m<=33.5] = stor33.5v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.5&dam82_16$lake_depth_m<=33.6] = stor33.6v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.6&dam82_16$lake_depth_m<=33.7] = stor33.7v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.7&dam82_16$lake_depth_m<=33.8] = stor33.8v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.8&dam82_16$lake_depth_m<=33.9] = stor33.9v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>33.9&dam82_16$lake_depth_m<=34.0] = stor34.0v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>34.0&dam82_16$lake_depth_m<=34.1] = stor34.1v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>34.1&dam82_16$lake_depth_m<=34.2] = stor34.2v
  dam82_16$storage_m3 [dam82_16$lake_depth_m>34.2] = stor34.3v
  print(dam82_16$storage_m3[i])
}

# calculate surface area per 0.1m depth change
stor32.9a <- sum(stor32.9$area_m2)
stor33.0a <- sum(stor33.0$area_m2)
stor33.1a <- sum(stor33.1$area_m2)
stor33.2a <- sum(stor33.2$area_m2)
stor33.3a <- sum(stor33.3$area_m2)
stor33.4a <- sum(stor33.4$area_m2)
stor33.5a <- sum(stor33.5$area_m2)
stor33.6a <- sum(stor33.6$area_m2)
stor33.7a <- sum(stor33.7$area_m2)
stor33.8a <- sum(stor33.8$area_m2)
stor33.9a <- sum(stor33.9$area_m2)
stor34.0a <- sum(stor34.0$area_m2) 
stor34.1a <- sum(stor34.1$area_m2)
stor34.2a <- sum(stor34.2$area_m2) 
stor34.3a <- sum(stor34.3$area_m2)

for(i in 1:nrow(dam82_16)){
  dam82_16$area_m2 [dam82_16$lake_depth_m<=32.9] = stor32.9a
  dam82_16$area_m2 [dam82_16$lake_depth_m>32.9&dam82_16$lake_depth_m<=33.0] = stor33.0a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.0&dam82_16$lake_depth_m<=33.1] = stor33.1a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.1&dam82_16$lake_depth_m<=33.2] = stor33.2a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.2&dam82_16$lake_depth_m<=33.3] = stor33.3a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.3&dam82_16$lake_depth_m<=33.4] = stor33.4a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.4&dam82_16$lake_depth_m<=33.5] = stor33.5a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.5&dam82_16$lake_depth_m<=33.6] = stor33.6a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.6&dam82_16$lake_depth_m<=33.7] = stor33.7a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.7&dam82_16$lake_depth_m<=33.8] = stor33.8a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.8&dam82_16$lake_depth_m<=33.9] = stor33.9a
  dam82_16$area_m2 [dam82_16$lake_depth_m>33.9&dam82_16$lake_depth_m<=34.0] = stor34.0a
  dam82_16$area_m2 [dam82_16$lake_depth_m>34.0&dam82_16$lake_depth_m<=34.1] = stor34.1a
  dam82_16$area_m2 [dam82_16$lake_depth_m>34.1&dam82_16$lake_depth_m<=34.2] = stor34.2a
  dam82_16$area_m2 [dam82_16$lake_depth_m>34.2] = stor34.3a
  print(dam82_16$area_m2[i])
}

str(dam82_16)

#write storage and area data
setwd("C:/Users/steeleb/Dropbox/Lake Sunapee/Lake Sunapee Lake Model/Final Data/lake level and storage")
write.csv(dam82_16, file='historical area and volume according to dam depth.csv', row.names = F)

#### write volume and area matrix for 0.1m depth increments ####
area <- c(stor32.9a, stor33.0a, stor33.1a, stor33.2a, stor33.3a, stor33.4a, stor33.5a, stor33.6a, stor33.7a, stor33.8a, stor33.9a, stor34.0a, stor34.1a, stor34.2a, stor34.3a)
area_m <- melt(area)
volume <- c(stor32.9v, stor33.0v, stor33.1v, stor33.2v, stor33.3v,  stor33.4v, stor33.5v, stor33.6v, stor33.7v, stor33.8v, stor33.9v, stor34.0v, stor34.1v, stor34.2v, stor34.3v)
volume_m <- melt(volume)
depth_m <- c(32.9, 33.0, 33.1, 33.2, 33.3, 33.4, 33.5, 33.6, 33.7, 33.8, 33.9,34.0, 34.1, 34.2, 34.3)
depth_m_m <- melt(depth_m)
depth_vol <- merge(depth_m_m, volume_m, by='row.names', all=T)
depth_vol <- rename.vars(depth_vol, from=c('value.x', 'value.y'), to=c('depth_m', 'volume_m3'))
area_m$Row.names <- row.names(area_m)
depth_vol <- merge(depth_vol, area_m, by='row.names', all=T)
depth_vol <- rename.vars(depth_vol, from=c('value'), to=c('area_m2'))
depth_vol$depth_m_asl <- depth_vol$depth_m + 299.443
depth_vol <- subset(depth_vol, select=c('depth_m', 'depth_m_asl', 'volume_m3', 'area_m2'))

depth_vol <- depth_vol[with(depth_vol, order(depth_m)), ]

setwd("C:/Users/steeleb/Dropbox/Lake Sunapee/Lake Sunapee Lake Model/GIS")
write.csv(depth_vol, 'depth_volume_matrix_0p1m_21Mar2017.csv', row.names = F)


#### Lake Hypsography ####
#subset storage data for hypsography in 0.5m intervals
# subset for additional depth for hypsography for Nicole
hyps34.5 <- subset(storage, subset=(depthforbreaks<=34.5)) 
hyps34.0 <- subset(storage, subset=(depthforbreaks<=34.0)) 
hyps33.5 <- subset(storage, subset=(depthforbreaks<=33.5)) 
hyps33.0 <- subset(storage, subset=(depthforbreaks<=33.0)) 
hyps32.5 <- subset(storage, subset=(depthforbreaks<=32.5)) 
hyps32.0 <- subset(storage, subset=(depthforbreaks<=32.0)) 
hyps31.5 <- subset(storage, subset=(depthforbreaks<=31.5)) 
hyps31.0 <- subset(storage, subset=(depthforbreaks<=31.0)) 
hyps30.5 <- subset(storage, subset=(depthforbreaks<=30.5)) 
hyps30.0 <- subset(storage, subset=(depthforbreaks<=30.0)) 
hyps29.5 <- subset(storage, subset=(depthforbreaks<=29.5)) 
hyps29.0 <- subset(storage, subset=(depthforbreaks<=29.0)) 
hyps28.5 <- subset(storage, subset=(depthforbreaks<=28.5)) 
hyps28.0 <- subset(storage, subset=(depthforbreaks<=28.0)) 
hyps27.5 <- subset(storage, subset=(depthforbreaks<=27.5)) 
hyps27.0 <- subset(storage, subset=(depthforbreaks<=27.0)) 
hyps26.5 <- subset(storage, subset=(depthforbreaks<=26.5)) 
hyps26.0 <- subset(storage, subset=(depthforbreaks<=26.0)) 
hyps25.5 <- subset(storage, subset=(depthforbreaks<=25.5)) 
hyps25.0 <- subset(storage, subset=(depthforbreaks<=25.0)) 
hyps24.5 <- subset(storage, subset=(depthforbreaks<=24.5)) 
hyps24.0 <- subset(storage, subset=(depthforbreaks<=24.0)) 
hyps23.5 <- subset(storage, subset=(depthforbreaks<=23.5)) 
hyps23.0 <- subset(storage, subset=(depthforbreaks<=23.0)) 
hyps22.5 <- subset(storage, subset=(depthforbreaks<=22.5)) 
hyps22.0 <- subset(storage, subset=(depthforbreaks<=22.0)) 
hyps21.5 <- subset(storage, subset=(depthforbreaks<=21.5)) 
hyps21.0 <- subset(storage, subset=(depthforbreaks<=21.0)) 
hyps20.5 <- subset(storage, subset=(depthforbreaks<=20.5)) 
hyps20.0 <- subset(storage, subset=(depthforbreaks<=20.0))
hyps19.5 <- subset(storage, subset=(depthforbreaks<=19.5)) 
hyps19.0 <- subset(storage, subset=(depthforbreaks<=19.0)) 
hyps18.5 <- subset(storage, subset=(depthforbreaks<=18.5)) 
hyps18.0 <- subset(storage, subset=(depthforbreaks<=18.0)) 
hyps17.5 <- subset(storage, subset=(depthforbreaks<=17.5)) 
hyps17.0 <- subset(storage, subset=(depthforbreaks<=17.0)) 
hyps16.5 <- subset(storage, subset=(depthforbreaks<=16.5)) 
hyps16.0 <- subset(storage, subset=(depthforbreaks<=16.0)) 
hyps15.5 <- subset(storage, subset=(depthforbreaks<=15.5)) 
hyps15.0 <- subset(storage, subset=(depthforbreaks<=15.0)) 
hyps14.5 <- subset(storage, subset=(depthforbreaks<=14.5)) 
hyps14.0 <- subset(storage, subset=(depthforbreaks<=14.0)) 
hyps13.5 <- subset(storage, subset=(depthforbreaks<=13.5)) 
hyps13.0 <- subset(storage, subset=(depthforbreaks<=13.0)) 
hyps12.5 <- subset(storage, subset=(depthforbreaks<=12.5)) 
hyps12.0 <- subset(storage, subset=(depthforbreaks<=12.0)) 
hyps11.5 <- subset(storage, subset=(depthforbreaks<=11.5)) 
hyps11.0 <- subset(storage, subset=(depthforbreaks<=11.0)) 
hyps10.5 <- subset(storage, subset=(depthforbreaks<=10.5)) 
hyps10.0 <- subset(storage, subset=(depthforbreaks<=10.0)) 
hyps9.5 <- subset(storage, subset=(depthforbreaks<=9.5)) 
hyps9.0 <- subset(storage, subset=(depthforbreaks<=9.0)) 
hyps8.5 <- subset(storage, subset=(depthforbreaks<=8.5)) 
hyps8.0 <- subset(storage, subset=(depthforbreaks<=8.0)) 
hyps7.5 <- subset(storage, subset=(depthforbreaks<=7.5)) 
hyps7.0 <- subset(storage, subset=(depthforbreaks<=7.0)) 
hyps6.5 <- subset(storage, subset=(depthforbreaks<=6.5)) 
hyps6.0 <- subset(storage, subset=(depthforbreaks<=6.0)) 
hyps5.5 <- subset(storage, subset=(depthforbreaks<=5.5)) 
hyps5.0 <- subset(storage, subset=(depthforbreaks<=5.0)) 
hyps4.5 <- subset(storage, subset=(depthforbreaks<=4.5)) 
hyps4.0 <- subset(storage, subset=(depthforbreaks<=4.0)) 
hyps3.5 <- subset(storage, subset=(depthforbreaks<=3.5)) 
hyps3.0 <- subset(storage, subset=(depthforbreaks<=3.0)) 
hyps2.5 <- subset(storage, subset=(depthforbreaks<=2.5)) 
hyps2.0 <- subset(storage, subset=(depthforbreaks<=2.0)) 
hyps1.5 <- subset(storage, subset=(depthforbreaks<=1.5)) 
hyps1.0 <- subset(storage, subset=(depthforbreaks<=1.0)) 
hyps0.5 <- subset(storage, subset=(depthforbreaks<=0.5)) 

# calculate surface area per 0.5m depth change
hyps34.5a <- sum(hyps34.5$area_m2)
hyps34.0a <- sum(hyps34.0$area_m2)
hyps33.5a <- sum(hyps33.5$area_m2)
hyps33.0a <- sum(hyps33.0$area_m2)
hyps32.5a <- sum(hyps32.5$area_m2)
hyps32.0a <- sum(hyps32.0$area_m2)
hyps31.5a <- sum(hyps31.5$area_m2)
hyps31.0a <- sum(hyps31.0$area_m2)
hyps30.5a <- sum(hyps30.5$area_m2)
hyps30.0a <- sum(hyps30.0$area_m2)
hyps29.5a <- sum(hyps29.5$area_m2)
hyps29.0a <- sum(hyps29.0$area_m2)
hyps28.5a <- sum(hyps28.5$area_m2)
hyps28.0a <- sum(hyps28.0$area_m2)
hyps27.5a <- sum(hyps27.5$area_m2)
hyps27.0a <- sum(hyps27.0$area_m2)
hyps26.5a <- sum(hyps26.5$area_m2)
hyps26.0a <- sum(hyps26.0$area_m2)
hyps25.5a <- sum(hyps25.5$area_m2)
hyps25.0a <- sum(hyps25.0$area_m2)
hyps24.5a <- sum(hyps24.5$area_m2)
hyps24.0a <- sum(hyps24.0$area_m2)
hyps23.5a <- sum(hyps23.5$area_m2)
hyps23.0a <- sum(hyps23.0$area_m2)
hyps22.5a <- sum(hyps22.5$area_m2)
hyps22.0a <- sum(hyps22.0$area_m2)
hyps21.5a <- sum(hyps21.5$area_m2)
hyps21.0a <- sum(hyps21.0$area_m2)
hyps20.5a <- sum(hyps20.5$area_m2)
hyps20.0a <- sum(hyps20.0$area_m2)
hyps19.5a <- sum(hyps19.5$area_m2)
hyps19.0a <- sum(hyps19.0$area_m2)
hyps18.5a <- sum(hyps18.5$area_m2)
hyps18.0a <- sum(hyps18.0$area_m2)
hyps17.5a <- sum(hyps17.5$area_m2)
hyps17.0a <- sum(hyps17.0$area_m2)
hyps16.5a <- sum(hyps16.5$area_m2)
hyps16.0a <- sum(hyps16.0$area_m2)
hyps15.5a <- sum(hyps15.5$area_m2)
hyps15.0a <- sum(hyps15.0$area_m2)
hyps14.5a <- sum(hyps14.5$area_m2)
hyps14.0a <- sum(hyps14.0$area_m2)
hyps13.5a <- sum(hyps13.5$area_m2)
hyps13.0a <- sum(hyps13.0$area_m2)
hyps12.5a <- sum(hyps12.5$area_m2)
hyps12.0a <- sum(hyps12.0$area_m2)
hyps11.5a <- sum(hyps11.5$area_m2)
hyps11.0a <- sum(hyps11.0$area_m2)
hyps10.5a <- sum(hyps10.5$area_m2)
hyps10.0a <- sum(hyps10.0$area_m2)
hyps9.5a <- sum(hyps9.5$area_m2)
hyps9.0a <- sum(hyps9.0$area_m2)
hyps8.5a <- sum(hyps8.5$area_m2)
hyps8.0a <- sum(hyps8.0$area_m2)
hyps7.5a <- sum(hyps7.5$area_m2)
hyps7.0a <- sum(hyps7.0$area_m2)
hyps6.5a <- sum(hyps6.5$area_m2)
hyps6.0a <- sum(hyps6.0$area_m2)
hyps5.5a <- sum(hyps5.5$area_m2)
hyps5.0a <- sum(hyps5.0$area_m2)
hyps4.5a <- sum(hyps4.5$area_m2)
hyps4.0a <- sum(hyps4.0$area_m2)
hyps3.5a <- sum(hyps3.5$area_m2)
hyps3.0a <- sum(hyps3.0$area_m2)
hyps2.5a <- sum(hyps2.5$area_m2)
hyps2.0a <- sum(hyps2.0$area_m2)
hyps1.5a <- sum(hyps1.5$area_m2)
hyps1.0a <- sum(hyps1.0$area_m2)
hyps0.5a <- sum(hyps0.5$area_m2)

#### write area matrix for 0.5m depth increments for hyspography
area <- c(hyps34.5a, hyps34.0a, hyps33.5a, hyps33.0a, hyps32.5a, hyps32.0a, hyps31.5a, hyps31.0a, hyps30.5a, hyps30.0a, 
          hyps29.5a, hyps29.0a, hyps28.5a, hyps28.0a, hyps27.5a, hyps27.0a, hyps26.5a, hyps26.0a, hyps25.5a, hyps25.0a, 
          hyps24.5a, hyps24.0a, hyps23.5a, hyps23.0a, hyps22.5a, hyps22.0a, hyps21.5a, hyps21.0a, hyps20.5a, hyps20.0a, 
          hyps19.5a, hyps19.0a, hyps18.5a, hyps18.0a, hyps17.5a, hyps17.0a, hyps16.5a, hyps16.0a, hyps15.5a, hyps15.0a, 
          hyps14.5a, hyps14.0a, hyps13.5a, hyps13.0a, hyps12.5a, hyps12.0a, hyps11.5a, hyps11.0a, hyps10.5a, hyps10.0a, 
          hyps9.5a, hyps9.0a, hyps8.5a, hyps8.0a, hyps7.5a, hyps7.0a, hyps6.5a, hyps6.0a, hyps5.5a, hyps5.0a, 
          hyps4.5a, hyps4.0a, hyps3.5a, hyps3.0a, hyps2.5a, hyps2.0a, hyps1.5a, hyps1.0a, hyps0.5a)
area_m <- melt(area)
depth_m <- c(34.5, 34.0, 33.5, 33.0, 32.5, 32.0, 31.5, 31.0, 30.5, 30.0,
             29.5, 29.0, 28.5, 28.0, 27.5, 27.0, 26.5, 26.0, 25.5, 25.0,
             24.5, 24.0, 23.5, 23.0, 22.5, 22.0, 21.5, 21.0, 20.5, 20.0,
             19.5, 19.0, 18.5, 18.0, 17.5, 17.0, 16.5, 16.0, 15.5, 15.0,
             14.5, 14.0, 13.5, 13.0, 12.5, 12.0, 11.5, 11.0, 10.5, 10.0,
             9.5, 9.0, 8.5, 8.0, 7.5, 7.0, 6.5, 6.0, 5.5, 5.0,
             4.5, 4.0, 3.5, 3.0, 2.5, 2.0, 1.5, 1.0, 0.5)
depth_m_m <- melt(depth_m)
hypsography <- merge(depth_m_m, area_m, by='row.names', all=T)
hypsography <- rename.vars(hypsography, from=c('value.x', 'value.y'), to=c('depth_m', 'area_m2'))
hypsography$depth_m_asl <- hypsography$depth_m + 299.443
hypsography <- subset(hypsography, select=c('depth_m', 'depth_m_asl', 'area_m2'))

hypsography <- hypsography[with(hypsography, order(depth_m)), ]

plot(hypsography$area_m2, hypsography$depth_m)

setwd("C:/Users/steeleb/Dropbox/Lake Sunapee/Lake Sunapee Lake Model/GIS")
write.csv(hypsography, 'hypsography_matrix_0p5m_21Mar2017.csv', row.names = F)