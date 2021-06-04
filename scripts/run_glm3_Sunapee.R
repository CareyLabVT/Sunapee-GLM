#require(devtools)
#devtools::install_github("robertladwig/GLM3r", ref = "v3.1.1")
#devtools::install_github("robertladwig/glmtools", ref = "ggplot_overhaul")
#install.packages("rLakeAnalyzer")
#install.packages("tidyverse")

library(glmtools)
library(GLM3r)
library(rLakeAnalyzer)
library(tidyverse)
library(lubridate)

#setwd('C:/Users/wwoel/Desktop/Sunapee-GLM')
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



# field files for comparison
#field_temp <- file.path(paste0(sim_folder, '/data/buoy_dailymax_temperature.csv'))
field_temp <- file.path(paste0(sim_folder, '/data/formatted-data/field_temp_noon_obs.csv'))
field_stage <- file.path(paste0(sim_folder, '/data/field_stage.csv'))
field_obs <- read.csv(field_temp)
field_obs <- na.omit(field_obs)
field_obs$DateTime <- as.POSIXct(field_obs$DateTime)

ggplot(data = field_obs, aes(x = DateTime, y = Depth)) +
  geom_point(aes(color = Temp)) +
  scale_y_reverse()

ggplot(data = field_obs, aes(x = DateTime, y = Temp)) +
  geom_point() +
  facet_wrap(~Depth) 
  
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
plot(stage_obs$DateTime, stage_obs$stage, ylim = c(0, 35), xlim = c(as.POSIXct('2007-01-01 00:00:00'), as.POSIXct('2014-01-01 00:00:00')))
points(water_height$DateTime, water_height$surface_height, type = 'l', col = 'red', lwd = 2)

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
                       z_out = 13.5)
ggplot(bottom_temp, aes(DateTime, temp_13.5)) +
  geom_line(aes(color = 'red')) +
  geom_point(data = field_obs[field_obs$Depth==13.5,], aes(as.POSIXct(DateTime), Temp)) +
  xlim(as.POSIXct('2007-01-01'), as.POSIXct('2010-05-20')) +
  ggtitle('Bottom water temperature') +
  xlab(label = '') + ylab(label = 'Temp. (deg C)') +
  theme_minimal()


temp_plot <- plot_var_compare(nc_file = out_file, 
                 field_file = field_temp, 
                 var_name = 'temp')


# depths with observations
#depths <- c(0.5, 0.85, 1.0, 1.5, 1.75, 1.85, 2.0, 2.5, 2.75, 2.85,
#            3.0, 3.5, 3.75, 3.85, 4.5, 4.75, 4.85, 5.5, 5.75, 5.85, 
#            6.5, 6.75, 6.85, 7.5, 7.75, 7.85, 8.5, 8.75, 8.85, 
#            9.5, 9.75, 9.85, 10.5, 11.5, 13.5)
depths <- c(0.5, 1.0, 1.5, 2.0, 2.5, 
            3.0, 3.5, 4.5, 5.5, 
            6.5, 7.5, 8.5,  
            9.5,  10.5, 11.5, 13.5)

temp_depths <- get_var(file = out_file, 
                       var_name = 'temp',
                       reference = 'surface',
                       z_out = c(0.5, 1, 13.5))
modtemp <- get_temp(out_file, reference="surface", z_out=depths) %>%
  pivot_longer(cols=starts_with("temp_"), names_to="Depth", names_prefix="temp_", values_to = "temp") %>%
  mutate(DateTime = as.POSIXct(strptime(DateTime, "%Y-%m-%d %H:%M:%S"))) %>% 
  rename(modtemp = temp) %>% 
  mutate(Depth = as.numeric(Depth))

#lets do depth by depth comparisons of the obs vs mod temps for each focal depth
watertemp<-left_join(modtemp, field_obs, by=c("DateTime","Depth")) %>%
  rename(obstemp = Temp) %>% 
  mutate(resid = modtemp - obstemp) %>% 
  mutate(yday = yday(DateTime)) %>% 
  filter(DateTime > as.POSIXct('2008-08-28'))

for(i in 1:length(unique(watertemp$Depth))){
  tempdf<-subset(watertemp, watertemp$Depth==depths[i])
  plot(tempdf$DateTime, tempdf$obstemp, col='red',
       ylab='temperature', xlab='time',
       main = paste0("Obs=Red,Mod=Black,Depth=",depths[i]),ylim=c(0,30))
  points(tempdf$DateTime, tempdf$obstemp, type = "l", col='red')
  points(tempdf$DateTime, tempdf$modtemp, type="l",col='black')
}


p1 <- ggplot(data = watertemp, aes(x = yday, y = resid)) +
  geom_point(aes(color = factor(Depth))) #+
  theme(legend.position = 'none')

p2 <- ggplot(data = watertemp, aes(x = resid, y = Depth)) +
  geom_point(aes(color = factor(Depth))) +
  scale_y_reverse() +
  theme(legend.position = 'none')

