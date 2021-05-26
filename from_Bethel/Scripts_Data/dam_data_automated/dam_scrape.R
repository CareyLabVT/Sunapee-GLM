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

#read html, select table, format to dataframe
damdata_now <- url %>%
  read_html() %>%
  html_nodes(xpath="/html/body/div/table") %>%
  html_table %>% 
  as.data.frame() 

#get colnames for renaming and confirmation that the data structure has not changed
dam_names <- colnames(damdata_now)

# if the structure hasn't changed, rename the columns and save as a .csv
if (length(dam_names) == 6) {
    damdata_now <- damdata_now %>% 
      mutate(datetime = as.POSIXct(Date, format = '%m/%d/%Y %H:%M', tz= 'Etc/GMT+5')) %>% # ET no DST observed
      rename('lake_elev_ft' = dam_names[2],
             'obs_flow' = dam_names[3],
             'obs_stage' = dam_names[4],
             'precip_in' = dam_names[5],
             'air_temp_degC' = dam_names[6]) 
    write.csv(damdata_now, paste0(dir, 'dam_download_', format(Sys.time(), '%Y%m%d_%H%M')))
  } else {}
