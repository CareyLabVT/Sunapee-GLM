require(devtools)
devtools::install_github("robertladwig/GLM3r", ref = "v3.1.1")
devtools::install_github("hdugan/glmtools", ref = "ggplot_overhaul")
install.packages("rLakeAnalyzer")
install.packages("tidyverse")

library(glmtools)
library(GLM3r)
library(rLakeAnalyzer)
library(tidyverse)

setwd('C:/Users/wwoel/Desktop/Sunapee-GLM')
glm_version()

# how does your computer know which version of glm.exe to use if there are multiple on your computer? can you specify? 

#### Example 1: reading the namelist file into R  ####
#glmcmd = './glm' # --> Set up the GLM Command for your system
#glm_template = 'glm3-template.nml' 
sim_folder <- getwd()
out_file <- file.path(sim_folder, "output","output.nc")
nml_file <- file.path(sim_folder, 'glm3_woAED.nml')

# edit the nml to reflect the file locations/name for meteo, inflow, outflow
# colnames met: Date,ShortWave,LongWave,AirTemp,RelHum,WindSpeed,Rain,Snow
#   NKW's file: SunapeeMet_1979_2016EST.csv
# colnames inflow: set the colnames within inflow_vars
#   NKW's file: oneInflow_14Jun19.csv
# colnames outflow: time,FLOW
#   NKW's file: corr_outflow_impmodel_baseflow_23Mar2017.csv



# format field observations
buoy <- read.csv(paste0(sim_folder, '/GLM_Sunapee_Drive/buoy_dailymax_temperature.csv'))
buoy$time <- '12:00:00'
buoy$DateTime <- as.POSIXct(paste0(buoy$DateTime, ' ', buoy$time))
write.csv(buoy, paste0(sim_folder, '/GLM_Sunapee_Drive/buoy_dailymax_temperature_datetime_formatted.csv'), row.names = FALSE)

field_stage <- file.path(paste0(sim_folder, '/GLM_Sunapee_Drive/field_stage.csv'))
stage_obs <- read.csv(field_stage)
stage_obs$time <- '12:00:00'
stage_obs$DateTime <- as.POSIXct(paste0(stage_obs$datetime, ' ', stage_obs$time))
stage_obs <- stage_obs[,c(4,2)]
write.csv(stage_obs, paste0(sim_folder, '/GLM_Sunapee_Drive/field_stage_datetime_formatted.csv'), row.names = FALSE)


# field files for comparison
field_temp <- file.path(paste0(sim_folder, '/GLM_Sunapee_Drive/buoy_dailymax_temperature_datetime_formatted.csv'))
field_stage <- file.path(paste0(sim_folder, '/GLM_Sunapee_Drive/field_stage_datetime_formatted.csv'))
field_obs <- read.csv(field_temp)

# Run GLMr
GLM3r::run_glm(sim_folder, nml_file = 'glm3_woAED.nml', verbose = T)
sim_vars(out_file)

# visualize change of water table over time
water_height <- get_surface_height(file = out_file)
ggplot(water_height, aes(DateTime, surface_height)) +
  geom_line() +
  ggtitle('Surface water level') +
  xlab(label = '') + ylab(label = 'Water level (m)') +
  theme_minimal()

plot_compare_stage(nc_file = out_file,
                   field_file = field_stage)

stage_obs <- read.csv(field_stage)
stage_obs$DateTime <- as.POSIXct(stage_obs$DateTime)
compare_stage <- left_join(water_height, stage_obs)
plot(stage_obs$DateTime, stage_obs$stage, ylim = c(0, 35))
points(water_height$DateTime, water_height$surface_height, type = 'l', col = 'red')

# visualize ice formation over time
ice_thickness <- get_ice(file = out_file)
ggplot(ice_thickness, aes(DateTime, `ice(m)`)) +
  geom_line() +
  ggtitle('Ice') +
  xlab(label = '') + ylab(label = 'Ice thickness (m)') +
  theme_minimal()

# visualize change of surface water temp. over time
surface_temp <- get_var(file = out_file, 
                        var_name = 'temp',
                        reference = 'surface',
                        z_out = 2)
ggplot(surface_temp, aes(DateTime, temp_2)) +
  geom_line() +
  ggtitle('Surface water temperature') +
  xlab(label = '') + ylab(label = 'Temp. (deg C)') +
  theme_minimal()
plot_var_nc(out_file, var_name = 'temp')



# visualize change of bottom water temp. over time
bottom_temp <- get_var(file = out_file, 
                       var_name = 'temp',
                       reference = 'surface',
                       z_out = 20)
ggplot(bottom_temp, aes(DateTime, temp_20)) +
  geom_line() +
  ggtitle('Bottom water temperature') +
  xlab(label = '') + ylab(label = 'Temp. (deg C)') +
  theme_minimal()

plot_var_compare(nc_file = out_file, 
                 field_file = field_temp, 
                 var_name = 'temp')

# calculate some rmse metrics
temp_rmse <- compare_to_field(nc_file = out_file, 
                              field_file = field_temp,
                              metric = 'water.temperature', 
                              as_value = FALSE, 
                              precision= 'hours')
thermocline_rmse <- compare_to_field(nc_file = out_file, 
                                     field_file = field_temp,
                                     metric = 'thermo.depth', 
                                     as_value = FALSE, 
                                     precision= 'hours')

epi_temp_rmse <- compare_to_field(nc_file = out_file, 
                                  field_file = field_temp,
                                  metric = 'epi.temperature',
                                  nml_file = 'glm3_woAED.nml',
                                  as_value = FALSE, 
                                  precision= 'hours')

hypo_temp_rmse <- compare_to_field(nc_file = out_file, 
                                   field_file = field_temp,
                                   metric = 'hypo.temperature',
                                   nml_file = 'glm3_woAED.nml',
                                   as_value = FALSE, 
                                   precision= 'hours')