p3 <- ggplot(data = watertemp, aes(x = modtemp, y = obstemp)) +
  geom_point(aes(color = factor(Depth))) +
  theme(legend.position = 'none')

p4 <- ggplot(data = watertemp, aes(x = DateTime, y = modtemp)) +
  geom_point(aes(x = DateTime, y = obstemp, color = factor(Depth))) +
  geom_line(aes(color = factor(Depth))) +
  theme(legend.position = 'none')

p5 <- ggplot(data = watertemp, aes(x = resid)) +
  geom_histogram() +
  theme(legend.position = 'none')

p6 <- ggplot(data = watertemp, aes(x = modtemp, y = resid)) +
  geom_point(aes(color = factor(Depth))) +
  theme(legend.position = 'none')
p1
p2
p3
p4
p5
p6
library(patchwork)
p1 + p2/p3 + p4
all <- (p1 + p2 + p3)/(p4 + p5 + p6)

png('./output/diag_plots_24Mar21.png', height = 800, width = 650)
all + plot_annotation(
  title = "GLM run 2007-2018 (calibrated 2007-2011)"
  )
dev.off()

# calculate some rmse metrics
temp_rmse <- compare_to_field(nc_file = out_file, 
                              field_file = field_temp,
                              metric = 'water.temperature', 
                              as_value = FALSE, 
                              precision= 'hours')
temp_rmse
thermocline_rmse <- compare_to_field(nc_file = out_file, 
                                     field_file = field_temp,
                                     metric = 'thermo.depth', 
                                     as_value = FALSE, 
                                     precision= 'hours')
thermocline_rmse
epi_temp_rmse <- compare_to_field(nc_file = out_file, 
                                  field_file = field_temp,
                                  metric = 'epi.temperature',
                                  nml_file = 'glm3_woAED.nml',
                                  as_value = FALSE, 
                                  precision= 'hours')
epi_temp_rmse

hypo_temp_rmse <- compare_to_field(nc_file = out_file, 
                                   field_file = field_temp,
                                   metric = 'hypo.temperature',
                                   nml_file = 'glm3_woAED.nml',
                                   as_value = FALSE, 
                                   precision= 'hours')
hypo_temp_rmse
##############################################################################################################################################################
# auto calibration of water temp
var = 'temp'         # variable to which we apply the calibration procedure
path = getwd()       # simulation path/folder
nml_file = nml_file  # path of the nml configuration file that you want to calibrate on
glm_file = nml_file # # path of the gml configuration file
# which parameter do you want to calibrate? a sensitivity analysis helps
calib_setup <- data.frame('pars' = as.character(c('wind_factor','lw_factor','ch','sed_temp_mean',
                                                  'sed_temp_mean',
                                                  'coef_mix_hyp','Kw')),
                          'lb' = c(0.7,0.7,5e-4,3,8,0.4,0.1),
                          'ub' = c(2,2,0.002,8,20,0.6,0.8),
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
target.iter = 600    # refers to a maximum run of calibration iterations (stops after that many runs)
plotting = TRUE      # if TRUE, script will automatically save the contour plots
output = out_file    # path of the output file
field_file = field_temp # path of the field data
conversion.factor = 1 # conversion factor for the output, e.g. 1 for water temp.
file.copy(nml_file, "glm4.nml", overwrite = TRUE)
file.copy(nml_file, "glm3.nml", overwrite = TRUE)

# NOTE: this function runs glm3.nml so you must write over your nml file into glm3 and this file
# will be edited and run for calibration simulations

calibrate_sim(var = 'temp', 
              path = sim_folder, 
              field_file = field_temp, 
              nml_file = 'glm3.nml', 
              glm_file = 'glm3.nml', 
              calib_setup = calib_setup, 
              #glmcmd = NULL, 
              first.attempt = TRUE, 
              period = period, 
              scaling = TRUE, method = 'CMA-ES', metric = 'RMSE', 
              target.fit = 2.0, 
              target.iter = 600, 
              plotting = TRUE, 
              output = output, 
              verbose = TRUE,
              conversion.factor = 1)



##############################################################################################################################################################
# try running GLM with AED
# Run GLMr
GLM3r::run_glm(sim_folder, nml_file = 'glm3_wAED.nml', verbose = T)
sim_vars(out_file)

aed_outfile <- paste0(sim_folder, '/output/output_aed.nc')
# visualize change of water table over time
water_height <- get_surface_height(file = aed_outfile)
ggplot(water_height, aes(DateTime, surface_height)) +
  geom_line() +
  ggtitle('Surface water level') +
  xlab(label = '') + ylab(label = 'Water level (m)') +
  theme_minimal()

plot_compare_stage(nc_file = aed_outfile,
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
surface_temp <- get_var(file = aed_outfile, 
                        var_name = 'temp',
                        reference = 'surface',
                        z_out = 2)
ggplot(surface_temp, aes(DateTime, temp_2)) +
  geom_line() +
  ggtitle('Surface water temperature') +
  xlab(label = '') + ylab(label = 'Temp. (deg C)') +
  theme_minimal()
plot_var_nc(aed_outfile, var_name = 'temp')



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



