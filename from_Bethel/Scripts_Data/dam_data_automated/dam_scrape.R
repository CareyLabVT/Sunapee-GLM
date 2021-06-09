# written by B. Steele (steeleb@caryinstitute.org)
# last modified 26May2021

# this script scrapes the dam data table for Lake Sunapee, NH, USA from the NH DES website for use in the CIBR-FLARE project

#load packages
library(tidyverse)
library(rvest)

#set save directory
dir <- 'datastore/'

#set url
url <- "https://www4.des.state.nh.us/rti_data/SUNNH_TABLE.HTML"

#set TZ
Sys.setenv(TZ='Etc/GMT+5') #force TZ to GMT+5 - ET no DST - for file reporting

#read in historical data
collated_dam <- read.csv(file.path(dir, 'SUNP_dam.csv'),
                         colClasses = 'character')%>% 
  mutate(datetime = as.POSIXct(datetime, tz= 'Etc/GMT+5')) # ET no DST observed

#read html, select table, format to dataframe
damdata_now <- url %>%
  read_html() %>%
  html_nodes(xpath="/html/body/div/table") %>%
  html_table %>% 
  as.data.frame() 

#get colnames for renaming and confirmation that the data structure has not changed
dam_names <- colnames(damdata_now)

#save the last observation for filtering
lastobs = max(collated_dam$datetime)

# if the structure hasn't changed, rename the columns and save as a .csv
if (length(dam_names) == 6) {
  #format dam data, filter for NA's across the board, filter for data after the collated dam data file
  damdata_now <- damdata_now %>%
    mutate(datetime = as.POSIXct(Date, format = '%m/%d/%Y %H:%M', tz= 'Etc/GMT+5')) %>% # ET no DST observed
    rename('lake_elev_ft' = dam_names[2],
           'obs_flow' = dam_names[3],
           'obs_stage' = dam_names[4],
           'precip_in' = dam_names[5],
           'air_temp_degF' = dam_names[6])  %>%
    select(datetime, lake_elev_ft:air_temp_degF) %>%
    filter(!is.na(lake_elev_ft) | !is.na(obs_flow) | !is.na(obs_stage) | !is.na(precip_in) | !is.na(air_temp_degF)) %>%
    filter(datetime > lastobs)
    #join with collated dam data
    collated_dam <- full_join(collated_dam, damdata_now) %>% 
      arrange(datetime)
    write.csv(collated_dam, file.path(dir, 'SUNP_dam.csv'), row.names = F)
    } else {
    #if the dam data have changed structure, write no file
      }