# try running GLM with AED
# Run GLMr
GLM3r::run_glm(sim_folder, nml_file = 'glm3_wAED.nml', verbose = T)
sim_vars(out_file)

# visualize change of water table over time
water_height <- get_surface_height(file = out_file)
ggplot(water_height, aes(DateTime, surface_height)) +
  geom_line() +
  ggtitle('Surface water level') +
  xlab(label = '') + ylab(label = 'Water level (m)') +
  theme_minimal()

plot_compare_stage(nc_file = out_file,
                   field_file = field_stage)


#compare_stage <- left_join(water_height, stage_obs)
#plot(stage_obs$DateTime, stage_obs$stage, ylim = c(0, 35))
#points(water_height$DateTime, water_height$surface_height, type = 'l', col = 'red')

# visualize ice formation over time
ice_thickness <- get_ice(file = out_file)
ggplot(ice_thickness, aes(DateTime, `ice(m)`)) +
  geom_line() +
  ggtitle('Ice') +
  xlab(label = '') + ylab(label = 'Ice thickness (m)') +
  theme_minimal()

# visualize change of surface water temp. over time
surface_temp <- get_var(file = out_file, 
                        var_name = 'temp',
                        reference = 'surface',
                        z_out = 2)
ggplot(surface_temp, aes(DateTime, temp_2)) +
  geom_line() +
  ggtitle('Surface water temperature') +
  xlab(label = '') + ylab(label = 'Temp. (deg C)') +
  theme_minimal()
plot_var_nc(out_file, var_name = 'temp')



# visualize change of bottom water temp. over time
bottom_temp <- get_var(file = out_file, 
                       var_name = 'temp',
                       reference = 'surface',
                       z_out = 20)
ggplot(bottom_temp, aes(DateTime, temp_20)) +
  geom_line() +
  ggtitle('Bottom water temperature') +
  xlab(label = '') + ylab(label = 'Temp. (deg C)') +
  theme_minimal()

plot_var_compare(nc_file = out_file, 
                 field_file = field_temp, 
                 var_name = 'temp')

# calculate some rmse metrics
temp_rmse <- compare_to_field(nc_file = out_file, 
                              field_file = field_temp,
                              metric = 'water.temperature', 
                              as_value = FALSE, 
                              precision= 'hours')
thermocline_rmse <- compare_to_field(nc_file = out_file, 
                                     field_file = field_temp,
                                     metric = 'thermo.depth', 
                                     as_value = FALSE, 
                                     precision= 'hours')

epi_temp_rmse <- compare_to_field(nc_file = out_file, 
                                  field_file = field_temp,
                                  metric = 'epi.temperature',
                                  nml_file = 'glm3_woAED.nml',
                                  as_value = FALSE, 
                                  precision= 'hours')

hypo_temp_rmse <- compare_to_field(nc_file = out_file, 
                                   field_file = field_temp,
                                   metric = 'hypo.temperature',
                                   nml_file = 'glm3_woAED.nml',
                                   as_value = FALSE, 
                                   precision= 'hours')





# auto calibration
var = 'temp'         # variable to which we apply the calibration procedure
path = getwd()       # simulation path/folder
nml_file = nml_file  # path of the nml configuration file that you want to calibrate on
glm_file = nml_file # # path of the gml configuration file
# which parameter do you want to calibrate? a sensitivity analysis helps
calib_setup <- data.frame('pars' = as.character(c('wind_factor','lw_factor','ch','sed_temp_mean',
                                                  'sed_temp_mean',
                                                  'coef_mix_hyp','Kw')),
                          'lb' = c(0.7,0.7,5e-4,3,8,0.6,0.1),
                          'ub' = c(2,2,0.002,8,20,0.4,0.8),
                          'x0' = c(1,1,0.0013,5,13,0.5,0.3))
print(calib_setup)
glmcmd = NULL        # command to be used, default applies the GLM3r function
# glmcmd = '/Users/robertladwig/Documents/AquaticEcoDynamics_gfort/GLM/glm'        # custom path to executable
# Optional variables
first.attempt = TRUE # if TRUE, deletes all local csv-files that stores the 
#outcome of previous calibration runs
period = get_calib_periods(nml_file, ratio = 2) # define a period for the calibration, 
# this supports a split-sample calibration (e.g. calibration and validation period)
# the ratio value is the ratio of calibration period to validation period
print(period)
scaling = TRUE       # scaling of the variables in a space of [0,10]; TRUE for CMA-ES
verbose = TRUE
method = 'CMA-ES'    # optimization method, choose either `CMA-ES` or `Nelder-Mead`
metric = 'RMSE'      # objective function to be minimized, here the root-mean square error
target.fit = 2.0     # refers to a target fit of 2.0 degrees Celsius (stops when RMSE is below that)
target.iter = 20    # refers to a maximum run of 20 calibration iterations (stops after that many runs)
plotting = TRUE      # if TRUE, script will automatically save the contour plots
output = out_file    # path of the output file
field_file = field_data # path of the field data
conversion.factor = 1 # conversion factor for the output, e.g. 1 for water temp.

calibrate_sim(var = 'temp', path = sim_folder, 
              field_file = field_temp, 
              nml_file = 'glm3_woAED.nml', 
              glm_file = 'glm3_woAED.nml', 
              calib_setup = calib_setup, 
              #glmcmd = NULL, 
              first.attempt = TRUE, 
              period = period, 
              scaling = TRUE, method = 'CMA-ES', metric = 'RMSE', 
              target.fit = 2.0, target.iter = 20, 
              plotting = TRUE, 
              output = output, 
              verbose = TRUE,
              conversion.factor = 1)



