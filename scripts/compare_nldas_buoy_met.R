# compare and build relationship between NLDAS data and buoy data from 2007 to present

nldas <- read.csv(paste0(getwd(), '/data/SunapeeMet_1979_2020EST.csv'))
colnames(nldas)[2:7] <- paste0(colnames(nldas[2:7]), '_nldas')

buoy <- read.csv(paste0(getwd(), '/data/formatted-data/hist_buoy_met.csv'))
colnames(buoy)[2:4] <- paste0(colnames(buoy[2:4]), '_buoy')

met <- left_join(buoy, nldas)

plot(met$ShortWave_buoy, met$ShortWave_nldas)
abline(0,1, col = 'red')

plot(met$WindSpeed_buoy, met$WindSpeed_nldas)
abline(0,1, col = 'red')

plot(met$AirTemp_buoy, met$AirTemp_nldas)
abline(0,1, col = 'red')
