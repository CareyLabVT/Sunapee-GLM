# compare and build relationship between NLDAS data and buoy data from 2007 to present

nldas <- read.csv(paste0(getwd(), '/data/SunapeeMet_1979_2020EST.csv'))
# this is the format that GLM needs

buoy <- read.csv(paste0(getwd(), '/data/'))
