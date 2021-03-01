# plot and format all driver and observational data

sim_folder <- getwd()

###### driver files
# met data
# hourly met data (SW, LW, air temp, rel hum, windspeed, rain)
# data ranges from 1979 to Dec 2018
met <- read.csv(paste0(sim_folder, '/from_Nicole/GLM_Sunapee_Drive/SunapeeMet_1979_2018EST.csv'))
met <- met %>% select(-c(X, X.1, X.2))
ggplot(met, aes(time, ShortWave)) +
  geom_line()
ggplot(met, aes(time, LongWave)) +
  geom_line()
ggplot(met, aes(time, AirTemp)) +
  geom_line()
ggplot(met, aes(time, RelHum)) +
  geom_line()
ggplot(met, aes(time, WindSpeed)) +
  geom_line()
ggplot(met, aes(time, Rain)) +
  geom_line()
write.csv(met, paste0(sim_folder, '/data/Sunapee_Met_1979_2018EST.csv'), row.names = FALSE)
met1 <- read.csv(paste0(sim_folder, '/data/Sunapee_Met_1979_2018EST.csv'))

# inflow data
# daily inflow data
# ranges from Dec 1981 to December 2018
inf <- read.csv(paste0(sim_folder, '/from_Nicole/GLM_Sunapee_Drive/oneInflow_14Jun19.csv'))
inf$time <- as.Date(inf$time)
ggplot(inf, aes(time, FLOW)) +
  geom_line()
ggplot(inf, aes(time, NIT_nit)) +
  geom_line()
ggplot(inf, aes(time, PHS_frp)) +
  geom_line()
#nutrient data look kinda weird? 
write.csv(inf, paste0(sim_folder, '/data/oneInflow_14Jun19.csv'), row.names = FALSE)

# outflow data
# daily outflow observations
# ranges from Dec 1981 to March 2016
out <- read.csv(paste0(sim_folder, '/from_Nicole/GLM_Sunapee_Drive/corr_outflow_impmodel_baseflow_23Mar2017.csv' ))
str(out)
out$time <- as.Date(out$time)
ggplot(out, aes(time, FLOW)) +
  geom_line()
write.csv(out, paste0(sim_folder, '/data/corr_outflow_impmodel_baseflow_23Mar2017.csv'), row.names = FALSE)
#########################################################################################################################
# format field observations

##### WATER TEMPERATURE
# this file includes maximum daily water temperatures at the buoy site in sunapee
# covers dates from August 2007 to October 2013
# measurements do not exceed 14m, and are only ~9.5m in 2018
# why are some of the surface measurements colder than they should be in summer stratified period???
buoy <- read.csv(paste0(sim_folder, '/from_Nicole/GLM_Sunapee_Drive/buoy_dailymax_temperature.csv'))
buoy$time <- '12:00:00'
buoy$DateTime <- as.POSIXct(paste0(buoy$DateTime, ' ', buoy$time))
ggplot(buoy, aes(x = DateTime, y = Temp)) +
  geom_point() +
  facet_wrap(~Depth)
ggplot(buoy, aes(x = DateTime, y = Temp)) +
  geom_point(aes(color = Depth))
write.csv(buoy, paste0(sim_folder, '/data/buoy_dailymax_temperature.csv'), row.names = FALSE)

# daily field observations of water level
# ranges from Dec 1981 to December 2013
field_stage <- file.path(paste0(sim_folder, '/from_Nicole/GLM_Sunapee_Drive/field_stage.csv'))
stage_obs <- read.csv(field_stage)
stage_obs$time <- '12:00:00'
stage_obs$DateTime <- as.POSIXct(paste0(stage_obs$datetime, ' ', stage_obs$time))
stage_obs <- stage_obs[,c(4,2)]
write.csv(stage_obs, paste0(sim_folder, '/data/field_stage.csv'), row.names = FALSE)

