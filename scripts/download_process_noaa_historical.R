# download NOAA

library(aws.s3)
date <- "2020-11-01" 
cycle <- "00"
prefix <- paste("noaa", paste0("NOAAGEFS_raw"), 
                date, cycle, sep="/")  
object <- aws.s3::get_bucket("drivers",
                             prefix = prefix,
                             region = "data",
                             base_url = "ecoforecast.org")

noaadir <- paste0(getwd(), '/data/noaa-data')
for(i in seq_along(object)){
  aws.s3::save_object(object[[i]], 
                      bucket = "drivers", 
                      file = file.path(noaadir, object[[i]]$Key),
                      region = "data",
                      base_url = "ecoforecast.org")
}

#remotes::install_githhub("rqthomas/noaaGEFSpoint")
source(paste0(getwd(), '/scripts/process_gridded_noaa_download.R'))
library(tidyverse)

process_gridded_noaa_download(lat_list = '43.393054',
                              lon_list = '-72.052064',
                              site_list = 'SUNP', 
                              downscale = TRUE,
                              debias = FALSE,
                              overwrite = TRUE,
                              model_name = 'NOAAGEFS_6hr',
                              model_name_ds = 'NOAAGEFS_1hr',
                              model_name_ds_debias = 'NOAAGEFS_1hr_debias',
                              model_name_raw = 'NOAAGEFS_raw',
                              debias_coefficients = NULL,
                              num_cores = 1,
                              output_directory = paste0(noaadir, '/noaa'),
                              reprocess = FALSE)
