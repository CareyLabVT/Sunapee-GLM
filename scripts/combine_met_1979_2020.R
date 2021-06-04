# combine existing Sunapee met data file with newest met data from NLDAS

old <- read.csv('C:/Users/wwoel/Desktop/Sunapee-GLM/data/SunapeeMet_1979_2018EST.csv')
old <- old %>% 
  select(-X, -X.1, -X.2)

new <- read.csv('C:/Users/wwoel/Desktop/Sunapee-GLM/NLDASData/NLDAS_Data_2019_2020/Sunapee_2018_12_31_2020_12_31_alldata.csv')
new <- new %>% 
  select(local_dateTime, ShortWave.W_m2, LongWave.W_m2, AirTemp.C, RelHum, WindSpeed.m_s, Rain.m_day)

colnames(new) <- colnames(old)

met <- rbind(old, new)
met <- met[!duplicated(met$time), ]

write.csv(met, './data/SunapeeMet_1979_2020EST.csv', row.names = FALSE)

plot(as.Date(met$time), met$ShortWave, type = 'l')
