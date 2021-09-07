# combine temp and oxy observations for field data file

temp <- read.csv('./data/formatted-data/field_temp_noon_obs.csv')
oxy <- read.csv('./data/formatted-data/field_oxy_noon_obs.csv')

dat <- left_join(temp, oxy)
dat <- dat %>% 
  arrange(DateTime, Depth) %>% 
  select(DateTime, Depth, Temp, DOppm)

colnames(dat) <- c("DateTime", "Depth", "temp", "OXY_oxy")


# not converting into mmol/m3, but for future reference, the conversion is 1000/32??

write.csv(dat, row.names = FALSE, './data/formatted-data/field_temp_oxy_noon_obs.csv')
