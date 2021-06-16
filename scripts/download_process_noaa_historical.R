# download NOAA

library(aws.s3)
library(noaaGEFSpoint)
noaadir <- paste0(getwd(), '/data/noaa-data')
date <- "2021-04-01" 
cycle <- "00" #00, 06, 12, 18
prefix <- paste("noaa", paste0("NOAAGEFS_raw"), 
                date, cycle, sep="/")  

# creates list of files
object <- aws.s3::get_bucket("drivers",
                             prefix = prefix,
                             region = "data",
                             max = Inf,
                             base_url = "ecoforecast.org")
# downloads grib files from EFI server
# e.g. gec00.t00z.pgrb2a.0p50.f000.neon
# file naming convention: gep05 = 5th ensemble member, t00z = 00:00 UTC cycle, pgrb2a.0p50 = model and grid info, f720 = 720 hrs in the future, neon = subseted for the neon domain
# there should be 0-30 ensemble members
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

# process grib files into one .nc file for each ensemble member
process_gridded_noaa_download(lat_list = 43.393054,
                              lon_list = -72.052064,
                              site_list = 'SUNP', 
                              downscale = TRUE,
                              debias = FALSE,
                              process_dates = date,
                              overwrite = TRUE,
                              model_name = 'NOAAGEFS_6hr',
                              model_name_ds = 'NOAAGEFS_1hr',
                              model_name_ds_debias = 'NOAAGEFS_1hr_debias',
                              model_name_raw = 'NOAAGEFS_raw',
                              debias_coefficients = NULL,
                              num_cores = 1,
                              output_directory = paste0(noaadir, '/noaa'),
                              reprocess = FALSE)


# write a loop to REPEAT THIS PROCESS for each desired date